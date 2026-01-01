{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  requests,
}:

buildPythonPackage rec {
  pname = "pydexcom";
<<<<<<< HEAD
  version = "0.5.0";
  pyproject = true;

=======
  version = "0.4.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "gagebenne";
    repo = "pydexcom";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-IqSZZHe5epcgO2uoIsGkNaac3+UplHzqEcFWTzwAqPg=";
=======
    hash = "sha256-cf3AhqaA5aij2NCeFqruoeE0ovJSgZgEnVHcE3iXJ1s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [ requests ];

  # Tests are interacting with the Dexcom API
  doCheck = false;

  pythonImportsCheck = [ "pydexcom" ];

<<<<<<< HEAD
  meta = {
    description = "Python API to interact with Dexcom Share service";
    homepage = "https://github.com/gagebenne/pydexcom";
    changelog = "https://github.com/gagebenne/pydexcom/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python API to interact with Dexcom Share service";
    homepage = "https://github.com/gagebenne/pydexcom";
    changelog = "https://github.com/gagebenne/pydexcom/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
