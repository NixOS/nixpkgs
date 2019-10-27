{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, isPy3k
, pytest
, mock
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pytest-mock";
  version = "1.10.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5bf5771b1db93beac965a7347dc81c675ec4090cb841e49d9d34637a25c30568";
  };

  propagatedBuildInputs = lib.optional (!isPy3k) mock;

  nativeBuildInputs = [
   setuptools_scm
  ];

  checkInputs = [
    pytest
  ];

  patches = [
    # Fix tests for pytest 4.6. Remove with the next release
    (fetchpatch {
      url = "https://github.com/pytest-dev/pytest-mock/commit/189cc599d3bfbe91a17c93211c04237b6c5849b1.patch";
      sha256 = "13nk75ldab3j8nfzyd9w4cgfk2fxq4if1aqkqy82ar7y7qh07a7m";
    })
  ];

  checkPhase = ''
    # remove disabled test on next release
    # https://github.com/pytest-dev/pytest-mock/pull/151
    pytest -k "not test_detailed_introspection"
  '';

  meta = with lib; {
    description = "Thin-wrapper around the mock package for easier use with py.test.";
    homepage    = https://github.com/pytest-dev/pytest-mock;
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
