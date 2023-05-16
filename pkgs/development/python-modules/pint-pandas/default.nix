{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, setuptools
, setuptools-scm
, wheel
=======
, fetchpatch
, setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pint
, pandas
, pytestCheckHook
}:

<<<<<<< HEAD
buildPythonPackage rec {
  pname = "pint-pandas";
  version = "0.4";
=======
buildPythonPackage {
  pname = "pint-pandas";
  # Latest release contains bugs and failing tests.
  version = "unstable-2022-11-24";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hgrecco";
    repo = "pint-pandas";
<<<<<<< HEAD
    rev = version;
    hash = "sha256-FuH6wksSCkkL2AyQN46hwTnfeAZFwkWRl6KEEhsxmUY=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
=======
    rev = "c58a7fcf9123eb65f5e78845077b205e20279b9d";
    hash = "sha256-gMZNJSJxtSZvgU4o71ws5ZA6tgD2M5c5oOrn62DRyMI=";
  };

  nativeBuildInputs = [
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    pint
    pandas
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
<<<<<<< HEAD
    broken = stdenv.isDarwin;
=======
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Pandas support for pint";
    license = licenses.bsd3;
    homepage = "https://github.com/hgrecco/pint-pandas";
    maintainers = with maintainers; [ doronbehar ];
  };
}
