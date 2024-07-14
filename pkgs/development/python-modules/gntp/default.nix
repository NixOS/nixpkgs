{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "gntp";
  version = "1.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9KTyAJ7Li7QaGq3dX7fAMIeyoUysLAOvApugS5Fm2uA=";
  };

  pythonImportsCheck = [
    "gntp"
    "gntp.notifier"
  ];

  # requires a growler service to be running
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/kfdm/gntp/";
    description = "Python library for working with the Growl Notification Transport Protocol";
    mainProgram = "gntp";
    license = licenses.mit;
    maintainers = [ maintainers.jfroche ];
  };
}
