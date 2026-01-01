{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  diskcache-stubs,
  diskcache,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fetchFromGitHub,
  jinja2,
  packaging,
  poetry-core,
  pyparsing,
  pytestCheckHook,
<<<<<<< HEAD
  pyyaml,
  requests,
  types-pyyaml,
  typing-extensions,
  writableTmpDirAsHomeHook,
=======
  pythonOlder,
  pyyaml,
  requests,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "pysigma";
<<<<<<< HEAD
  version = "1.0.2";
  pyproject = true;

=======
  version = "0.11.23";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-s/czHIwQzcDvK6PBEFflYnT0S97qDUoYiH5ZPlnhMGE=";
  };

  pythonRelaxDeps = [
    "diskcache-stubs"
    "jinja2"
    "packaging"
    "pyparsing"
    "types-pyyaml"
=======
    hash = "sha256-mRDevojeVHgp66RTB90XXeEGP8LYlWCLGmAMv9DW3SA=";
  };

  pythonRelaxDeps = [
    "jinja2"
    "packaging"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  build-system = [ poetry-core ];

  dependencies = [
<<<<<<< HEAD
    diskcache
    diskcache-stubs
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    jinja2
    packaging
    pyparsing
    pyyaml
    requests
<<<<<<< HEAD
    types-pyyaml
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];
=======
  ];

  nativeCheckInputs = [ pytestCheckHook ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  disabledTests = [
    # Tests require network connection
    "test_sigma_plugin_directory_default"
<<<<<<< HEAD
    "test_sigma_plugin_directory_get_plugins_compatible"
    "test_sigma_plugin_find_compatible_version"
    "test_sigma_plugin_installation"
    "test_sigma_plugin_pysigma_version_from_pypi"
    "test_sigma_plugin_version_compatible"
    "test_validator_valid_attack_tags_online"
    "test_validator_valid_d3fend_tags_online"
=======
    "test_sigma_plugin_installation"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  pythonImportsCheck = [ "sigma" ];

<<<<<<< HEAD
  meta = {
    description = "Library to parse and convert Sigma rules into queries";
    homepage = "https://github.com/SigmaHQ/pySigma";
    changelog = "https://github.com/SigmaHQ/pySigma/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Library to parse and convert Sigma rules into queries";
    homepage = "https://github.com/SigmaHQ/pySigma";
    changelog = "https://github.com/SigmaHQ/pySigma/releases/tag/v${version}";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
