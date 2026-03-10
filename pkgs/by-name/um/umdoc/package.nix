{
  stdenv,
  cmake,
  texliveFull,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  name = "umdoc";
  version = "0.3.0";
  src = fetchFromGitHub {
    owner = "craflin";
    repo = "umdoc";
    rev = "refs/tags/${version}";
    hash = "sha256-Dvvsw52Zw4FDqzhX75ymYO1OMN9cnsKwtC7c/X4Dx4k=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
     --replace-fail "include(CDeploy)" "" \
     --replace-fail "install_deploy_export()" ""
    head -n 42 CMakeLists.txt > tmp.txt
    mv tmp.txt CMakeLists.txt
    export HOME=$(pwd)
  '';
  buildPhase = '''';

  buildInputs = [
    cmake
    texliveFull
  ];

}
