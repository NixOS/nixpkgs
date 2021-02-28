{ lib, buildPythonPackage, isPy27, fetchPypi, pythonOlder
, importlib-metadata }:

buildPythonPackage rec {
  pname = "exdown";
  version = "0.7.1";
  format = "pyproject";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vnSso3vmPIjX7JX+NwoxguwqwPHocJACeh5H0ClPcUI=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  pythonImportsCheck = [ "exdown" ];

  meta = with lib; {
    description = "Extract code blocks from markdown";
    homepage = "https://github.com/nschloe/exdown";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
