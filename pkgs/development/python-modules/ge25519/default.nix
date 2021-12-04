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
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-f7xvZ92zRO3GLSdfgEyhkWVwAFT2TvKHy6+iF+k43bI=";
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
    substituteInPlace setup.py \
      --replace "bitlist~=0.5.1" "bitlist>=0.5.1" \
      --replace "parts~=1.1.2" "parts>=1.1.2"
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
