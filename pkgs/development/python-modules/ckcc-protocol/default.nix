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
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

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

<<<<<<< HEAD
  meta = {
    description = "Communicate with your Coldcard using Python";
    mainProgram = "ckcc";
    homepage = "https://github.com/Coldcard/ckcc-protocol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hkjn ];
=======
  meta = with lib; {
    description = "Communicate with your Coldcard using Python";
    mainProgram = "ckcc";
    homepage = "https://github.com/Coldcard/ckcc-protocol";
    license = licenses.mit;
    maintainers = with maintainers; [ hkjn ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
