{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dateutils,
  future,
  lxml,
  python-dateutil,
  pytz,
  requests,
  tinytag,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "podgen";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tobinus";
    repo = "python-podgen";
    tag = "v${version}";
    hash = "sha256-IlTbKWNdEHJmEPdslKphZLB5IVERxNL/wqCMbJDHkD4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    dateutils
    future
    lxml
    python-dateutil
    pytz
    requests
    tinytag
  ];

  pythonImportsCheck = [ "podgen" ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  disabledTestPaths = [
    # test requires downloading content
    "podgen/tests/test_media.py"
  ];

  meta = {
    description = "Python module to generate Podcast feeds";
    downloadPage = "https://github.com/tobinus/python-podgen";
    changelog = "https://github.com/tobinus/python-podgen/blob/v${version}/CHANGELOG.md";
    homepage = "https://podgen.readthedocs.io/en/latest/";
    license = with lib.licenses; [
      bsd2
      lgpl3
    ];
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
