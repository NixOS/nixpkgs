{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pynose,
  setuptools,
}:

buildPythonPackage rec {
  version = "0.1.4";
  pname = "forbiddenfruit";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clarete";
    repo = "forbiddenfruit";
    rev = "refs/tags/${version}";
    hash = "sha256-yHIZsVn2UVmWeBNIzWDE6AOwAXZilPqXo+bVtXqGkJk=";
  };

  build-system = [ setuptools ];

  env.FFRUIT_EXTENSION = "true";

  pythonImportsCheck = [ "forbiddenfruit" ];

  nativeCheckInputs = [ pynose ];

  # https://github.com/clarete/forbiddenfruit/pull/47 required to switch to pytest
  checkPhase = ''
    runHook preCheck

    find ./build -name '*.so' -exec mv {} tests/unit \;
    nosetests

    runHook postCheck
  '';

  meta = with lib; {
    description = "Patch python built-in objects";
    homepage = "https://github.com/clarete/forbiddenfruit";
    changelog = "https://github.com/clarete/forbiddenfruit/releases/tag/${version}";
    license = with licenses; [
      mit
      gpl3Plus
    ];
    maintainers = with maintainers; [ ];
  };
}
