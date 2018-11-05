{ stdenv, buildPythonPackage, fetchgit, pkgconfig, lxml, libvirt, nose }:

buildPythonPackage rec {
  pname = "libvirt";
  version = "4.10.0";

  src = assert version == libvirt.version; fetchgit {
    url = git://libvirt.org/libvirt-python.git;
    rev = "v${version}";
    sha256 = "184gd857fkks9ivh4zzbmva2fs2dfxg9lihvhfrwyd2pxflglvyf";
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
