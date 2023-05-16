{ lib
, buildPythonPackage
, fetchFromGitHub
, libsass
, six
, pytestCheckHook
, werkzeug
}:

buildPythonPackage rec {
  pname = "libsass";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "sass";
    repo = "libsass-python";
    rev = "refs/tags/${version}";
    hash = "sha256-5O4Er3jNUFy83m/K0HzYR+fHcSDqF/3M+fXaFZY8zEg=";
  };

  buildInputs = [ libsass ];

  propagatedBuildInputs = [ six ];

  preBuild = ''
    export SYSTEM_SASS=true;
  '';

  nativeCheckInputs = [
    pytestCheckHook
    werkzeug
  ];

  pytestFlagsArray = [ "sasstests.py" ];

  pythonImportsCheck = [ "sass" ];

  meta = with lib; {
    description = "Python binding for libsass to compile Sass/SCSS";
    homepage = "https://sass.github.io/libsass-python/";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
