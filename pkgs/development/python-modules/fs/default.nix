{
  lib,
  stdenv,
  appdirs,
  buildPythonPackage,
  fetchPypi,
  mock,
  psutil,
  pyftpdlib,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  pytz,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "fs";
  version = "2.4.16";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rpfH1RIT9LcLapWCklMCiQkN46fhWEHhCPvhRPBp0xM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    six
    appdirs
    pytz
  ];

  nativeCheckInputs = [
    pyftpdlib
    mock
    psutil
    pytestCheckHook
  ];

  LC_ALL = "en_US.utf-8";

  preCheck = ''
    HOME=$(mktemp -d)
  '';

  disabledTestPaths = [
    # Circular dependency with parameterized
    "tests/test_move.py"
    "tests/test_mirror.py"
    "tests/test_copy.py"
  ];

  disabledTests =
    [
      "user_data_repr"
      # https://github.com/PyFilesystem/pyfilesystem2/issues/568
      "test_remove"
      # Tests require network access
      "TestFTPFS"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
      # remove if https://github.com/PyFilesystem/pyfilesystem2/issues/430#issue-707878112 resolved
      "test_ftpfs"
    ];

  pythonImportsCheck = [ "fs" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Filesystem abstraction";
    homepage = "https://github.com/PyFilesystem/pyfilesystem2";
    changelog = "https://github.com/PyFilesystem/pyfilesystem2/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.unix;
  };
}
