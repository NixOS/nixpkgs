{
  lib,
  buildPythonPackage,
  cached-property,
  click,
  fetchFromGitHub,
  packaging,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pythonfinder";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = "pythonfinder";
    tag = version;
    hash = "sha256-Qym/t+IejBMFHvBfIm+G5+J3GBC9O3RFrwSqHLuxwcg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ packaging ] ++ lib.optionals (pythonOlder "3.8") [ cached-property ];

  optional-dependencies = {
    cli = [ click ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "pythonfinder" ];

  meta = {
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "pythonfinder" ];

  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Cross platform search tool for finding Python";
    mainProgram = "pyfinder";
    homepage = "https://github.com/sarugaku/pythonfinder";
    changelog = "https://github.com/sarugaku/pythonfinder/blob/${src.tag}/CHANGELOG.rst";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
