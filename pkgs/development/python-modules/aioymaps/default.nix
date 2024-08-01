{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aioymaps";
  version = "1.2.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tEl2tX/mB8uYTYj1YFDs/2sPXiv6897jCEmsFCWBXYg=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioymaps" ];

  meta = with lib; {
    description = "Python package fetch data from Yandex maps";
    homepage = "https://github.com/devbis/aioymaps";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
