{ stdenv, buildPythonPackage, fetchurl, python, pkgconfig, lxml, libvirt, nose }:

buildPythonPackage rec {
  pname = "libvirt";
  version = "3.10.0";

  src = assert version == libvirt.version; fetchurl {
    url = "http://libvirt.org/sources/python/${pname}-python-${version}.tar.gz";
    sha256 = "1l0fgqjnx76pzkhq540x9sf5fgzlrn0dpay90j2m4iq8nkclcbpw";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libvirt lxml ];

  checkInputs = [ nose ];
  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    homepage = http://www.libvirt.org/;
    description = "libvirt Python bindings";
    license = licenses.lgpl2;
    maintainers = [ maintainers.fpletz ];
  };
}
