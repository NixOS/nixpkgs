{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, aiohttp
}:

buildPythonPackage rec {
  pname = "huisbaasje-client";
  version = "0.1.0";

  disabled = pythonOlder "3.6"; # requires python version >=3.6

  src = fetchPypi {
    inherit pname version;
    sha256 = "6bc02384c37aba01719269b05882572050c80cd9abf98caa38519308e05b7db8";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # no tests on PyPI, no tags on GitHub
  doCheck = false;

  pythonImportsCheck = [ "huisbaasje.huisbaasje" ];

  meta = with lib; {
    description = "Client for Huisbaasje";
    homepage = "https://github.com/denniss17/huisbaasje-client";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
