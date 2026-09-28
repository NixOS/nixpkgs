{
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  buildPythonPackage,
  isPy3k,
  at-spi2-core,
  pygobject3,
  gnome,
}:

buildPythonPackage rec {
  pname = "pyatspi";
  version = "2.58.1";

  pyproject = false;

  src = fetchurl {
    url = "mirror://gnome/sources/pyatspi/${lib.versions.majorMinor version}/pyatspi-${version}.tar.xz";
    sha256 = "Px8HmTX5JlhDMQJcdTGFjetCJFyZO2USH09LAeawRTY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    at-spi2-core
    pygobject3
  ];

  disabled = !isPy3k;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "pyatspi";
      attrPath = "python3.pkgs.pyatspi";
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "Python client bindings for D-Bus AT-SPI";
    homepage = "https://gitlab.gnome.org/GNOME/pyatspi2";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = with lib.platforms; unix;
  };
}
