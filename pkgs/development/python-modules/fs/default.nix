{
  lib,
  stdenv,
  appdirs,
  buildPythonPackage,
  fetchPypi,
<<<<<<< HEAD
  glibcLocales,
  isPyPy,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  mock,
  psutil,
  pyftpdlib,
  pytestCheckHook,
<<<<<<< HEAD
  pythonAtLeast,
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytz,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "fs";
  version = "2.4.16";
  pyproject = true;

<<<<<<< HEAD
  # https://github.com/PyFilesystem/pyfilesystem2/issues/596
  disabled = pythonAtLeast "3.14";
=======
  disabled = pythonOlder "3.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rpfH1RIT9LcLapWCklMCiQkN46fhWEHhCPvhRPBp0xM=";
  };

  postPatch = ''
    # https://github.com/PyFilesystem/pyfilesystem2/pull/591
    substituteInPlace tests/test_ftpfs.py \
      --replace ThreadedTestFTPd FtpdThreadWrapper
  '';

  build-system = [ setuptools ];

  dependencies = [
    setuptools
    six
    appdirs
    pytz
  ];

  nativeCheckInputs = [
    pyftpdlib
    mock
    psutil
    pytestCheckHook
<<<<<<< HEAD
  ]
  ++ lib.optionals isPyPy [
    glibcLocales
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

  disabledTests = [
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

<<<<<<< HEAD
  meta = {
    description = "Filesystem abstraction";
    homepage = "https://github.com/PyFilesystem/pyfilesystem2";
    changelog = "https://github.com/PyFilesystem/pyfilesystem2/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lovek323 ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Filesystem abstraction";
    homepage = "https://github.com/PyFilesystem/pyfilesystem2";
    changelog = "https://github.com/PyFilesystem/pyfilesystem2/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
