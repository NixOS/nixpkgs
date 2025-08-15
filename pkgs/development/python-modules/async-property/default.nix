{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "async-property";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ryananguiano";
    repo = "async_property";
    tag = "v${version}";
    hash = "sha256-Bn8PDAGNLeL3/g6mB9lGQm1jblHIOJl2w248McJ3oaE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail \
        "setup_requirements = ['pytest-runner']" \
        "setup_requirements = []"
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "async_property" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  meta = {
    description = "Python decorator for async properties";
    homepage = "https://async-property.readthedocs.io/";
    changelog = "https://github.com/ryananguiano/async_property/raw/${src.rev}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
