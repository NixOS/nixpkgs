{ stdenv
, lib
, fetchFromGitHub
, guile
}:

stdenv.mkDerivation rec {
  pname = "camlboot";
  version = "unstable-2021-09-08";

  src = fetchFromGitHub {
    owner = "ekdohibs";
    repo = "camlboot";
    rev = "b103dc52411d94c8df69bc8b7915dd43aa40f8e8";
    sha256 = "JFj9C1HqHpUgbq6cFvIfd6mOPy67s2C9ZPWMqsrB4d0=";
    fetchSubmodules = true;
  };

  depsBuildBuild = [ guile ];

  patchPhase = ''
    runHook prePatch
    patchShebangs \
      compile_ocamlc.sh \
      compile_stdlib.sh \
      miniml/interp/cvt_emit.sh \
      miniml/interp/depend.sh \
      miniml/interp/genfileopt.sh \
      miniml/interp/interp \
      miniml/interp/interp.opt \
      miniml/interp/lex.sh \
      miniml/interp/make_opcodes.sh \
      timed.sh
    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild
    make -j$NIX_BUILD_CORES _boot/ocamlc
    make -j$NIX_BUILD_CORES fullboot
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r . $out
    runHook postInstall
  '';

  dontFixup = true;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Bootstrap of the OCaml compiler.";
    homepage = "https://github.com/Ekdohibs/camlboot";
    license = licenses.mit;
    maintainers = with maintainers; [ pnmadelaine r-burns ];
  };
}
