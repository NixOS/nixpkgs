{ lib
, buildPythonPackage
, fetchPypi
, nose
, parts
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bitlist";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04dz64r21a39p8wph5qlhvs5y873qgk6xxjlzw8n695b8jm3ixir";
  };

  propagatedBuildInputs = [
    parts
  ];

  checkInputs = [
    pytestCheckHook
    nose
  ];

  pythonImportsCheck = [ "bitlist" ];

  meta = with lib; {
    description = "Python library for working with little-endian list representation of bit strings";
    homepage = "https://github.com/lapets/bitlist";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
