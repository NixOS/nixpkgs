{stdenv, fetchFromGitHub
  , llvmPackages
  , cmake, boehmgc, gmp, zlib, ncurses, boost
  , python, git, sbcl
}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "clasp";
  version = "0.4.99.20170801";

  src = fetchFromGitHub {
    owner = "drmeister";
    repo = "clasp";
    rev = "525ce1cffff39311e3e7df6d0b71fa267779bdf5";
    sha256 = "1jqya04wybgxnski341p5sycy2gysxad0s5q8d59z0f6ckj3v8k1";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake python git sbcl ];

  buildInputs = with llvmPackages; (
    builtins.map (x: stdenv.lib.overrideDerivation x
         (x: {NIX_CFLAGS_COMPILE= (x.NIX_CFLAGS_COMPILE or "") + " -frtti"; }))
      [ llvm clang clang-unwrapped clang ]) ++
  [
    gmp zlib ncurses
    boost boehmgc
    (boost.override {enableStatic = true; enableShared = false;})
    (stdenv.lib.overrideDerivation boehmgc
      (x: {configureFlags = (x.configureFlags or []) ++ ["--enable-static"];}))
  ];

  NIX_CFLAGS_COMPILE = " -frtti ";

  configurePhase = ''
    runHook preConfigure

    export CXX=clang++
    export CC=clang

    echo "
      INSTALL_PATH_PREFIX = '$out'
    " | sed -e 's/^ *//' > wscript.config

    python ./waf configure update_submodules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    python ./waf build_cboehm

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    python ./waf install_cboehm

    runHook postInstall
  '';

  meta = {
    inherit version;
    description = ''A Common Lisp implementation based on LLVM with C++ integration'';
    license = stdenv.lib.licenses.lgpl21Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "https://github.com/drmeister/clasp";
    broken = true; # 2018-09-08, no successful build since 2018-01-03
  };
}
