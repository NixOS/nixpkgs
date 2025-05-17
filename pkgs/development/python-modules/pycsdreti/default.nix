{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  csdreti,
  pycsdr,
  fftw,
}:

buildPythonPackage rec {
  pname = "pycsdreti";
  version = "0.1.0-dev";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "luarvique";
    repo = "pycsdr-eti";
    rev = "0bd15e1af1f8f232a2c8e9c4b623e146066113bb";
    hash = "sha256-oQWbBfrX0y5jAy2c4RZJ1aQllKEJPpoFZhCLkC5Zg2w=";
  };

  propagatedBuildInputs = [
    fftw
    csdreti
  ];
  buildInputs = [
    pycsdr
    setuptools
  ];

  # make pycsdr header files available
  preBuild = ''
    ln -s ${pycsdr}/include/${python.libPrefix}/pycsdr src/pycsdr
  '';

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "pycsdr" ];

  meta = with lib; {
    homepage = "https://github.com/luarvique/pycsdr-eti";
    description = "bindings for the csdreti library";
    license = licenses.gpl3Only;
    maintainers = teams.c3d2.members ++ [ maintainers.mafo ];
  };
}
