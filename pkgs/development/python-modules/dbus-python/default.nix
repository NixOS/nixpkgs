{
  lib,
  fetchFromGitLab,
  buildPythonPackage,
  isPyPy,
  python,

  # build-system
  meson,
  meson-python,
  ninja,
  pkg-config,
  setuptools,

  # native dependencies
  dbus,
  dbus-glib,

  # test dependencies
  pygobject3,
}:

buildPythonPackage (finalAttrs: {
  pname = "dbus-python";
  version = "1.5.1";
  pyproject = true;

  disabled = isPyPy;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "dbus";
    repo = "dbus-python";
    tag = "dbus-python-${finalAttrs.version}";
    hash = "sha256-wVU8wpm8e3AZUzeSLgMad+P5G53j0rhaQPh3IW3lBUQ=";
  };

  postPatch = ''
    # we provide patchelf natively, not through the python package
    sed -i '/patchelf/d' pyproject.toml

    patchShebangs test/*.sh
  '';

  build-system = [
    dbus # build systems checks for `dbus-run-session` in PATH
    meson
    meson-python
    ninja
    pkg-config
    setuptools
  ];

  buildInputs = [
    dbus
    dbus-glib
  ];

  checkInputs = [
    pygobject3
  ];

  mesonFlags = [
    (lib.mesonEnable "tests" finalAttrs.finalPackage.doInstallCheck)
  ];

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

    meson test -C build --no-rebuild --print-errorlogs --timeout-multiplier 0

    runHook postCheck
  '';

  meta = {
    description = "Python DBus bindings";
    homepage = "https://gitlab.freedesktop.org/dbus/dbus-python";
    license = lib.licenses.mit;
    platforms = dbus.meta.platforms;
    maintainers = [ ];
  };
})
