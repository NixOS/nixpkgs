{
  lib,
  buildPythonPackage,
  fetchPypi,
  adb-homeassistant,
  flask,
  pure-python-adb-homeassistant,
  pycryptodome,
  pyyaml,
  rsa,
}:
buildPythonPackage rec {
  pname = "firetv";
  version = "1.0.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YC3ndBHCyv+zIuT/Y/psxO65pQxfSxThOTDtfNh89RM=";
  };

  propagatedBuildInputs = [
    adb-homeassistant
    flask
    pure-python-adb-homeassistant
    pycryptodome
    pyyaml
    rsa
  ];

  # No Tests
  doCheck = false;

  meta = with lib; {
    description = "Communicate with an Amazon Fire TV device via ADB over a network";
    mainProgram = "firetv-server";
    homepage = "https://github.com/happyleavesaoc/python-firetv/";
    license = licenses.mit;
    maintainers = [ maintainers.makefu ];
  };
}
