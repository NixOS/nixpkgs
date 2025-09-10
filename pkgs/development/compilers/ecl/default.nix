{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  libtool,
  autoconf,
  automake,
  texinfo,
  gmp,
  mpfr,
  libffi,
  makeWrapper,
  noUnicode ? false,
  gcc,
  clang,
  threadSupport ? true,
  useBoehmgc ? false,
  boehmgc,
}:

let
  cc = if stdenv.cc.isClang then clang else gcc;
in
stdenv.mkDerivation rec {
  pname = "ecl";
  version = "24.5.10";

  src = fetchurl {
    url = "https://common-lisp.net/project/ecl/static/files/release/ecl-${version}.tgz";
    hash = "sha256-5Opluxhh4OSVOGv6i8ZzvQFOltPPnZHpA4+RQ1y+Yis=";
  };

  nativeBuildInputs = [
    libtool
    autoconf
    automake
    texinfo
    makeWrapper
  ];
  propagatedBuildInputs = [
    libffi
    gmp
    mpfr
    cc
    # replaces ecl's own gc which other packages can depend on, thus propagated
  ]
  ++ lib.optionals useBoehmgc [
    # replaces ecl's own gc which other packages can depend on, thus propagated
    boehmgc
  ];

  patches = [
    # https://gitlab.com/embeddable-common-lisp/ecl/-/merge_requests/1
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sagemath/sage/9.2/build/pkgs/ecl/patches/write_error.patch";
      sha256 = "0hfxacpgn4919hg0mn4wf4m8r7y592r4gw7aqfnva7sckxi6w089";
    })
  ];

  configureFlags = [
    (if threadSupport then "--enable-threads" else "--disable-threads")
    "--with-gmp-incdir=${lib.getDev gmp}/include"
    "--with-gmp-libdir=${lib.getLib gmp}/lib"
    "--with-libffi-incdir=${lib.getDev libffi}/include"
    "--with-libffi-libdir=${lib.getLib libffi}/lib"
  ]
  ++ lib.optionals useBoehmgc [
    "--with-libgc-incdir=${lib.getDev boehmgc}/include"
    "--with-libgc-libdir=${lib.getLib boehmgc}/lib"
  ]
  ++ lib.optional (!noUnicode) "--enable-unicode";

  hardeningDisable = [ "format" ];

  # ECL’s ‘make check’ only works after install, making it a de-facto
  # installCheck.
  doInstallCheck = true;
  installCheckTarget = "check";

  postInstall = ''
    sed -e 's/@[-a-zA-Z_]*@//g' -i $out/bin/ecl-config
    wrapProgram "$out/bin/ecl" --prefix PATH ':' "${
      lib.makeBinPath [
        cc # for the C compiler
        cc.bintools.bintools # for ar
      ]
    }"
  '';

  meta = with lib; {
    description = "Lisp implementation aiming to be small, fast and easy to embed";
    homepage = "https://common-lisp.net/project/ecl/";
    license = licenses.mit;
    mainProgram = "ecl";
    teams = [ lib.teams.lisp ];
    platforms = platforms.unix;
    changelog = "https://gitlab.com/embeddable-common-lisp/ecl/-/raw/${version}/CHANGELOG";
  };
}
