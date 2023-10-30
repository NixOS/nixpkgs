{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

, build
, click
, coloredlogs
, packaging
, toml
, twine
, wheel
}:

buildPythonPackage rec {
  pname = "bork";
  version = "7.0.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "duckinator";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-frwkU2YesYK0RJNz9yqiXj1XeTZ8jg5oClri4hEYokg=";
  };

  propagatedBuildInputs = [
    build
    click
    coloredlogs
    packaging
    toml
    twine
    wheel
  ];

  meta = with lib; {
    description = "Python build and release management tool";
    homepage = "https://github.com/duckinator/bork";
    maintainers = with maintainers; [ nicoo ];
    platforms = platforms.all;
  };
}
