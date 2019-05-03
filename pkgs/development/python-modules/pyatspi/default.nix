{ stdenv, fetchurl, pkgconfig, buildPythonPackage, isPy3k, at-spi2-core, pygobject3, gnome3 }:

buildPythonPackage rec {
  pname = "pyatspi";
  version = "2.32.1";
  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1283cbwd2kacgdij96xk26721f6amyzdhy2py11kdj5cprdlm5c4";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    at-spi2-core
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
    maintainers = with maintainers; [ jtojnar ];
    platforms = with platforms; unix;
  };
}
