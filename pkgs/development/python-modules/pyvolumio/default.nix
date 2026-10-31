{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pyvolumio";
  version = "0.1.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = "PyVolumio";
    rev = "v${version}";
    hash = "sha256-kMhdKZhOiD61bcEBRHWP4Ve3W0yU81RZwJylcRV129s=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyvolumio" ];

  meta = {
    description = "Python module to control Volumio";
    homepage = "https://github.com/OnFreund/PyVolumio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
