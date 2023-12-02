{ buildPythonPackage
, cython
, fetchFromGitHub
, isPy38
, lib
, lz4
, numpy
, pandas
, pytestCheckHook
, python-dateutil
, python-snappy
, pythonOlder
, zstandard
}:

buildPythonPackage rec {
  pname = "fastavro";
  version = "1.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-10r12Ya+FKMgdOTmgYH1xb6vOXNLLw073VzCvo2x9kg=";
  };

  preBuild = ''
    export FASTAVRO_USE_CYTHON=1
  '';

  nativeBuildInputs = [ cython ];

  passthru.optional-dependencies = {
    codecs = [
      lz4
      python-snappy
      zstandard
    ];
    snappy = [
      python-snappy
    ];
    zstandard = [
      zstandard
    ];
    lz4 = [
      lz4
    ];
  };

  nativeCheckInputs = [
    numpy
    pandas
    pytestCheckHook
    python-dateutil
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  # Fails with "AttributeError: module 'fastavro._read_py' has no attribute
  # 'CYTHON_MODULE'." Doesn't appear to be serious. See https://github.com/fastavro/fastavro/issues/112#issuecomment-387638676.
  disabledTests = [ "test_cython_python" ];

  # CLI tests are broken on Python 3.8. See https://github.com/fastavro/fastavro/issues/558.
  disabledTestPaths = lib.optionals isPy38 [ "tests/test_main_cli.py" ];

  pythonImportsCheck = [ "fastavro" ];

  meta = with lib; {
    description = "Fast read/write of AVRO files";
    homepage = "https://github.com/fastavro/fastavro";
    changelog = "https://github.com/fastavro/fastavro/blob/${version}/ChangeLog";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
