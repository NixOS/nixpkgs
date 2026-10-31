{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  sqlitedict,
  websockets,

  # optional-dependencies
  numpy,

  # tests
  pytest,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "bscpylgtv";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "chros73";
    repo = "bscpylgtv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8h7H5MA07i5A4JmKVToL6YNi2YeQaj9Gh+0mudA0e8o=";
  };

  pyproject = true;

  build-system = [ setuptools ];

  dependencies = [
    sqlitedict
    websockets
  ];

  optional-dependencies = {
    with_calibration = [ numpy ];
  };

  nativeCheckInputs = [
    pytest
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "bscpylgtv" ];

  meta = {
    description = "Library to control webOS based LG TV units";
    mainProgram = "bscpylgtvcommand";
    homepage = "https://github.com/chros73/bscpylgtv";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mrbjarksen ];
  };
})
