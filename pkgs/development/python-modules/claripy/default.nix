{ lib
, buildPythonPackage
, setuptools
, cachetools
, decorator
, fetchFromGitHub
, future
, pysmt
, pythonOlder
, pytestCheckHook
, z3
}:

buildPythonPackage rec {
  pname = "claripy";
<<<<<<< HEAD
  version = "9.2.66";
=======
  version = "9.2.50";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-CDFZ6CN3pqNpwigYVHyKxwpa9iPfl4m/XDAo1YSRir8=";
=======
    hash = "sha256-bHo1hpLLrJVZ8BxupsavreY6JTmuGboLODT8so6Fx1c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cachetools
    decorator
    future
    pysmt
    z3
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # Use upstream z3 implementation
    substituteInPlace setup.cfg \
      --replace "z3-solver==4.10.2.0" ""
  '';

  pythonImportsCheck = [
    "claripy"
  ];

  meta = with lib; {
    description = "Python abstraction layer for constraint solvers";
    homepage = "https://github.com/angr/claripy";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
