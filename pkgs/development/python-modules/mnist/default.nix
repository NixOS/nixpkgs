{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mnist";
  version = "0.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "datapythonista";
    repo = "mnist";
    rev = "${pname}-${version}";
    hash = "sha256-sJ3a+qjpSVnw4MkAzp82+JmBOkjp1XUK4q3s2Nc9I58=";
  };

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  # disable tests which fail due to socket related errors
  disabledTests = [
    "test_test_images_has_right_size"
    "test_test_labels_has_right_size"
    "test_train_images_has_right_size"
    "test_train_labels_has_right_size"
  ];

  meta = {
    description = "Python utilities to download and parse the MNIST dataset";
    homepage = "https://github.com/datapythonista/mnist";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
