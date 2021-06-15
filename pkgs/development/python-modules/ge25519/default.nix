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
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wgv0vqg8iv9y5d7if14gmcgslwd5zzgk322w9jaxdfbndldddik";
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

  pythonImportsCheck = [ "ge25519" ];

  meta = with lib; {
    description = "Python implementation of Ed25519 group elements and operations";
    homepage = "https://github.com/nthparty/ge25519";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
