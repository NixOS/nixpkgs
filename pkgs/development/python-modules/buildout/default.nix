{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pip,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "zc-buildout";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "buildout";
    repo = "buildout";
    tag = version;
    hash = "sha256-o/iMCc8Jf+jNCHu3OnbCxD+oukoH/b7SUsdm6traO7k=";
  };

  propagatedBuildInputs = [
    setuptools
    pip
    wheel
  ];

  doCheck = false; # Missing package & BLOCKED on "zc.recipe.egg"

  pythonImportsCheck = [ "zc.buildout" ];

  meta = with lib; {
    description = "Software build and configuration system";
    mainProgram = "buildout";
    downloadPage = "https://github.com/buildout/buildout";
    homepage = "https://www.buildout.org";
    license = licenses.zpl21;
    maintainers = with maintainers; [ gotcha ];
  };
}
