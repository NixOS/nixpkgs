{ lib, buildPythonPackage, fetchPypi, six, ply, nose, flake8 }:

buildPythonPackage rec {
  pname = "lesscpy";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7b664f60818a16afa8cc9f1dd6d9b17f944e0ce94e50787d76f81bc7a8648cce";
  };

  buildInputs = [ nose flake8 ];

  propagatedBuildInputs = [ six ply ];

  pythonImportsCheck = [ "lesscpy" ];

  meta = with lib; {
    description = "Python LESS compiler";
    homepage = "https://github.com/lesscpy/lesscpy/";
    license = licenses.mit;
    maintainers = with maintainers; [ sohalt ];
  };
}
