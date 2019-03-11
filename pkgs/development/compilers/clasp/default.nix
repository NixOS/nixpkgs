{ stdenv, fetchFromGitHub, fetchFromGitLab
, llvmPackages
, cmake, boehmgc, gmp, zlib, ncurses, boost, libelf
, python, git, sbcl
, wafHook
}:
let
  sicl = fetchFromGitHub {
    owner = "Bike";
    repo = "SICL";
    rev = "78052fb5f02a3814eb7295f3dcac09f21f98702b";
    sha256 = "0wnmp40310ls6q9gkr5ysfkj2qirq26ljjicnkqifc53mm0ghz4i";
  };
  cst = fetchFromGitHub {
    owner = "robert-strandh";
    repo = "Concrete-Syntax-Tree";
    rev = "8d8c5abf8f1690cb2b765241d81c2eb86d60d77e";
    sha256 = "1rs8a5nbfffdyli126sccd0z1a8h5axp222b4pgwvgfxsb9w7g3s";
  };
  c2mop = fetchFromGitHub {
    owner = "pcostanza";
    repo = "closer-mop";
    rev = "d4d1c7aa6aba9b4ac8b7bb78ff4902a52126633f";
    sha256 = "1amcv0f3vbsq0aqhai7ki5bi367giway1pbfxyc47r7q3hq5hw3c";
  };
  acclimation = fetchFromGitHub {
    owner = "robert-strandh";
    repo = "Acclimation";
    rev = "dd15c86b0866fc5d8b474be0da15c58a3c04c45c";
    sha256 = "0ql224qs3zgflvdhfbca621v3byhhqfb71kzy70bslyczxv1bsh2";
  };
  eclector = fetchFromGitHub {
    owner = "robert-strandh";
    repo = "Eclector";
    rev = "287ce817c0478668bd389051d2cc6b26ddc62ec9";
    sha256 = "0v7mgkq49ddyx5vvsradcp772y5l7cv9xrll3280hyginpm8w6q3";
  };
  alexandria = fetchFromGitHub {
    owner = "clasp-developers";
    repo = "alexandria";
    rev = "e5c54bc30b0887c237bde2827036d17315f88737";
    sha256 = "14h7a9fwimiw9gqxjm2h47d95bfhrm7b81f6si7x8vy18d78fn4g";
  };
  mps = fetchFromGitHub {
    owner = "Ravenbrook";
    repo = "mps";
    rev = "b8a05a3846430bc36c8200f24d248c8293801503";
    sha256 = "1q2xqdw832jrp0w9yhgr8xihria01j4z132ac16lr9ssqznkprv6";
  };
  asdf = fetchFromGitLab {
    domain = "gitlab.common-lisp.net";
    owner = "asdf";
    repo = "asdf";
    rev = "3.3.1.2";
    sha256 = "0ljr2vc0cb2wrijcyjmp9hcaj2bdhh05ci3zf4f43hdq6i2fgg6g";
  };
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "clasp";
  version = "0.8.99.20181128";

  src = fetchFromGitHub {
    owner = "drmeister";
    repo = "clasp";
    rev = "2f2b52ccb750048460562b5987a7eaf7a1aa4445";
    sha256 = "0ra55vdnk59lygwzlxr5cg16vb9c45fmg59wahaxclwm461w7fwz";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake python git sbcl wafHook ] ++
    (with llvmPackages; [ llvm clang ]);

  buildInputs = with llvmPackages;
  (
   builtins.map (x: stdenv.lib.overrideDerivation x
           (x: {NIX_CFLAGS_COMPILE= (x.NIX_CFLAGS_COMPILE or "") + " -frtti"; }))
   [ llvm clang clang-unwrapped clang ]) ++
  [
    gmp zlib ncurses
    boost boehmgc libelf
    (boost.override {enableStatic = true; enableShared = false;})
    (stdenv.lib.overrideDerivation boehmgc
      (x: {configureFlags = (x.configureFlags or []) ++ ["--enable-static"];}))
  ];

  NIX_CXXSTDLIB_COMPILE = " -frtti ";

  postPatch = ''
    echo "
      PREFIX = '$out'
    " | sed -e 's/^ *//' > wscript.config

    mkdir -p src/lisp/kernel/contrib/sicl
    mkdir -p src/lisp/kernel/contrib/Concrete-Syntax-Tree
    mkdir -p src/lisp/kernel/contrib/closer-mop
    mkdir -p src/lisp/kernel/contrib/Acclimation
    mkdir -p src/lisp/kernel/contrib/Eclector
    mkdir -p src/lisp/kernel/contrib/alexandria
    mkdir -p src/mps
    mkdir -p src/lisp/modules/asdf

    cp -rfT "${sicl}" src/lisp/kernel/contrib/sicl
    cp -rfT "${cst}" src/lisp/kernel/contrib/Concrete-Syntax-Tree
    cp -rfT "${c2mop}" src/lisp/kernel/contrib/closer-mop
    cp -rfT "${acclimation}" src/lisp/kernel/contrib/Acclimation
    cp -rfT "${eclector}" src/lisp/kernel/contrib/Eclector
    cp -rfT "${alexandria}" src/lisp/kernel/contrib/alexandria
    cp -rfT "${mps}" src/mps
    cp -rfT "${asdf}" src/lisp/modules/asdf

    chmod -R u+rwX src
    ( cd src/lisp/modules/asdf; make )
  '';

  buildTargets = "build_cboehm";
  installTargets = "install_cboehm";

  CLASP_SRC_DONTTOUCH = "true";

  meta = {
    inherit version;
    description = ''A Common Lisp implementation based on LLVM with C++ integration'';
    license = stdenv.lib.licenses.lgpl21Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    # Large, long to build, a private build of clang is needed, a prerelease.
    hydraPlatforms = [];
    homepage = "https://github.com/drmeister/clasp";
  };
}
