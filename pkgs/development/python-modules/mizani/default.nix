{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, palettable
, pandas
, pytestCheckHook
, pythonOlder
, scipy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "mizani";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "has2k1";
    repo = "mizani";
    rev = "refs/tags/v${version}";
    hash = "sha256-4xk8FCUiNOp5n512asYKcjAS7fsyExyMQiWg14XWwHY=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    matplotlib
    palettable
    pandas
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=mizani --cov-report=xml" ""
  '';

  pythonImportsCheck = [
    "mizani"
  ];

  meta = with lib; {
    description = "Scales for Python";
    homepage = "https://github.com/has2k1/mizani";
    changelog = "https://github.com/has2k1/mizani/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ samuela ];
  };
}
