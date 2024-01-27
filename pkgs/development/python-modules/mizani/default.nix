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
  version = "0.9.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "has2k1";
    repo = "mizani";
    rev = "refs/tags/v${version}";
    hash = "sha256-gZwM8/9ipcA73m1sPCz9oxD7cndli+qX9+gLILdbq1A=";
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
