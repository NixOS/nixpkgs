{
  lib,
  fetchFromGitHub,
  fetchurl,
  cmake,
  setuptools,
  buildPythonPackage,
  rootVersion ? "6.32.08",
}:
buildPythonPackage rec {
  pname = "cppyy-cling";
  version = "6.32.8";

  sourceRoot = ".";
  srcs =
    let
      clingwrapper = fetchFromGitHub {
        owner = "wlav";
        repo = "cppyy-backend";
        rev = "cppyy-cling-${version}";
        hash = "sha256-XTocvkAT5fKH49BnNjnv6ASWU7YGlotKqRMRZrN5HhA=";
      };
      cern-root = fetchurl {
        url = "https://root.cern/download/root_v${rootVersion}.source.tar.gz";
        hash = "sha256-Ka1JRact/xoAnDJqZbb6XuJHhJiCMlHTzvhqLL63eyc=";
      };
    in
    [
      clingwrapper
      cern-root
    ];

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    setuptools
  ];

  patchPhase = ''
    # facilitate generation of compiledata.h
    patchShebangs source/cling/src/build/unix/compiledata.sh

    # https://github.com/wlav/cppyy-backend/blob/master/cling/create_src_directory.py#L39
    # Give build process the CERN root tarball due to sandbox
    mkdir -p source/cling/releases
    tar czf root_v${rootVersion}.source.tar.gz root-${rootVersion}
    cp root_v${rootVersion}.source.tar.gz source/cling/releases/
    cd source/cling
    python setup.py egg_info
    python create_src_directory.py
  '';

  dontUseCmakeConfigure = true;

  meta = with lib; {
    homepage = "https://github.com/wlav/cppyy-backend/blob/master/cling/";
    description = "Re-packaged Cling, as backend for cppyy";
    license = licenses.bsd3Lbnl;
    maintainers = with maintainers; [ kittywitch ];
  };
}
