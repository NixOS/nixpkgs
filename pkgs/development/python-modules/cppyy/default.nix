{
  lib,
  fetchFromGitHub,
  pkg-config,
  cmake,
  buildPythonPackage,
  setuptools,
  wheel,
  pip,
  cppyy-cling,
  cppyy-backend,
  CPyCppyy,
}:
buildPythonPackage rec {
  pname = "cppyy";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "wlav";
    repo = "cppyy";
    tag = "${pname}-${version}";
    hash = "sha256-Q40zV7t7iQBJKjqpsvhqcsVtwuYzJkfBRoT1iQxh6rc=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
    pip
    cppyy-cling
    cppyy-backend
    CPyCppyy
  ];

  propagatedBuildInputs = [
    cppyy-cling
    cppyy-backend
    CPyCppyy
  ];

  dontUseCmakeConfigure = true;

  meta = {
    homepage = "https://github.com/wlav/cppyy";
    description = "Python C++ bindings interface based on Cling/LLVM";
    license = lib.licenses.bsd3Lbnl;
    maintainers = with lib.maintainers; [ kittywitch ];
  };
}
