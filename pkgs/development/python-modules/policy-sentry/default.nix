{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  click,
  fetchFromGitHub,
<<<<<<< HEAD
  hatchling,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  orjson,
  pytestCheckHook,
  pyyaml,
  requests,
  schema,
<<<<<<< HEAD
=======
  setuptools,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "policy-sentry";
<<<<<<< HEAD
  version = "0.15.1";
=======
  version = "0.14.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "salesforce";
    repo = "policy_sentry";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-G7V3BqgJs9nyvhZ9xzNwP50yz+2SZfps/gsW6U8eisk=";
  };

  pythonRelaxDeps = [ "beautifulsoup4" ];

  build-system = [ hatchling ];
=======
    hash = "sha256-o4l4jkh9ZNqc3Jovd10KUQLDBLn0sPWdgScq5Q2qd14=";
  };

  build-system = [ setuptools ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  dependencies = [
    beautifulsoup4
    click
    orjson
    pyyaml
    requests
    schema
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "policy_sentry" ];

<<<<<<< HEAD
  meta = {
    description = "Python module for generating IAM least privilege policies";
    homepage = "https://github.com/salesforce/policy_sentry";
    changelog = "https://github.com/salesforce/policy_sentry/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python module for generating IAM least privilege policies";
    homepage = "https://github.com/salesforce/policy_sentry";
    changelog = "https://github.com/salesforce/policy_sentry/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "policy_sentry";
  };
}
