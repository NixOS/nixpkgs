{ lib
, about-time
, buildPythonPackage
, click
, fetchFromGitHub
, grapheme
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "alive-progress";
  version = "3.1.4";

  src = fetchFromGitHub {
    owner = "rsalmei";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-27PgxQ9nw8p5hfaSf/jPYG7419o3i8B8R09o93szSOk=";
  };

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
    license = licenses.mit;
    maintainers = with maintainers; [ thiagokokada ];
  };
}
