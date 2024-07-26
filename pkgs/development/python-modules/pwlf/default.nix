{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, scipy
, numpy
, pydoe
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "pwlf";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cjekel";
    repo = "piecewise_linear_fit_py";
    rev = "v${version}";
    hash = "sha256-gjdahulpHjBmOlKOCPF9WmrWe4jn/+0oVI4o09EX7qE=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    scipy
    numpy
    pydoe
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [ "pwlf" ];

  meta = with lib; {
    description = "Fit piecewise linear data for a specified number of line segments";
    homepage = "https://jekel.me/piecewise_linear_fit_py/";
    changelog = "https://github.com/cjekel/piecewise_linear_fit_py/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
