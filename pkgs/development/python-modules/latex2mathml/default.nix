{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
<<<<<<< HEAD
=======
, setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, multidict
, xmljson
}:

buildPythonPackage rec {
  pname = "latex2mathml";
<<<<<<< HEAD
  version = "3.76.0";
=======
  version = "3.75.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "roniemartinez";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-CoWXWgu1baM5v7OC+OlRHZB0NkPue4qFzylJk4Xq2e4=";
=======
    hash = "sha256-ezSksOUvSUqo8MktjKU5ZWhAxtFHwFkSAOJ8rG2jgoU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  format = "pyproject";

  nativeBuildInputs = [
    poetry-core
  ];

<<<<<<< HEAD
=======
  propagatedBuildInputs = [
    setuptools  # needs pkg_resources at runtime
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    pytestCheckHook
    multidict
    xmljson
  ];

  # Disable code coverage in check phase
  postPatch = ''
    sed -i '/--cov/d' pyproject.toml
  '';

  pythonImportsCheck = [ "latex2mathml" ];

  meta = with lib; {
    description = "Pure Python library for LaTeX to MathML conversion";
    homepage = "https://github.com/roniemartinez/latex2mathml";
    changelog = "https://github.com/roniemartinez/latex2mathml/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
