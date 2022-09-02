{ lib, stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder
, pytestCheckHook, pytest-benchmark, numpy, arrow, ruamel-yaml
, lz4, cloudpickle
}:

buildPythonPackage rec {
  pname   = "construct";
  version = "2.10.68";

  disabled = pythonOlder "3.6";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-bp/YyRFP0rrBHPyhiqnn6o1iC5l61oedShZ2phGeqaw=";
  };

  # not an explicit dependency, but it's imported by an entrypoint
  propagatedBuildInputs = [
    lz4
  ];

  checkInputs = [ pytestCheckHook numpy arrow ruamel-yaml cloudpickle ];

  disabledTests = [ "test_benchmarks" ] ++ lib.optionals stdenv.isDarwin [ "test_multiprocessing" ];

  meta = with lib; {
    description = "Powerful declarative parser (and builder) for binary data";
    homepage = "https://construct.readthedocs.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
  };
}
