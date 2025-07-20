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
  version = "1.11.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "fastavro";
    repo = "fastavro";
    tag = version;
    hash = "sha256-I8Te1Ae20UrE5qI2nwktU0Ubip7Jx4/NWteSKsSz7tg=";
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
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

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
