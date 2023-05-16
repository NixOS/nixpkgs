<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, scipy
, pythonOlder
}:

buildPythonPackage {
  pname = "fastpair";
  version = "unstable-2021-05-19";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
{ lib, buildPythonPackage, fetchFromGitHub, pytest-runner, pytest, scipy, pytestCheckHook }:

buildPythonPackage {
  pname = "fastpair";
  version = "2021-05-19";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "carsonfarmer";
    repo = "fastpair";
    rev = "d3170fd7e4d6e95312e7e1cb02e84077a3f06379";
<<<<<<< HEAD
    hash = "sha256-vSb6o0XvHlzev2+uQKUI66wM39ZNqDsppEc8rlB+H9E=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner",' ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];
=======
    sha256 = "1l8zgr8awg27lhlkpa2dsvghrb7b12jl1bkgpzg5q7pg8nizl9mx";
  };

  nativeBuildInputs = [ pytest-runner ];

  nativeCheckInputs = [ pytest pytestCheckHook ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    scipy
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "Data-structure for the dynamic closest-pair problem";
    homepage = "https://github.com/carsonfarmer/fastpair";
=======
    homepage = "https://github.com/carsonfarmer/fastpair";
    description = "Data-structure for the dynamic closest-pair problem";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai rakesh4g ];
  };
}
