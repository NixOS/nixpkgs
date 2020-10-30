{stdenv, fetchurl
, libtool, autoconf, automake
, texinfo
, gmp, mpfr, libffi, makeWrapper
, noUnicode ? false
, gcc
, threadSupport ? true
, useBoehmgc ? false, boehmgc
}:
let
  s = # Generated upstream information
  rec {
    baseName="ecl";
    version="20.4.24";
    name="${baseName}-${version}";
    url="https://common-lisp.net/project/ecl/static/files/release/${name}.tgz";
    sha256="01qgdmr54wkj854f69qdm9sybrvd6gd21dpx4askdaaqybnkh237";
  };
  buildInputs = [
    libtool autoconf automake texinfo makeWrapper
  ];
  propagatedBuildInputs = [
    libffi gmp mpfr gcc
    # replaces ecl's own gc which other packages can depend on, thus propagated
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

  patches = [
  ];

  configureFlags = [
    (if threadSupport then "--enable-threads" else "--disable-threads")
    "--with-gmp-prefix=${gmp.dev}"
    "--with-libffi-prefix=${libffi.dev}"
    ]
    ++
    (stdenv.lib.optional (! noUnicode)
      "--enable-unicode")
    ;

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
    homepage = "https://common-lisp.net/project/ecl/";
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
