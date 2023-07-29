{ lib
, buildPythonPackage
, fetchFromGitHub
, scipy
, setuptools
, setuptools-scm
, torch
, wheel
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "linear_operator";
  version = "0.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "cornellius-gp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0f3F3k3xJACbx42jtwsAmjZwPAOfLywZs8VOrwWicc4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'find_version("linear_operator", "version.py")' \"$version\"
  '';

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
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
