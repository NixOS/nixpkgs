{
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  isPy38,
  lib,
  lz4,
  numpy,
  pandas,
  pytestCheckHook,
  python-dateutil,
  cramjam,
  pythonOlder,
  setuptools,
  zlib-ng,
  zstandard,
}:

buildPythonPackage rec {
  pname = "fastavro";
  version = "1.9.7";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-hKhwQqNJ+QvYf4x9FesNOPg36m8zC6D6dmlhANXCcsk=";
  };

  preBuild = ''
    export FASTAVRO_USE_CYTHON=1
  '';

  build-system = [
    cython
    setuptools
  ];

  optional-dependencies = {
    codecs = [
      cramjam
      lz4
      zstandard
    ];
    snappy = [ cramjam ];
    zstandard = [ zstandard ];
    lz4 = [ lz4 ];
  };

  nativeCheckInputs = [
    numpy
    pandas
    pytestCheckHook
    python-dateutil
    zlib-ng
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  # Fails with "AttributeError: module 'fastavro._read_py' has no attribute
  # 'CYTHON_MODULE'." Doesn't appear to be serious. See https://github.com/fastavro/fastavro/issues/112#issuecomment-387638676.
  disabledTests = [ "test_cython_python" ];

  # CLI tests are broken on Python 3.8. See https://github.com/fastavro/fastavro/issues/558.
  disabledTestPaths = lib.optionals isPy38 [ "tests/test_main_cli.py" ];

  pythonImportsCheck = [ "fastavro" ];

  meta = with lib; {
    description = "Fast read/write of AVRO files";
    mainProgram = "fastavro";
    homepage = "https://github.com/fastavro/fastavro";
    changelog = "https://github.com/fastavro/fastavro/blob/${version}/ChangeLog";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
