{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  libtool,
  autoconf,
  automake,
  gmp,
  mpfr,
  libffi,
  makeWrapper,
  noUnicode ? false,
  gcc,
  threadSupport ? false,
  useBoehmgc ? true,
  boehmgc,
}:

stdenv.mkDerivation rec {
  pname = "ecl";
  version = "16.1.2";

  src = fetchurl {
    url = "https://common-lisp.net/project/ecl/static/files/release/ecl-${version}.tgz";
    sha256 = "sha256-LUgrGgpPvV2IFDRRcDInnYCMtkBeIt2R721zNTRGS5k=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    makeWrapper
    libtool
  ];
  propagatedBuildInputs =
    [
      libffi
      gmp
      mpfr
      gcc
    ]
    ++ lib.optionals useBoehmgc [
      # replaces ecl's own gc which other packages can depend on, thus propagated
      boehmgc
    ];

  configureFlags = [
    (if threadSupport then "--enable-threads" else "--disable-threads")
    "--with-gmp-incdir=${lib.getDev gmp}/include"
    "--with-gmp-libdir=${lib.getLib gmp}/lib"
    # -incdir, -libdir doesn't seem to be supported for libffi
    "--with-libffi-prefix=${lib.getDev libffi}"
  ] ++ lib.optional (!noUnicode) "--enable-unicode";

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
      url = "https://raw.githubusercontent.com/sagemath/sage/07d6c37d18811e2b377a9689790a7c5e24da16ba/build/pkgs/ecl/patches/16.1.2-getcwd.patch";
      sha256 = "1fbi8gn7rv8nqff5mpaijsrch3k3z7qc5cn4h1vl8qrr8xwqlqhb";
    })
    ./ecl-1.16.2-libffi-3.3-abi.patch
  ];

  hardeningDisable = [ "format" ];

  postInstall =
    ''
      sed -e 's/@[-a-zA-Z_]*@//g' -i $out/bin/ecl-config
      wrapProgram "$out/bin/ecl" \
        --prefix PATH ':' "${
          lib.makeBinPath [
            gcc # for the C compiler
            gcc.bintools.bintools # for ar
          ]
        }" \
    ''
    # ecl 16.1.2 is too old to have -libdir for libffi and boehmgc, so we need to
    # use NIX_LDFLAGS_BEFORE to make gcc find these particular libraries.
    # Since it is missing even the prefix flag for boehmgc we also need to inject
    # the correct -I flag via NIX_CFLAGS_COMPILE. Since we have access to it, we
    # create the variables with suffixSalt (which seems to be necessary for
    # NIX_CFLAGS_COMPILE even).
    + lib.optionalString useBoehmgc ''
      --prefix NIX_CFLAGS_COMPILE_${gcc.suffixSalt} ' ' "-I${lib.getDev boehmgc}/include" \
      --prefix NIX_LDFLAGS_BEFORE_${gcc.bintools.suffixSalt} ' ' "-L${lib.getLib boehmgc}/lib" \
    ''
    + ''
      --prefix NIX_LDFLAGS_BEFORE_${gcc.bintools.suffixSalt} ' ' "-L${lib.getLib libffi}/lib"
    '';

  meta = with lib; {
    description = "Lisp implementation aiming to be small, fast and easy to embed";
    license = licenses.mit;
    maintainers = lib.teams.lisp.members;
    platforms = platforms.unix;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
