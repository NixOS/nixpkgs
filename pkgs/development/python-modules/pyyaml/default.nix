{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  cython_0,
  setuptools,
  libyaml,
  python,
}:

buildPythonPackage rec {
  pname = "pyyaml";
  version = "6.0.1";

  disabled = pythonOlder "3.6";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "yaml";
    repo = "pyyaml";
    rev = version;
    hash = "sha256-YjWMyMVDByLsN5vEecaYjHpR1sbBey1L/khn4oH9SPA=";
  };

  nativeBuildInputs = [
    cython_0
    setuptools
  ];

  buildInputs = [ libyaml ];

  checkPhase = ''
    runHook preCheck
    PYTHONPATH="tests/lib:$PYTHONPATH" ${python.interpreter} -m test_all
    runHook postCheck
  '';

  pythonImportsCheck = [ "yaml" ];

  meta = with lib; {
    description = "The next generation YAML parser and emitter for Python";
    homepage = "https://github.com/yaml/pyyaml";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
