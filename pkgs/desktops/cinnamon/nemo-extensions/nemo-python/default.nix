{ stdenv
, lib
, fetchFromGitHub
, meson
, pkg-config
, ninja
, glib
, gtk3
, nemo
, python3
, substituteAll
}:

stdenv.mkDerivation rec {
  pname = "nemo-python";
  version = "5.6.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo-extensions";
    rev = version;
    sha256 = "sha256-cxutiz5bc/dZ9D7XzvMWodWNYvNJPj+5IhJDPJwnb5I=";
  };

  sourceRoot = "${src.name}/nemo-python";

  patches = [
    # Load extensions from NEMO_PYTHON_EXTENSION_DIR environment variable
    # https://github.com/NixOS/nixpkgs/issues/78327
    ./load-extensions-from-env.patch

    # Required for pygobject_init ().
    (substituteAll {
      src = ./python-path.patch;
      env = "${python3.pkgs.pygobject3}/${python3.sitePackages}";
    })
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [
    glib
    gtk3
    nemo
    python3
    python3.pkgs.pygobject3
  ];

  postPatch = ''
    # Tries to load libpython3.so via g_module_open ().
    substituteInPlace meson.build \
      --replace "get_option('prefix'), get_option('libdir')" "'${python3}/lib'"
  '';

  PKG_CONFIG_LIBNEMO_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/${nemo.extensiondir}";

  meta = with lib; {
    homepage = "https://github.com/linuxmint/nemo-extensions/tree/master/nemo-python";
    description = "Python bindings for the Nemo extension library";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
