{ lib
, buildPythonPackage
, fetchPypi
, requests
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "schiene";
  version = "0.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "014aaxmk7yxyml1xgfk3zqallyb5zi04m0v7jgqjkbjqq4n4j3ck";
  };

  propagatedBuildInputs = [
    requests
    beautifulsoup4
  ];

  # tests are not present
  doCheck = false;

  pythonImportsCheck = [ "schiene" ];

  meta = with lib; {
    description = "Python library for interacting with Bahn.de";
    homepage = "https://github.com/kennell/schiene";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
