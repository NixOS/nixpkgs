{
  lib,
  build,
  buildPythonPackage,
  fetchPypi,
  filelock,
  ini2toml,
  jaraco-envs,
  jaraco-path,
  jaraco-test,
  nix-update-script,
  packaging,
  pip,
  pyproject-hooks,
  pytest-subprocess,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  setuptools,
  tomli-w,
  virtualenv,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "pkg-resources-backport";
  version = "1.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "pkg_resources_backport";
    inherit (finalAttrs) version;
    hash = "sha256-M4wkI+YhPIEPP8LN+yi6q87ikZRDpritDjdirWyuPzw=";
  };

  build-system = [ setuptools ];

  dependencies = [ setuptools ];

  nativeCheckInputs = [
    build
    filelock
    ini2toml
    jaraco-envs
    jaraco-path
    jaraco-test
    packaging
    pip
    pyproject-hooks
    pytestCheckHook
    pytest-subprocess
    pytest-timeout
    pytest-xdist
    tomli-w
    virtualenv
    wheel
  ];

  pythonImportsCheck = [ "pkg_resources" ];

  disabledTests = [
    "test_get_cache_path"
    "test_resource_filename_rewrites_on_change"
    "test_interop_pkg_resources_iter_entry_points"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Snapshot of last pkg_resources module from setuptools";
    homepage = "https://pypi.org/project/pkg-resources-backport";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
