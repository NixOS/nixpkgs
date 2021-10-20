{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "idna";
  version = "3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nWQ/8KVbdi1c2xJLjqqZxmMi4hV7aRYLwyeW6CQ2Dm0=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "idna"
  ];

  meta = with lib; {
    description = "Internationalized Domain Names in Applications (IDNA)";
    homepage = "https://github.com/kjd/idna/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
