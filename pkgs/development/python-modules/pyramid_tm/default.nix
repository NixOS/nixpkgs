{ lib
, buildPythonPackage
, fetchPypi
, transaction
, pyramid
, setuptools
}:

buildPythonPackage rec {
  pname = "pyramid_tm";
  version = "2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d176792a50eb015d7865b44bd9b24a7bd0489fa9a5cebbd17b9e05048cef9014";
  };

  propagatedBuildInputs = [ pyramid transaction setuptools ];

  pythonImportsCheck = [ "pyramid_tm" ];

  meta = with lib; {
    description = "Transaction manager for pyramid";
    homepage = "https://github.com/Pylons/pyramid_tm";
    license = licenses.bsd0;
    maintainers = with maintainers; [ holgerpeters ];
  };
}
