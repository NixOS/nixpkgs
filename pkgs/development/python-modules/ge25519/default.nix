{ lib
, bitlist
, buildPythonPackage
, fe25519
, fetchPypi
, fountains
, nose
, parts
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ge25519";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0M9RF8tlEoLyduvY3RvltGAnsus3HF6FEy22b6w6aUs=";
  };

  propagatedBuildInputs = [
    fe25519
    parts
    bitlist
    fountains
  ];

  checkInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ge25519"
  ];

  meta = with lib; {
    description = "Python implementation of Ed25519 group elements and operations";
    homepage = "https://github.com/nthparty/ge25519";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
