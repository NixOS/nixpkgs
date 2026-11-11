{
  lib,
  babel,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pygments,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "colout";
  version = "1.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nojhan";
    repo = "colout";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7Dtf87erBElqVgqRx8BYHYOWv1uI84JJ0LHrcneczCI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    babel
    pygments
  ];

  pythonImportsCheck = [ "colout" ];

  # This project does not have a unit test
  doCheck = false;

  meta = {
    description = "Color Up Arbitrary Command Output";
    mainProgram = "colout";
    homepage = "https://github.com/nojhan/colout";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ badele ];
  };
})
