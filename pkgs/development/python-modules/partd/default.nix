{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  versioneer,

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
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask";
    repo = "partd";
    tag = version;
    hash = "sha256-GtIo6n87TmM5aRgtRyxhhXXAINpPCFbjZ/sQz/vkcoA=";
  };

  nativeBuildInputs = [
    setuptools
    versioneer
  ];

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
