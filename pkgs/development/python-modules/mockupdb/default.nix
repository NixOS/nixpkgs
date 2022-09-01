{ lib
, buildPythonPackage
, fetchPypi
, pymongo
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mockupdb";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d36d0e5b6445ff9141e34d012fa2b5dfe589847aa1e3ecb8d774074962af944e";
  };

  propagatedBuildInputs = [ pymongo ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mockupdb" ];

  meta = with lib; {
    description = "Simulate a MongoDB server";
    license = licenses.asl20;
    homepage = "https://github.com/ajdavis/mongo-mockup-db";
    maintainers = with maintainers; [ globin ];
  };
}
