{
  lib,
  buildPythonPackage,
  click,
  ecdsa,
  hidapi,
  fetchPypi,
  pyaes,
}:

buildPythonPackage rec {
  pname = "ckcc-protocol";
  version = "1.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Sdb30OtBOn2Txfh9N86yY1JAIxjkwL7/NB+fA8RI10w=";
  };

  propagatedBuildInputs = [
    click
    ecdsa
    hidapi
    pyaes
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ckcc" ];

  meta = {
    description = "Communicate with your Coldcard using Python";
    mainProgram = "ckcc";
    homepage = "https://github.com/Coldcard/ckcc-protocol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hkjn ];
  };
}
