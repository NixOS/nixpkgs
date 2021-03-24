{ lib, stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder
, six, pytestCheckHook, pytest-benchmark, numpy, arrow, ruamel_yaml
}:

buildPythonPackage rec {
  pname   = "construct";
  version = "2.10.63";

  disabled = pythonOlder "3.6";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0dnj815qdxrn0q6bpwsmkca2jy02gjy6d3amqg4y6gha1kc1mymv";
  };

  checkInputs = [ pytestCheckHook pytest-benchmark numpy arrow ruamel_yaml ];

  disabledTests = lib.optionals stdenv.isDarwin [ "test_multiprocessing" ];

  pytestFlagsArray = [ "--benchmark-disable" ];

  meta = with lib; {
    description = "Powerful declarative parser (and builder) for binary data";
    homepage = "https://construct.readthedocs.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
  };
}
