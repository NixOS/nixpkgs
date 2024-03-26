{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  robotframework,
  click,
  colorama,
  pathspec,
  tomli,
  rich-click,
  jinja2,
}:

buildPythonPackage rec {
  pname = "robotframework-tidy";
  version = "4.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MarketSquare";
    repo = "robotframework-tidy";
    rev = "${version}";
    hash = "sha256-pWW7Ex184WgnPfqHg5qQjfE+9UPvCmE5pwkY8jrp9bI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    robotframework
    click
    colorama
    pathspec
    tomli
    rich-click
    jinja2
  ];

  meta = with lib; {
    changelog = "https://github.com/MarketSquare/robotframework-tidy/blob/main/docs/releasenotes/${version}.rst";
    description = "Code autoformatter for Robot Framework";
    homepage = "https://robotidy.readthedocs.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ otavio ];
  };
}
