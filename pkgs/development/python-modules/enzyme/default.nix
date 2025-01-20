{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage rec {
  pname = "enzyme";
  version = "0.5.2";
  pyproject = true;

  # Tests rely on files obtained over the network
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fPd5FI2eZusoOGA+rOFAxTw878i4/l1NWgOl+11Xs8E=";
  };

  nativeBuildInputs = [ setuptools ];

  meta = with lib; {
    homepage = "https://github.com/Diaoul/enzyme";
    license = licenses.mit;
    description = "Python video metadata parser";
  };
}
