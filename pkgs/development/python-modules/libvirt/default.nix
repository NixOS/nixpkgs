{ stdenv, buildPythonPackage, fetchgit, pkgconfig, lxml, libvirt, nose }:

buildPythonPackage rec {
  pname = "libvirt";
  version = "6.2.0";

  src = assert version == libvirt.version; fetchgit {
    url = "git://libvirt.org/libvirt-python.git";
    rev = "v${version}";
    sha256 = "0a8crk29rmnw1kcgi72crb7syacdk03lkl05yand5cxs0l65jwdl";
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
