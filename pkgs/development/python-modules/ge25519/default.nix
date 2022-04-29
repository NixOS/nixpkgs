{ lib
, bitlist
, buildPythonPackage
, fe25519
, fetchPypi
, fountains
, nose
, parts
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ge25519";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8GsNY62SusUmQcaqlhKOPHbd0jvZulCaxMxeob37JJM=";
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

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov=ge25519 --cov-report term-missing" ""
  '';


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
