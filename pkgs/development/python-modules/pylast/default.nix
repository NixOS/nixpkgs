{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flaky,
  hatch-vcs,
  hatchling,
  httpx,
  pytest-random-order,
<<<<<<< HEAD
  pytest-recording,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pylast";
<<<<<<< HEAD
  version = "7.0.0";
=======
  version = "6.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pylast";
    repo = "pylast";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-u+wQxw0F/1oB8Kr4terSPo/8/RyPhiKxU0GruZo73H0=";
=======
    hash = "sha256-mwPiHTLFvaCFPZGqi0+T223Ickbm5JP2MJj4gqaj/qo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
<<<<<<< HEAD
    flaky
    pytest-random-order
    pytest-recording
    pytestCheckHook
=======
    pytest-random-order
    pytestCheckHook
    flaky
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  pythonImportsCheck = [ "pylast" ];

<<<<<<< HEAD
  meta = {
    description = "Python interface to last.fm (and compatibles)";
    homepage = "https://github.com/pylast/pylast";
    changelog = "https://github.com/pylast/pylast/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Python interface to last.fm (and compatibles)";
    homepage = "https://github.com/pylast/pylast";
    changelog = "https://github.com/pylast/pylast/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      fab
      rvolosatovs
    ];
  };
}
