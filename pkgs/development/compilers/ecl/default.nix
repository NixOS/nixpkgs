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
  version = "26.3.27";

  src = fetchurl {
    url = "https://common-lisp.net/project/ecl/static/files/release/ecl-${version}.tgz";
    hash = "sha256-QW1XB78R0rPY0z1nkUGaeG5MxZrAzD7FBe5ZtRqfXJo=";
  };

  patches = [
    # https://gitlab.com/embeddable-common-lisp/ecl/-/merge_requests/370
    (fetchpatch {
      name = "allocate-first_env-dynamically.patch";
      url = "https://gitlab.com/embeddable-common-lisp/ecl/-/commit/61a14dfc6681f674ae5673856c0749fdf4af6564.patch";
      hash = "sha256-DOn0mtlW1Bl59LxqEQiE90ZJlXDSbTbxL0s8NNL882o=";
      includes = [ "src/c/main.d" ];
    })

    # https://gitlab.com/embeddable-common-lisp/ecl/-/work_items/838
    (fetchpatch {
      name = "clang-miscompilation.patch";
      url = "https://gitlab.com/embeddable-common-lisp/ecl/-/commit/d39cc449f770c52cc4c8b297cf600d7bd53d172a.patch";
      hash = "sha256-C+zVjAY/+hQ4Te62DQxIQsHu0AqewygmSEQpcmrA5EU=";
    })
  ];

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
