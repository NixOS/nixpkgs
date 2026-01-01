{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "colorful";
<<<<<<< HEAD
  version = "0.5.8";
=======
  version = "0.5.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timofurrer";
    repo = "colorful";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-nztVTfBimRDXwPYk3LNMZKa1ItbgqM2ukgZs8hI8TwE=";
=======
    hash = "sha256-iJ63Txn8wbZFlBrplTiHfkMfrCZfXxqlPRQgaMrwHCo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "colorful" ];

<<<<<<< HEAD
  meta = {
    description = "Library for terminal string styling";
    homepage = "https://github.com/timofurrer/colorful";
    changelog = "https://github.com/timofurrer/colorful/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kalbasit
      l33tname
    ];
=======
  meta = with lib; {
    description = "Library for terminal string styling";
    homepage = "https://github.com/timofurrer/colorful";
    changelog = "https://github.com/timofurrer/colorful/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
