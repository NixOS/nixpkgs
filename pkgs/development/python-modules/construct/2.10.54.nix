{ lib, stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder
, six, pytestCheckHook, enum34, numpy, arrow, ruamel_yaml
}:

buildPythonPackage rec {
  pname   = "construct";
  version = "2.10.54";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1mqspsn6bf3ibvih1zna2glkg8iw7vy5zg9gzg0d1m8zcndk2c48";
  };

  checkInputs = [ pytestCheckHook enum34 numpy arrow ruamel_yaml ];

  disabledTests = [ "test_benchmarks" ] ++ lib.optionals stdenv.isDarwin [ "test_multiprocessing" ];

  meta = with lib; {
    description = "Powerful declarative parser (and builder) for binary data";
    homepage = "https://construct.readthedocs.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
