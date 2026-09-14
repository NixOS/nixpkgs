{
  lib,
  stdenv,
  appdirs,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  glibcLocales,
  isPyPy,
  mock,
  psutil,
  pyftpdlib,
  pytestCheckHook,
  pytz,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "fs";
  version = "2.4.16";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rpfH1RIT9LcLapWCklMCiQkN46fhWEHhCPvhRPBp0xM=";
  };

  patches = [
    # setuptools 82 removed pkg_resources, which fs imports at run time.
    # https://github.com/PyFilesystem/pyfilesystem2/pull/589
    (fetchpatch {
      name = "entry-points-via-importlib-metadata.patch";
      url = "https://github.com/PyFilesystem/pyfilesystem2/commit/136e7e257eebfcd1f561a6b2f897eb8bfd44574e.patch";
      hash = "sha256-AGeT8GUlbI1O7EFhuS9zzqPTE2lVXOzj8/JPjUnpNPk=";
    })
    # https://github.com/PyFilesystem/pyfilesystem2/pull/590
    (fetchpatch {
      name = "drop-pkg-resources-declare-namespace.patch";
      url = "https://github.com/PyFilesystem/pyfilesystem2/commit/c009996c7f4a9ac3bd98cdd86b354c08a68d36c0.patch";
      hash = "sha256-Pw30ofLvxMm5dfY3XrjYsWcPKf3rLWMLbREsrB2tuZw=";
      # the sdist indents setup.cfg with tabs, so that hunk does not apply
      excludes = [ "setup.cfg" ];
    })
    ./python-3.14-pathname2url.patch
  ];

  postPatch = ''
    # https://github.com/PyFilesystem/pyfilesystem2/pull/591
    substituteInPlace tests/test_ftpfs.py \
      --replace ThreadedTestFTPd FtpdThreadWrapper

    # pull/589 passes name=None straight to importlib.metadata on 3.10+, where it
    # matches nothing, so Registry.protocols stops listing third-party openers
    # https://github.com/PyFilesystem/pyfilesystem2/pull/589#issuecomment-5281407182
    substituteInPlace fs/opener/registry.py \
      --replace-fail "entry_points(group=group, name=name)" "entry_points(group=group)" \
      --replace-fail "return tuple(n for n in ep)" \
        "return tuple(n for n in ep if name is None or n.name == name)"

    # pull/589 misses this one pkg_resources user in the test suite
    substituteInPlace tests/test_opener.py \
      --replace-fail 'pkg_resources.iter_entry_points("fs.opener")' \
        'importlib.metadata.entry_points(group="fs.opener")'
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
  ]
  ++ lib.optionals isPyPy [
    glibcLocales
  ];

  env.LC_ALL = "en_US.utf-8";

  preCheck = ''
    HOME=$(mktemp -d)
  '';

  disabledTestPaths = [
    # Circular dependency with parameterized
    "tests/test_move.py"
    "tests/test_mirror.py"
    "tests/test_copy.py"
    # pyftpdlib removed tests from installation in 2.1.0, resulting in
    #     ModuleNotFoundError: No module named 'pyftpdlib.test'
    "tests/test_ftpfs.py"
    "tests/test_encoding.py" # fails under zfs normalization=formD
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

  meta = {
    description = "Filesystem abstraction";
    homepage = "https://github.com/PyFilesystem/pyfilesystem2";
    changelog = "https://github.com/PyFilesystem/pyfilesystem2/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
