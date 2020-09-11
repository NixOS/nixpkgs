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
  version = "0.8.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yxd8579pakrfhq0hls0iy37nxllsm8y33na220g08znibrp7ix0";
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
