<<<<<<< HEAD
{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, jq
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jq";
  version = "1.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
{ lib, buildPythonPackage, fetchFromGitHub, cython, jq, pytestCheckHook }:

buildPythonPackage rec {
  pname = "jq";
  version = "1.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mwilliamson";
    repo = "jq.py";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-prH3yUFh3swXGsxnoax09aYAXaiu8o2M21ZbOp9HDJY=";
=======
    rev = version;
    hash = "sha256-1EQm5ShjFHbO1IO5QD42fsGHFGDBrJulLrcl+WeU7wo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    # Removes vendoring
    ./jq-py-setup.patch
  ];

<<<<<<< HEAD
  nativeBuildInputs = [
    cython
  ];

  buildInputs = [
    jq
  ];
=======
  nativeBuildInputs = [ cython ];

  buildInputs = [ jq ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preBuild = ''
    cython jq.pyx
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "jq"
  ];

  meta = with lib; {
    description = "Python bindings for jq, the flexible JSON processor";
    homepage = "https://github.com/mwilliamson/jq.py";
    changelog = "https://github.com/mwilliamson/jq.py/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ benley ];
=======
  pythonImportsCheck = [ "jq" ];

  meta = {
    description = "Python bindings for jq, the flexible JSON processor";
    homepage = "https://github.com/mwilliamson/jq.py";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ benley ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
