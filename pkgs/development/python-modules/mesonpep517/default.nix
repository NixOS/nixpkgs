{
  lib,
  buildPythonPackage,
  fetchPypi,
  meson,
  ninja,
  setuptools,
  toml,
  wheel,
}:

# TODO: offer meson as a Python package so we have dist-info folder.

buildPythonPackage rec {
  pname = "mesonpep517";
  version = "0.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Fyo7JfLqHJqbahEjVDt/0xJxOfVLqLn3xNJ4lSB7KIw=";
  };

  # Applies the following merge request, which doesn't apply cleanly:
  # https://gitlab.com/thiblahute/mesonpep517/-/merge_requests/25
  #
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'backend-path = "."' 'backend-path = ["."]'
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ toml ];

  propagatedNativeBuildInputs = [
    meson
    ninja
  ];

  meta = {
    description = "Create pep517 compliant packages from the meson build system";
    homepage = "https://gitlab.com/thiblahute/mesonpep517";
    license = lib.licenses.asl20;
  };
}
