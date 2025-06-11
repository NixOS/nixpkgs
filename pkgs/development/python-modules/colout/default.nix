{
  lib,
  babel,
  buildPythonPackage,
  fetchFromGitHub,
  pygments,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "colout";
  version = "1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nojhan";
    repo = "colout";
    tag = "v${version}";
    hash = "sha256-7Dtf87erBElqVgqRx8BYHYOWv1uI84JJ0LHrcneczCI=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    babel
    pygments
  ];

  pythonImportsCheck = [ "colout" ];

  # This project does not have a unit test
  doCheck = false;

  meta = with lib; {
    description = "Color Up Arbitrary Command Output";
    mainProgram = "colout";
    homepage = "https://github.com/nojhan/colout";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ badele ];
  };
}
