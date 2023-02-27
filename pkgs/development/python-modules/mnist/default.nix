{ buildPythonPackage, fetchFromGitHub, isPy27, lib, mock, numpy, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mnist";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "datapythonista";
    repo = "mnist";
    rev = "${pname}-${version}";
    sha256 = "17r37pbxiv5dw857bmg990x836gq6sgww069w3q5jjg9m3xdm7dh";
  };

  propagatedBuildInputs = [ numpy ] ++ lib.optional isPy27 mock;

  nativeCheckInputs = [ pytestCheckHook ];

  dontUseSetuptoolsCheck = true;

  # disable tests which fail due to socket related errors
  disabledTests = [
    "test_test_images_has_right_size"
    "test_test_labels_has_right_size"
    "test_train_images_has_right_size"
    "test_train_labels_has_right_size"
  ];

  meta = with lib; {
    description = "Python utilities to download and parse the MNIST dataset";
    homepage = "https://github.com/datapythonista/mnist";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dmrauh ];
  };
}

