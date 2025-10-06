{
  lib,
  buildPythonPackage,
  click,
  ecdsa,
  hidapi,
  fetchPypi,
  pyaes,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ckcc-protocol";
  version = "1.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

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

  meta = with lib; {
    description = "Communicate with your Coldcard using Python";
    mainProgram = "ckcc";
    homepage = "https://github.com/Coldcard/ckcc-protocol";
    license = licenses.mit;
    maintainers = with maintainers; [ hkjn ];
  };
}
