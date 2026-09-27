{
  lib,
  buildPythonPackage,
  fetchFromGitLab,

  python,

  at-spi2-core,
  gobject-introspection,
  gtk3,
  pyatspi,
  pycairo,
  pygobject3,
  setuptools,
  setuptools-scm,

  packaging,
  psutil,

  dbus,
  gsettings-desktop-schemas,
  wrapGAppsHook3,
  writableTmpDirAsHomeHook,
  xvfb-run,

  callPackage,
}:

buildPythonPackage (finalAttrs: {
  pname = "dogtail";
  version = "2.0.1";
  pyproject = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    owner = "dogtail";
    repo = "dogtail";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+mtof4KFhybLjoQ2pMindZJt2rNxSbtgGl9wJQahMYI=";
  };

  patches = [ ./0001-nixos-support.patch ];

  postPatch = ''
    # some custom configure command, not helpful for nix build
    rm -f configure
    # logs say `Not loading module "atk-bridge": The functionality is provided by GTK natively. Please try to not load it`
    sed -i 's/"gail:atk-bridge"/""/g' dogtail/utils.py
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pyatspi
    pycairo
    pygobject3
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  propagatedBuildInputs = [
    packaging
    psutil

    at-spi2-core
    gtk3
  ];

  makeWrapperArgs = [
    "--prefix"
    "GI_TYPELIB_PATH"
    ":"
    "${lib.makeSearchPath "lib/girepository-1.0" finalAttrs.propagatedBuildInputs}"
  ];

  # Tests require accessibility etc.
  # do it in a vm
  doCheck = false;

  passthru.tests = callPackage ./tests { };

  meta = {
    description = "GUI test tool and automation framework that uses Accessibility technologies to communicate with desktop applications";
    homepage = "https://gitlab.com/dogtail/dogtail";
    license = lib.licenses.gpl2Plus;
    mainProgram = "dogtail-headless";
    maintainers = with lib.maintainers; [ phanirithvij ];
    platforms = lib.platforms.linux;
  };
})
