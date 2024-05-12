{ buildPythonPackage
, einops
, fetchPypi
, jax
, jaxlib
, lib
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "augmax";
  version = "0.3.2";
  pyproject = true;

  disbaled = pythonOlder "3.6";

  # Using fetchPypi because the latest version was not tagged on GitHub.
  # Switch back to fetchFromGitHub when a tag will be available
  # https://github.com/khdlr/augmax/issues/8
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pf1DTaHA7D+s2rqwwGYlJrJOI7fok+WOvOCtZhOOGHo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ einops jax ];

  # augmax does not have any tests at the time of writing (2022-02-19), but
  # jaxlib is necessary for the pythonImportsCheckPhase.
  nativeCheckInputs = [ jaxlib ];

  pythonImportsCheck = [ "augmax" ];

  meta = with lib; {
    description = "Efficiently Composable Data Augmentation on the GPU with Jax";
    homepage = "https://github.com/khdlr/augmax";
    changelog = "https://github.com/khdlr/augmax/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
