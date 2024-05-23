{
  lib,
  bluepy,
  buildPythonPackage,
  csrmesh,
  fetchPypi,
  pycryptodome,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "avion";
  version = "0.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v/0NwFmxDZ9kEOx5qs5L9sKzOg/kto79syctg0Ah+30=";
  };

  postPatch = ''
    # https://github.com/mjg59/python-avion/pull/16
    substituteInPlace setup.py \
      --replace "bluepy>==1.1.4" "bluepy>=1.1.4"
  '';

  propagatedBuildInputs = [
    bluepy
    csrmesh
    pycryptodome
    requests
  ];

  # Module has no test
  doCheck = false;

  # bluepy/uuids.json is not found
  # pythonImportsCheck = [ "avion" ];

  meta = with lib; {
    description = "Python API for controlling Avi-on Bluetooth dimmers";
    homepage = "https://github.com/mjg59/python-avion";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
