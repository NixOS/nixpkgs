{
  lib,
  stdenv,
  appdirs,
  buildPythonPackage,
  fetchPypi,
  glibcLocales,
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

  buildInputs = [ glibcLocales ];

  dependencies = [
    six
    appdirs
    pytz
    setuptools
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

  # strong cycle with parameterized
  doCheck = false;

  pytestFlagsArray = [ "--ignore=tests/test_opener.py" ];

  disabledTests =
    [ "user_data_repr" ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
      # remove if https://github.com/PyFilesystem/pyfilesystem2/issues/430#issue-707878112 resolved
      "test_ftpfs"
    ]
    ++ lib.optionals (pythonAtLeast "3.9") [
      # update friend version of this commit: https://github.com/PyFilesystem/pyfilesystem2/commit/3e02968ce7da7099dd19167815c5628293e00040
      # merged into master, able to be removed after >2.4.1
      "test_copy_sendfile"
    ];

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
