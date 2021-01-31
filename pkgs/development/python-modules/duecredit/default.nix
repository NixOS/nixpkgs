{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, contextlib2
, pytest
, pytestCheckHook
, vcrpy
, citeproc-py
, requests
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "duecredit";
  version = "0.8.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "43b3f01ab5fb2bf2ecc27d3fcf92b873c6b288f44becef3e2e87c96cb89d7b01";
  };

  # bin/duecredit requires setuptools at runtime
  propagatedBuildInputs = [ citeproc-py requests setuptools six ];

  checkInputs = [ contextlib2 pytest pytestCheckHook vcrpy ];
  disabledTests = [ "test_io" ];

  meta = with lib; {
    homepage = "https://github.com/duecredit/duecredit";
    description = "Simple framework to embed references in code";
    license = licenses.bsd2;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
