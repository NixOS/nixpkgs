{ lib, fetchurl, pkg-config, buildPythonPackage, isPy3k, at-spi2-core, pygobject3, gnome, python }:

buildPythonPackage rec {
  pname = "pyatspi";
  version = "2.46.0";
  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1FSJzz1HqhULGjXolJs7MQNfjCB15YjSa278Yllwxi4=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    at-spi2-core
    pygobject3
  ];

  configureFlags = [
    "PYTHON=${python.pythonOnBuildForHost.interpreter}"
  ];

  postPatch = ''
    # useless python existence check for us
    substituteInPlace configure \
      --replace '&& ! which' '&& false'
  '';

  disabled = !isPy3k;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "python3.pkgs.${pname}";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Python client bindings for D-Bus AT-SPI";
    homepage = "https://wiki.linuxfoundation.org/accessibility/d-bus";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jtojnar ];
    platforms = with platforms; unix;
  };
}
