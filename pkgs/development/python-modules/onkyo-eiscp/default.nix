{
  lib,
  buildPythonPackage,
  fetchPypi,
  docopt,
  netifaces,
}:

buildPythonPackage rec {
  pname = "onkyo-eiscp";
  version = "1.2.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "761abb16c654a1136763b927d094174d41f282809e44ea32cd47e199dd79d9c9";
  };

  propagatedBuildInputs = [
    docopt
    netifaces
  ];

  meta = {
    description = "Control Onkyo receivers over ethernet";
    mainProgram = "onkyo";
    homepage = "https://github.com/miracle2k/onkyo-eiscp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
