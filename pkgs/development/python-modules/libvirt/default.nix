{ stdenv, buildPythonPackage, fetchgit, pkgconfig, lxml, libvirt, nose }:

buildPythonPackage rec {
  pname = "libvirt";
  version = "6.1.0";

  src = assert version == libvirt.version; fetchgit {
    url = git://libvirt.org/libvirt-python.git;
    rev = "v${version}";
    sha256 = "0h3w1p5y4kg2hdbhxmg4lphcnmr7979iwi0m750f8vzbfccsrp7k";
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
