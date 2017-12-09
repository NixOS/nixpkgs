{ stdenv, fetchurl, python, pkgconfig, lxml, libvirt }:

stdenv.mkDerivation rec {
  version = "3.10.0";
  name = "libvirt-python-${version}";

  src = assert version == libvirt.version; fetchurl {
    url = "http://libvirt.org/sources/python/${name}.tar.gz";
    sha256 = "1l0fgqjnx76pzkhq540x9sf5fgzlrn0dpay90j2m4iq8nkclcbpw";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ python libvirt lxml ];

  buildPhase = "${python.interpreter} setup.py build";

  installPhase = "${python.interpreter} setup.py install --prefix=$out";

  meta = with stdenv.lib; {
    homepage = http://www.libvirt.org/;
    description = "libvirt Python bindings";
    license = licenses.lgpl2;
    maintainers = [ maintainers.fpletz ];
  };
}
