{ stdenv, buildPythonPackage, fetchgit, pkgconfig, lxml, libvirt, nose }:

buildPythonPackage rec {
  pname = "libvirt";
  version = "6.3.0";

  src = assert version == libvirt.version; fetchgit {
    url = "git://libvirt.org/libvirt-python.git";
    rev = "v${version}";
    sha256 = "088cksq59jxkkzbvmwl8jw9v2k3zibwksl7j57yb51bxaa2sa1cx";
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
