{ stdenv, fetchurl, fetchpatch
, libtool, autoconf, automake
, gmp, mpfr, libffi, makeWrapper
, noUnicode ? false
, gcc
, threadSupport ? false
, useBoehmgc ? true, boehmgc
}:

assert useBoehmgc -> boehmgc != null;

let
  s = # Generated upstream information
  rec {
    baseName="ecl";
    version="16.1.2";
    name="${baseName}-${version}";
    url="https://common-lisp.net/project/ecl/static/files/release/ecl-16.1.2.tgz";
    sha256="16ab8qs3awvdxy8xs8jy82v8r04x4wr70l9l2j45vgag18d2nj1d";
  };
  buildInputs = [
    libtool autoconf automake makeWrapper
  ];
  propagatedBuildInputs = [
    libffi gmp mpfr gcc
  ] ++ stdenv.lib.optionals useBoehmgc [
    # replaces ecl's own gc which other packages can depend on, thus propagated
    boehmgc
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs propagatedBuildInputs;

  src = fetchurl {
    inherit (s) url sha256;
  };

  configureFlags = [
    (if threadSupport then "--enable-threads" else "--disable-threads")
    "--with-gmp-prefix=${gmp.dev}"
    "--with-libffi-prefix=${libffi.dev}"
    ]
    ++
    (stdenv.lib.optional (! noUnicode)
      "--enable-unicode")
    ;

  patches = [
    (fetchpatch {
      # Avoid infinite loop, see https://gitlab.com/embeddable-common-lisp/ecl/issues/43 (fixed upstream)
      name = "avoid-infinite-loop.patch";
      url = "https://gitlab.com/embeddable-common-lisp/ecl/commit/caba1989f40ef917e7486f41b9cd5c7e3c5c2d79.patch";
      sha256 = "07vw91psbc9gdn8grql46ra8lq3bgkzg5v480chnbryna4sv6lbb";
    })
    (fetchpatch {
      # Fix getcwd with long pathnames
      # Rebased version of
      # https://gitlab.com/embeddable-common-lisp/ecl/commit/ac5f011f57a85a38627af154bc3ee7580e7fecd4.patch
      name = "getcwd.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/ecl/patches/16.1.2-getcwd.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "1fbi8gn7rv8nqff5mpaijsrch3k3z7qc5cn4h1vl8qrr8xwqlqhb";
    })
    ./ecl-1.16.2-libffi-3.3-abi.patch
  ];

  hardeningDisable = [ "format" ];

  postInstall = ''
    sed -e 's/@[-a-zA-Z_]*@//g' -i $out/bin/ecl-config
    wrapProgram "$out/bin/ecl" \
      --prefix PATH ':' "${gcc}/bin" \
      --prefix NIX_LDFLAGS ' ' "-L${gmp.lib or gmp.out or gmp}/lib" \
      --prefix NIX_LDFLAGS ' ' "-L${libffi.lib or libffi.out or libffi}/lib"
  '';

  meta = {
    inherit (s) version;
    description = "Lisp implementation aiming to be small, fast and easy to embed";
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
  };
}
