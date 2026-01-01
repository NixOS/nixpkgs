{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mypy-extensions,
  pytest-xdist,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ruamel-yaml,
  schema-salad,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cwl-upgrader";
<<<<<<< HEAD
  version = "1.2.14";
  pyproject = true;

=======
  version = "1.2.12";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "common-workflow-language";
    repo = "cwl-upgrader";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-bkICax7HIEo8ypttXgDmCl82JfVkV2T11fLRK1/0hz8=";
=======
    hash = "sha256-cfEd1XAu31u+NO27d3RNA5lhCpRpYK8NeaCxhQ/1GNU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    # Version detection doesn't work for schema_salad
    substituteInPlace pyproject.toml \
      --replace '"schema_salad",' ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    mypy-extensions
    ruamel-yaml
    schema-salad
  ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cwlupgrader" ];

<<<<<<< HEAD
  meta = {
    description = "Library to upgrade CWL syntax to a newer version";
    homepage = "https://github.com/common-workflow-language/cwl-upgrader";
    changelog = "https://github.com/common-workflow-language/cwl-upgrader/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cwl-upgrader";
=======
  meta = with lib; {
    description = "Library to upgrade CWL syntax to a newer version";
    mainProgram = "cwl-upgrader";
    homepage = "https://github.com/common-workflow-language/cwl-upgrader";
    changelog = "https://github.com/common-workflow-language/cwl-upgrader/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
