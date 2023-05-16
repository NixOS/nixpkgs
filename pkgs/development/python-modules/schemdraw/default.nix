{ lib
, buildPythonPackage
, pythonOlder
<<<<<<< HEAD
, fetchFromGitHub
=======
, fetchFromBitbucket
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pyparsing
, matplotlib
, latex2mathml
, ziafont
, ziamath
, pytestCheckHook
, nbval
}:

buildPythonPackage rec {
  pname = "schemdraw";
<<<<<<< HEAD
  version = "0.17";
=======
  version = "0.16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

<<<<<<< HEAD
  src = fetchFromGitHub {
    owner = "cdelker";
    repo = pname;
    rev = version;
    hash = "sha256-wa/IeNGZynU/xKwyFwebXcFaruhBFqGWsrZYaIEVa8Q=";
=======
  src = fetchFromBitbucket {
    owner = "cdelker";
    repo = pname;
    rev = version;
    hash = "sha256-W9sXtYI8gEwQPRo50taEGT6AQG1tdAbeCtX49eHVvFQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pyparsing
  ];

  passthru.optional-dependencies = {
    matplotlib = [
      matplotlib
    ];
    svgmath = [
      latex2mathml
      ziafont
      ziamath
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    nbval
    matplotlib
    latex2mathml
    ziafont
    ziamath
  ];

  # Strip out references to unfree fonts from the test suite
  postPatch = ''
    substituteInPlace test/test_styles.ipynb --replace "font='Times', " ""
  '';

  pytestFlagsArray = [ "--nbval-lax" ];

  pythonImportsCheck = [ "schemdraw" ];

  meta = with lib; {
    description = "A package for producing high-quality electrical circuit schematic diagrams";
    homepage = "https://schemdraw.readthedocs.io/en/latest/";
    changelog = "https://schemdraw.readthedocs.io/en/latest/changes.html";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
