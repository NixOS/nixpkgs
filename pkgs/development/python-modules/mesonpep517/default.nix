{ lib
, buildPythonPackage
, fetchPypi
, meson
, ninja
, setuptools
, toml
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

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ toml ];

  # postPatch = ''
  #   # Meson tries to detect ninja as well, so we should patch meson as well.
  #   substituteInPlace mesonpep517/buildapi.py \
  #     --replace "'meson'" "'${meson}/bin/meson'" \
  #     --replace "'ninja'" "'${ninja}/bin/ninja'"
  # '';

  propagatedNativeBuildInputs = [ meson ninja ];

  meta = {
    description = "Create pep517 compliant packages from the meson build system";
    homepage = "https://gitlab.com/thiblahute/mesonpep517";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.fridh ];
  };
}
