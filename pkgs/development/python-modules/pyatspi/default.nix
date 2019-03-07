{ stdenv, fetchurl, pkgconfig, buildPythonPackage, isPy3k, at-spi2-core, pygobject3, gnome3 }:

buildPythonPackage rec {
  pname = "pyatspi";
  version = "2.31.2";
  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0k8ishvvvqwp1bw48v1kxx4p9s9r65p3p9hriraqawq322cz4mp8";
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
    maintainers = with maintainers; [ jgeerds jtojnar ];
    platforms = with platforms; unix;
  };
}
