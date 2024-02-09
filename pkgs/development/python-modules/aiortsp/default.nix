{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# dependencies
, dpkt

# tests
, mock
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "aiortsp";
  version = "1.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marss";
    repo = "aiortsp";
    rev = version;
    hash = "sha256-bxfnKAzMYh0lhS3he617eGhO7hmNbiwEYHh8k/PZ6r4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    dpkt
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "aiortsp"
  ];

  meta = with lib; {
    description = "An Asyncio-based RTSP library";
    homepage = "https://github.com/marss/aiortsp";
    changelog = "https://github.com/marss/aiortsp/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
