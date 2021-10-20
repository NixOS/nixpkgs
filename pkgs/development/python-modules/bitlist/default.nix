{ lib
, buildPythonPackage
, fetchPypi
, nose
, parts
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bitlist";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bX/Z5FBm21gX4ax/HfqD2bNotZyNFX7dHCEN5uZzQJQ=";
  };

  propagatedBuildInputs = [
    parts
  ];

  checkInputs = [
    pytestCheckHook
    nose
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "parts~=1.0.3" "parts>=1.0.3"
  '';

  pythonImportsCheck = [ "bitlist" ];

  meta = with lib; {
    description = "Python library for working with little-endian list representation of bit strings";
    homepage = "https://github.com/lapets/bitlist";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
