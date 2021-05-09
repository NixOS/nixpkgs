{ lib, buildPythonPackage, fetchPypi
, pymongo
}:

buildPythonPackage rec {
  pname = "mockupdb";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "130z5g96r52h362qc5jbf1g3gw3irb2wr946xlhgcv9ww9z64cl8";
  };

  propagatedBuildInputs = [ pymongo ];

  pythonImportsCheck = [ "mockupdb" ];

  meta = with lib; {
    description = "Simulate a MongoDB server";
    license = licenses.asl20;
    homepage = "https://github.com/ajdavis/mongo-mockup-db";
    maintainers = with maintainers; [ globin ];
  };
}
