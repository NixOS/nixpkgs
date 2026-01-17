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
  ]
  ++ lib.optionals stdenv.cc.isGNU [
    # Fix gcc15 compat for downstream packages e.g. sage
    # error: ‘bool’ cannot be defined via ‘typedef’
    (fetchpatch {
      url = "https://gitlab.com/embeddable-common-lisp/ecl/-/commit/1aec8f741f69fd736f020b7fe4d3afc33e60ae6a.patch";
      sha256 = "sha256-/cA6iOOob0ATViQm5EwBbdin5peqRMjLPKa7RjkrJ94=";
    })
    # error: too many arguments to function 'fn'; expected 0, have 1
    (fetchpatch {
      url = "https://gitlab.com/embeddable-common-lisp/ecl/-/commit/5b4e9c4bbd7cce4a678eecd493e56c495490e8b5.patch";
      sha256 = "sha256-QHxswFiW2rfDAQ98Sl+VVmyP4M/eIjJWQEcR/B+m398=";
    })
    (fetchpatch {
      url = "https://gitlab.com/embeddable-common-lisp/ecl/-/commit/5ec9e02f6db9694dcdef7574036f1e320d64a8af.patch";
      sha256 = "sha256-ZRah0IqOt6OQZGqlCq0RKiToyxsRXQEXAiSUGgqZnKU=";
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

  meta = {
    description = "Lisp implementation aiming to be small, fast and easy to embed";
    homepage = "https://common-lisp.net/project/ecl/";
    license = lib.licenses.mit;
    mainProgram = "ecl";
    teams = [ lib.teams.lisp ];
    platforms = lib.platforms.unix;
    changelog = "https://gitlab.com/embeddable-common-lisp/ecl/-/raw/${version}/CHANGELOG";
  };
}
