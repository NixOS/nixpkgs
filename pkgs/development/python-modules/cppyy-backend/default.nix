{
  lib,
  fetchFromGitHub,
  pkg-config,
  cmake,
  cppyy-cling,
  setuptools,
  buildPythonPackage,
  stdenv,
  python,
  pip,
}:
buildPythonPackage rec {
  pname = "cppyy-backend";
  version = "1.15.3";

  src = fetchFromGitHub {
    owner = "wlav";
    repo = "cppyy-backend";
    tag = "clingwrapper-${version}";
    hash = "sha256-XTocvkAT5fKH49BnNjnv6ASWU7YGlotKqRMRZrN5HhA=";
  };

  patches = [
    ./backend-setup.patch
  ];

  nativeBuildInputs = [
    setuptools
    cmake
    cppyy-cling
    pip
  ];

  propagatedBuildInputs = [ cppyy-cling ];

  configurePhase = ''
    runHook preConfigure
    cd clingwrapper
    sed -i "s|%includes_placeholder%|return '\${cppyy-cling}/${python.sitePackages}/cppyy_backend/include'|" setup.py
    sed -i "s|%cflags_placeholder%|return '${lib.optionalString stdenv.hostPlatform.isLinux "-pthread"} -std=c++2a'|" setup.py
    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    env PIP_PREFIX=$out pip install dist/*.whl --no-use-pep517 --no-deps
    runHook postInstall
  '';

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "cppyy_backend" ];

  meta = {
    homepage = "https://github.com/wlav/cppyy-backend/blob/master/clingwrapper/";
    description = "C/C++ wrapper for Cling";
    license = lib.licenses.bsd3Lbnl;
    maintainers = with lib.maintainers; [ kittywitch ];
  };
}
