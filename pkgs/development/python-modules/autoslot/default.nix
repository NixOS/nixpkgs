{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "autoslot";
<<<<<<< HEAD
  version = "2025.11.1";
  pyproject = true;

=======
  version = "2024.12.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "cjrh";
    repo = "autoslot";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-mPGfBUSKkskiiokqo/TJWdDzuvcg/LDULx+Gx8LexV8=";
=======
    hash = "sha256-wYjsBrjvSZFHDt0HLrnS9Xwk8EHVQupfPSkQnUFmMAk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "autoslot" ];

<<<<<<< HEAD
  meta = {
    description = "Automatic __slots__ for your Python classes";
    homepage = "https://github.com/cjrh/autoslot";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Automatic __slots__ for your Python classes";
    homepage = "https://github.com/cjrh/autoslot";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
