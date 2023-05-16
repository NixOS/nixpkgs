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
<<<<<<< HEAD
  version = "0.13.1";
=======
  version = "0.12.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "meson_python";
<<<<<<< HEAD
    hash = "sha256-Y7MXAAFCXEL6TP7a25BRy9KJJf+O7XxA02ugCZ48dhg=";
=======
    hash = "sha256-PVs+WB1wpYqXucEWp16Xp2zEtMfnX6Blj8g5I3Hi8sI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  setupHooks = [
    ./add-build-flags.sh
  ];
=======

  # Ugly work-around. Drop ninja dependency.
  # We already have ninja, but it comes without METADATA.
  # Building ninja-python-distributions is the way to go.
  postPatch = ''
    substituteInPlace pyproject.toml --replace "'ninja'," ""
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    changelog = "https://github.com/mesonbuild/meson-python/blob/${version}/CHANGELOG.rst";
    description = "Meson Python build backend (PEP 517)";
    homepage = "https://github.com/mesonbuild/meson-python";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.fridh ];
  };
}
