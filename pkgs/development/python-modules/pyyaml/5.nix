{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, libyaml
, isPy27
, python
}:

buildPythonPackage rec {
  pname = "PyYAML";
  version = "5.4.1.1";

  src = fetchFromGitHub {
    owner = "yaml";
    repo = "pyyaml";
    rev = version;
    sha256 = "1v386gzdvsjg0mgix6v03rd0cgs9dl81qvn3m547849jm8r41dx8";
  };

  nativeBuildInputs = [ cython ];

  buildInputs = [ libyaml ];

  checkPhase = ''
    runHook preCheck
    PYTHONPATH=""tests/lib":$PYTHONPATH" ${python.interpreter} -m test_all
    runHook postCheck
  '';

  pythonImportsCheck = [ "yaml" ];

  meta = with lib; {
    description = "The next generation YAML parser and emitter for Python";
    homepage = "https://github.com/yaml/pyyaml";
    license = licenses.mit;
  };
}
