{ stdenv, fetchurl, pkgconfig, buildPythonPackage, isPy3k, at-spi2-core, pygobject3, gnome3 }:

buildPythonPackage rec {
  pname = "pyatspi";
  version = "2.30.0";
  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "11g7dx21brfmi5vrq289cw983rydalx0cy91afv5gigyadsmyam2";
  };

  buildInputs = [
    at-spi2-core
    pkgconfig
    pygobject3
  ];

  disabled = !isPy3k;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "python3.pkgs.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Python client bindings for D-Bus AT-SPI";
    homepage = https://wiki.linuxfoundation.org/accessibility/d-bus;
    license = licenses.gpl2;
    maintainers = with maintainers; [ jgeerds jtojnar ];
    platforms = with platforms; unix;
  };
}
