{
  lib,
  buildPythonPackage,
  fetchPypi,
  argcomplete,
  colorama,
  jmespath,
  pygments,
  pyyaml,
  six,
  tabulate,
  mock,
  vcrpy,
  pytest,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "knack";
<<<<<<< HEAD
  version = "0.13.0";
=======
  version = "0.12.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-3aNbT/TFdrJQGhjw7C8v4KOl+czoJl1AZtMR5e1LW8Y=";
=======
    hash = "sha256-cfKmtCrpowLkMkMyD6Be2wmxkzn88fMx9bbQe/l/UpE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedBuildInputs = [
    argcomplete
    colorama
    jmespath
    pygments
    pyyaml
    six
    tabulate
  ];

  nativeCheckInputs = [
    mock
    vcrpy
    pytest
  ];

  checkPhase = ''
    HOME=$TMPDIR pytest .
  '';

  pythonImportsCheck = [ "knack" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/microsoft/knack";
    description = "Command-Line Interface framework";
    changelog = "https://github.com/microsoft/knack/blob/v${version}/HISTORY.rst";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "https://github.com/microsoft/knack";
    description = "Command-Line Interface framework";
    changelog = "https://github.com/microsoft/knack/blob/v${version}/HISTORY.rst";
    platforms = platforms.all;
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
