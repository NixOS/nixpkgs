{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, pytestCheckHook
, setuptools
, wheel
, numpy
, pandas
}:

buildPythonPackage rec {
  pname = "ancp-bids";
  version = "0.2.1";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  # `tests/data` dir missing from PyPI dist
  src = fetchFromGitHub {
    owner = "ANCPLabOldenburg";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Nu9pulVSZysgm/F7jl+VpoqMCiHeysZjQDQ1dT7AnpE=";
  };

  patches = [
    # https://github.com/ANCPLabOldenburg/ancp-bids/pull/78
    (fetchpatch {
      name = "unpin-wheel-build-dependency.patch";
      url = "https://github.com/ANCPLabOldenburg/ancp-bids/commit/6e7a0733002845aacb0152c5aacfb42054a9b65e.patch";
      hash = "sha256-WbQRwb8Wew46OJu+zo7n4qBtgtH/Lr6x3YHAyN9ko9M=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [
    numpy
    pandas
    pytestCheckHook
  ];

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
