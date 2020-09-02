{ stdenv, buildPythonPackage, fetchgit, pkgconfig, lxml, libvirt, nose }:

buildPythonPackage rec {
  pname = "libvirt";
  version = "6.7.0";

  src = assert version == libvirt.version; fetchgit {
    url = "git://libvirt.org/libvirt-python.git";
    rev = "v${version}";
    sha256 = "0g3g8r0pj0xzz687z1rklq0d3ya0zngrj03b7nnm5sd1kbhfmib8";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libvirt lxml ];

  checkInputs = [ nose ];
  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.libvirt.org/";
    description = "libvirt Python bindings";
    license = licenses.lgpl2;
    maintainers = [ maintainers.fpletz ];
  };
}
