{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cython
, libyaml
, python
}:

buildPythonPackage rec {
  pname = "PyYAML";
  version = if pythonOlder "3.6" then "5.4.1" else "6.0";

  src = fetchFromGitHub {
    owner = "yaml";
    repo = "pyyaml";
    rev = version;
    sha256 =
      if pythonOlder "3.6"
      then "sha256-VUqnlOF/8zSOqh6JoEYOsfQ0P4g+eYqxyFTywgCS7gM="
      else "sha256-wcII32mRgRRmAgojntyxBMQkjvxU2jylCgVzlHAj2Xc=";
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
