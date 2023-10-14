{ lib
, buildPythonPackage
, fetchFromGitHub
, jaxtyping
, pytestCheckHook
, scipy
, setuptools
, setuptools-scm
, torch
, wheel
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

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    jaxtyping
    scipy
    torch
  ];

  pythonImportsCheck = [ "linear_operator" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

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
