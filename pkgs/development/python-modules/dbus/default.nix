{ lib
, fetchPypi
, buildPythonPackage
, isPyPy

# build-system
, meson
, meson-python
, ninja
, patchelf
, pkg-config
, setuptools

# native dependencies
, dbus
, dbus-glib
}:

buildPythonPackage rec {
  pname = "dbus-python";
  version = "1.3.2";
  pyproject = true;

  disabled = isPyPy;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rWeBkwhhi1BpU3viN/jmjKHH/Mle5KEh/mhFsUGCSPg=";
  };

  postPatch = ''
    # we provide patchelf natively, not through the python package
    sed -i '/patchelf/d' pyproject.toml

    # dont run autotols configure phase
    rm configure.ac configure

    patchShebangs test/*.sh
  '';

  nativeBuildInputs = [
    meson
    meson-python
    ninja
    patchelf
    pkg-config
    setuptools
  ];

  buildInputs = [
    dbus
    dbus-glib
  ];

  pypaBuildFlags = [
    # Don't discard meson build directory, still needed for tests!
    "-Cbuild-dir=_meson-build"
  ];

  nativeCheckInputs = [
    dbus.out
  ];

  checkPhase = ''
    runHook preCheck

    meson test -C _meson-build --no-rebuild --print-errorlogs

    runHook postCheck
  '';

  meta = with lib; {
    description = "Python DBus bindings";
    homepage = "https://gitlab.freedesktop.org/dbus/dbus-python";
    license = licenses.mit;
    platforms = dbus.meta.platforms;
    maintainers = with maintainers; [ ];
  };
}
