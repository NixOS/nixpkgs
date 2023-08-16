{ lib
, buildPythonPackage
, fetchFromGitHub
, jaxtyping
, scipy
, torch
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "linear_operator";
  version = "0.5.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "cornellius-gp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7NkcvVDwFaLHBZZhq7aKY3cWxe90qeKmodP6cVsdrPM=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'find_version("linear_operator", "version.py")' \"$version\"
  '';

  propagatedBuildInputs = [
    jaxtyping
    scipy
    torch
  ];

  checkInputs = [
    pytestCheckHook
  ];
  pythonImportsCheck = [ "linear_operator" ];
  disabledTests = [
    # flaky numerical tests
    "test_svd"
  ];

  meta = with lib; {
    description = "A LinearOperator implementation to wrap the numerical nuts and bolts of GPyTorch";
    homepage = "https://github.com/cornellius-gp/linear_operator/";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
