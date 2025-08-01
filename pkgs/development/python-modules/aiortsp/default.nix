{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  dpkt,

  # tests
  mock,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "aiortsp";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marss";
    repo = "aiortsp";
    tag = "v${version}";
    hash = "sha256-/ydsu+53WOocdWk3AW0/cXBEx1qAlhIC0LUDy459pbQ=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ dpkt ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTestPaths = [
    # these tests get stuck, could be pytest-asyncio compat issue
    "tests/test_connection.py"
  ];

  pythonImportsCheck = [ "aiortsp" ];

  meta = with lib; {
    description = "Asyncio-based RTSP library";
    homepage = "https://github.com/marss/aiortsp";
    changelog = "https://github.com/marss/aiortsp/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
