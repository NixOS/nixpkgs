{ lib
, buildPythonPackage
, fetchFromGitHub
, linear_operator
, scikit-learn
, torch
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "gpytorch";
  version = "1.10";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "cornellius-gp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KY3ItkVjBfIYMkZAmD56EBGR9YN/MRN7b2K3zrK6Qmk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'find_version("gpytorch", "version.py")' \"$version\"
  '';

  propagatedBuildInputs = [
    linear_operator
    scikit-learn
    torch
  ];

  checkInputs = [
    pytestCheckHook
  ];
  pythonImportsCheck = [ "gpytorch" ];
  disabledTests = [
    # AssertionError on number of warnings emitted
    "test_deprecated_methods"
    # flaky numerical tests
    "test_classification_error"
    "test_matmul_matrix_broadcast"
  ];

  meta = with lib; {
    description = "A highly efficient and modular implementation of Gaussian Processes, with GPU acceleration";
    homepage = "https://gpytorch.ai";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
