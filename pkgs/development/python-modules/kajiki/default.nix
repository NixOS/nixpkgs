{
  lib,
  babel,
  buildPythonPackage,
  fetchFromGitHub,
  linetable,
  pytestCheckHook,
  pythonOlder,
  hatchling,
}:

buildPythonPackage rec {
  pname = "kajiki";
<<<<<<< HEAD
  version = "1.0.2";
=======
  version = "1.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jackrosenthal";
    repo = "kajiki";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-bAgUMA9PlwsO7FRjwiKCsFffLWNU+Go1DToblmyWprk=";
=======
    hash = "sha256-5qsRxKeWCndi2r1HaIX/bm92oOWU4J4eM9aud6ai8ZQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedBuildInputs = [ linetable ];

  build-system = [ hatchling ];

  nativeCheckInputs = [
    babel
    pytestCheckHook
  ];

  pythonImportsCheck = [ "kajiki" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Module provides fast well-formed XML templates";
    mainProgram = "kajiki";
    homepage = "https://github.com/nandoflorestan/kajiki";
    changelog = "https://github.com/jackrosenthal/kajiki/releases/tag/${src.tag}";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
