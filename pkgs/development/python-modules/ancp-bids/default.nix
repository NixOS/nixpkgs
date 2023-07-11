{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, setuptools
, numpy
, pandas
}:

buildPythonPackage rec {
  pname = "ancp-bids";
  version = "0.2.1";
  disabled = pythonOlder "3.7";
  format = "pyproject";

  # `tests/data` dir missing from PyPI dist
  src = fetchFromGitHub {
     owner = "ANCPLabOldenburg";
     repo = pname;
     rev = "refs/tags/${version}";
     hash = "sha256-Nu9pulVSZysgm/F7jl+VpoqMCiHeysZjQDQ1dT7AnpE=";
  };

  nativeBuildInputs = [ setuptools ] ;

  checkInputs = [ numpy pandas pytestCheckHook ];
  pythonImportsCheck = [
    "ancpbids"
  ];

  pytestFlagsArray = [ "tests/auto" ];
  disabledTests = [ "test_fetch_dataset" ];

  meta = with lib; {
    homepage = "https://ancpbids.readthedocs.io";
    description = "Read/write/validate/query BIDS datasets";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
