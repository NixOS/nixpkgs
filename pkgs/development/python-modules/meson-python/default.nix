{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, colorama
, meson
, ninja
, pyproject-metadata
, tomli
, typing-extensions
, pythonOlder
}:

buildPythonPackage rec {
  pname = "meson-python";
  version = "0.15.0";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "meson_python";
    hash = "sha256-/dtz7s1J6JwcQch5N82JwtC2WhxjuigjhoHUvZSE0m8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pyproject-metadata
    tomli
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  propagatedBuildInputs = [
    meson
    ninja
    pyproject-metadata
    tomli
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];
  setupHooks = [
    ./add-build-flags.sh
  ];

  meta = {
    changelog = "https://github.com/mesonbuild/meson-python/blob/${version}/CHANGELOG.rst";
    description = "Meson Python build backend (PEP 517)";
    homepage = "https://github.com/mesonbuild/meson-python";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ fridh doronbehar ];
  };
}
