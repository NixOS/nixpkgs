{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  hatchling,
  pytestCheckHook,
=======
  poetry-core,
  pytestCheckHook,
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "docstring-parser";
<<<<<<< HEAD
  version = "0.17.0";
  pyproject = true;

=======
  version = "0.16";
  pyproject = true;

  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "rr-";
    repo = "docstring_parser";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-hR+i1HU/ZpN6I3a8k/Wv2OrXgB4ls/A5OHZRqxEZS78=";
  };

  build-system = [ hatchling ];
=======
    hash = "sha256-xwV+mgCOC/MyCqGELkJVqQ3p2g2yw/Ieomc7k0HMXms=";
  };

  build-system = [ poetry-core ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "docstring_parser" ];

<<<<<<< HEAD
  meta = {
    description = "Parse Python docstrings in various flavors";
    homepage = "https://github.com/rr-/docstring_parser";
    changelog = "https://github.com/rr-/docstring_parser/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
=======
  meta = with lib; {
    description = "Parse Python docstrings in various flavors";
    homepage = "https://github.com/rr-/docstring_parser";
    changelog = "https://github.com/rr-/docstring_parser/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
