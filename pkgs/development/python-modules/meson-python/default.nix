{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  colorama,
  meson,
  ninja,
  pyproject-metadata,
  tomli,
  typing-extensions,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "meson-python";
  version = "0.16.0";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "meson_python";
    hash = "sha256-kGjBfjbInWx/9wn/+yqKmSXozQsCYpco5c6vLsUFy18=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pyproject-metadata
    tomli
  ] ++ lib.optionals (pythonOlder "3.10") [ typing-extensions ];

  propagatedBuildInputs = [
    meson
    ninja
    pyproject-metadata
    tomli
  ] ++ lib.optionals (pythonOlder "3.10") [ typing-extensions ];
  setupHooks = [ ./add-build-flags.sh ];

  meta = {
    changelog = "https://github.com/mesonbuild/meson-python/blob/${version}/CHANGELOG.rst";
    description = "Meson Python build backend (PEP 517)";
    homepage = "https://github.com/mesonbuild/meson-python";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
