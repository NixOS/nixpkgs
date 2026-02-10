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
  version = "1.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zZPU0+MwjqRYCqa+W0YTqCZv2WsMwa9R5xaN7ye77OU=";
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
