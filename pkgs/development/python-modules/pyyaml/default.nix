{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cython
, libyaml
, python
}:

buildPythonPackage rec {
  pname = "pyyaml";
  version = "6.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "yaml";
    repo = "pyyaml";
    rev = version;
    hash = "sha256-wcII32mRgRRmAgojntyxBMQkjvxU2jylCgVzlHAj2Xc=";
  };

  nativeBuildInputs = [ cython ];

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
