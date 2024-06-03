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
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "buildout";
    repo = "buildout";
    rev = version;
    sha256 = "J/ymUCFhl7EviHMEYSUCTky0ULRT8aL4gNCGxrbqJi0=";
  };

  propagatedBuildInputs = [
    setuptools
    pip
    wheel
  ];

  doCheck = false; # Missing package & BLOCKED on "zc.recipe.egg"

  pythonImportsCheck = [ "zc.buildout" ];

  meta = with lib; {
    description = "A software build and configuration system";
    mainProgram = "buildout";
    downloadPage = "https://github.com/buildout/buildout";
    homepage = "https://www.buildout.org";
    license = licenses.zpl21;
    maintainers = with maintainers; [ gotcha ];
  };
}
