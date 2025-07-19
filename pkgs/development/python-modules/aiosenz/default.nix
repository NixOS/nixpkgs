{
  lib,
  authlib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiosenz";
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "milanmeu";
    repo = "aiosenz";
    rev = version;
    hash = "sha256-ODdWPS14zzptxuS6mff51f0s1SYnIqjF40DmvT0sL0w=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    httpx
    authlib
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aiosenz" ];

  meta = with lib; {
    description = "Python wrapper for the nVent Raychem SENZ RestAPI";
    homepage = "https://github.com/milanmeu/aiosenz";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
