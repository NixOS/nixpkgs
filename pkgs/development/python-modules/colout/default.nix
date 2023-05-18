{ lib
, babel
, buildPythonPackage
, fetchFromGitHub
, pygments
, python3Packages
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "colout";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "nojhan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7Dtf87erBElqVgqRx8BYHYOWv1uI84JJ0LHrcneczCI=";
  };

  nativeBuildInputs = [
    babel
    pygments
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    babel
    pygments
  ];

  pythonImportsCheck = [ "colout" ];

  # This project does not have a unit test
  doCheck = false;

  meta = with lib; {
    description = "Color Up Arbitrary Command Output";
    homepage = "https://github.com/nojhan/colout";
    license = licenses.gpl3;
    maintainers = with maintainers; [ badele ];
  };
}
