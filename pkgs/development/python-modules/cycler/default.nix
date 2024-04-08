{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# tests
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cycler";
  version = "0.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matplotlib";
    repo = "cycler";
    rev = "refs/tags/v${version}";
    hash = "sha256-5L0APSi/mJ85SuKCVz+c6Fn8zZNpRm6vCeBO0fpGKxg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/matplotlib/cycler/releases/tag/v${version}";
    description = "Composable style cycles";
    homepage = "https://github.com/matplotlib/cycler";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
