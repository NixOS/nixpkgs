{ lib, stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder
, six, pytestCheckHook, pytest-benchmark, numpy, arrow, ruamel_yaml
, lz4, cloudpickle
}:

buildPythonPackage rec {
  pname   = "construct";
  version = "2.10.67";

  disabled = pythonOlder "3.6";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1nciwim745qk41l1ck4chx3vxpfr6cq4k3a4i7vfnnrd3s6szzsw";
  };

  # not an explicit dependency, but it's imported by an entrypoint
  propagatedBuildInputs = [
    lz4
  ];

  checkInputs = [ pytestCheckHook pytest-benchmark numpy arrow ruamel_yaml cloudpickle ];

  disabledTests = lib.optionals stdenv.isDarwin [ "test_multiprocessing" ];

  pytestFlagsArray = [ "--benchmark-disable" ];

  meta = with lib; {
    description = "Powerful declarative parser (and builder) for binary data";
    homepage = "https://construct.readthedocs.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
  };
}
