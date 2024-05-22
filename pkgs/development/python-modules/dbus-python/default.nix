{
  lib,
  fetchPypi,
  buildPythonPackage,
  fetchpatch,
  isPyPy,
  python,

  # build-system
  meson,
  meson-python,
  pkg-config,

  # native dependencies
  dbus,
  dbus-glib,
}:

lib.fix (
  finalPackage:
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

    patches = [
      # reduce required dependencies
      # https://gitlab.freedesktop.org/dbus/dbus-python/-/merge_requests/23
      (fetchpatch {
        url = "https://gitlab.freedesktop.org/dbus/dbus-python/-/commit/d5e19698a8d6e1485f05b67a5b2daa2392819aaf.patch";
        hash = "sha256-Rmj/ByRLiLnIF3JsMBElJugxsG8IARcBdixLhoWgIYU=";
      })
    ];

    postPatch = ''
      # we provide patchelf natively, not through the python package
      sed -i '/patchelf/d' pyproject.toml

      # dont run autotols configure phase
      rm configure.ac configure

      patchShebangs test/*.sh
    '';

    nativeBuildInputs = [
      dbus # build systems checks for `dbus-run-session` in PATH
      meson
      meson-python
      pkg-config
    ];

    buildInputs = [
      dbus
      dbus-glib
    ];

    pypaBuildFlags = [
      # Don't discard meson build directory, still needed for tests!
      "-Cbuild-dir=_meson-build"
    ];

    mesonFlags = [ (lib.mesonBool "tests" finalPackage.doInstallCheck) ];

    # workaround bug in meson-python
    # https://github.com/mesonbuild/meson-python/issues/240
    postInstall = ''
      mkdir -p $dev/lib
      mv $out/${python.sitePackages}/.dbus_python.mesonpy.libs/pkgconfig/ $dev/lib
    '';

    # make sure the Cflags in the pkgconfig file are correct and make the structure backwards compatible
    postFixup = ''
      ln -s $dev/include/*/dbus_python/dbus-1.0/ $dev/include/dbus-1.0
    '';

    nativeCheckInputs = [ dbus.out ];

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
)
