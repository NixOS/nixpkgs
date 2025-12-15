{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  locket,
  toolz,

  # optional-dependencies
  blosc2,
  numpy,
  pandas,
  pyzmq,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "partd";
  version = "1.4.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dask";
    repo = "partd";
    tag = version;
    hash = "sha256-EK+HNSPh2b7jwpc6jwH/n+6HDgHhRfBeaRuiDIWVG28=";
  };

  patches = [
    (fetchpatch2 {
      # python 3.12 support; https://github.com/dask/partd/pull/70
      url = "https://github.com/dask/partd/pull/70/commits/c96a034367cb9fee0a0900f758b802aeef8a8a41.patch";
      hash = "sha256-QlSIrFQQQo9We/gf7WSgmWrxdt3rxXQcyvJnFm8R5cM=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    locket
    toolz
  ];

  optional-dependencies = {
    complete = [
      blosc2
      numpy
      pandas
      pyzmq
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Appendable key-value storage";
    license = with lib.licenses; [ bsd3 ];
    homepage = "https://github.com/dask/partd/";
  };
}
