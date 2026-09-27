{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  gitUpdater,
  setuptools,
  setuptools-scm,
  buildstream,

  # Optional plugin dependencies, matching upstream's pyproject.toml extras.
  arpy,
  dulwich,
  packaging,
  requests,
  tomlkit,

  # nativeCheckInputs
  buildbox,
  gitMinimal,
  ostree,
  pyftpdlib,
  pytest-datafiles,
  pytest-env,
  pytest-xdist,
  pytestCheckHook,

  withCargo2 ? true,
  withDeb ? true,
  withGit ? true,
  withHttpfetcher ? true,
  withPypi ? true,
}:
buildPythonPackage (finalAttrs: {
  pname = "buildstream-plugins-community";
  version = "2.3.3";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "buildstream";
    repo = "buildstream-plugins-community";
    tag = finalAttrs.version;
    hash = "sha256-Fvm7TKwKmOAiVATJrvvd9I5mpPN+zkCxaMXnoksVrJE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies =
    lib.optionals withDeb [ arpy ]
    ++ lib.optionals (withCargo2 || withGit) [ dulwich ]
    ++ lib.optionals withCargo2 [ tomlkit ]
    ++ lib.optionals withHttpfetcher [ requests ]
    ++ lib.optionals withPypi [ packaging ];

  pythonImportsCheck = [ "buildstream_plugins_community" ];

  nativeCheckInputs = [
    # `buildstream-plugins-community` is loaded by `bst` at runtime (via
    # pluginbase, as configured through a project's `project.conf`), so it
    # always has `buildstream` in its environment when imported; it is not
    # declared as a `dependencies` entry here to avoid pulling a second
    # `buildstream` closure into consumers that already bundle it.
    buildstream
    buildbox
    gitMinimal
    ostree
    pyftpdlib
    pytest-datafiles
    pytest-env
    pytest-xdist
    pytestCheckHook
  ];

  # /dev/fuse is not available inside the Nix build sandbox, so buildbox-casd's
  # default FUSE-based staging strategy cannot work here. Force the hardlink/copy
  # stager instead, as done for buildstream itself.
  preCheck = ''
    export BUILDBOX_STAGER=copy-or-link
  '';

  # These tests reach out to gitlab.com to download real files (bazel
  # manifest fetches, git-lfs test repo), which isn't possible in the
  # sandboxed Nix build.
  pytestFlags = [
    "--deselect=tests/sources/bazel.py::test_basic"
    "--deselect=tests/sources/bazel.py::test_multi_url"
    "--deselect=tests/sources/bazel_file.py::test_basic"
    "--deselect=tests/sources/bazel_file.py::test_multi_url"
    "--deselect=tests/sources/git_tag.py::test_gitlfs"
    "--deselect=tests/sources/git_tag.py::test_gitlfs_off"
    "--deselect=tests/sources/git_tag.py::test_gitlfs_notset"
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    changelog = "https://gitlab.com/BuildStream/buildstream-plugins-community/-/blob/${finalAttrs.src.tag}/NEWS";
    description = "BuildStream community plugins";
    homepage = "https://gitlab.com/buildstream/buildstream-plugins-community";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shymega ];
  };
})
