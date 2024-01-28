{ lib
, about-time
, buildPythonPackage
, click
, fetchFromGitHub
, grapheme
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "alive-progress";
  version = "3.1.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rsalmei";
    repo = "alive-progress";
    rev = "refs/tags/v${version}";
    hash = "sha256-27PgxQ9nw8p5hfaSf/jPYG7419o3i8B8R09o93szSOk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    about-time
    grapheme
  ];

  nativeCheckInputs = [
    click
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "alive_progress"
  ];

  meta = with lib; {
    description = "A new kind of Progress Bar, with real-time throughput, ETA, and very cool animations";
    homepage = "https://github.com/rsalmei/alive-progress";
    changelog = "https://github.com/rsalmei/alive-progress/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ thiagokokada ];
  };
}
