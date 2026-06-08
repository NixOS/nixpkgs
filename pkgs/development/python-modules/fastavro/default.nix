{
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  lib,
  lz4,
  numpy,
  pandas,
  pytestCheckHook,
  python-dateutil,
  cramjam,
  setuptools,
  zlib-ng,
  zstandard,
}:

buildPythonPackage rec {
  pname = "fastavro";
  version = "1.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastavro";
    repo = "fastavro";
    tag = version;
    hash = "sha256-r/zaQ44ZPuSR1HxaqxD26kZPWREhmKP+oTOSa5QCEU4=";
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
  ++ lib.concatAttrValues optional-dependencies;

  # Fails with "AttributeError: module 'fastavro._read_py' has no attribute
  # 'CYTHON_MODULE'." Doesn't appear to be serious. See https://github.com/fastavro/fastavro/issues/112#issuecomment-387638676.
  disabledTests = [ "test_cython_python" ];

  pythonImportsCheck = [ "fastavro" ];

  meta = {
    description = "Fast read/write of AVRO files";
    mainProgram = "fastavro";
    homepage = "https://github.com/fastavro/fastavro";
    changelog = "https://github.com/fastavro/fastavro/blob/${src.tag}/ChangeLog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
