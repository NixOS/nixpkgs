{
  lib,
  bluepy,
  buildPythonPackage,
  csrmesh,
  fetchPypi,
  pycryptodome,
  requests,
}:

buildPythonPackage rec {
  pname = "avion";
  version = "0.10";
  format = "setuptools";

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

  meta = {
    description = "Python API for controlling Avi-on Bluetooth dimmers";
    homepage = "https://github.com/mjg59/python-avion";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
