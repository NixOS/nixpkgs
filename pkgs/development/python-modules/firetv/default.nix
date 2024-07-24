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
    sha256 = "602de77411c2caffb322e4ff63fa6cc4eeb9a50c5f4b14e13930ed7cd87cf513";
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
