{ stdenv, buildPythonPackage, fetchgit, pkgconfig, lxml, libvirt, nose }:

buildPythonPackage rec {
  pname = "libvirt";
  version = "4.7.0";

  src = assert version == libvirt.version; fetchgit {
    url = git://libvirt.org/libvirt-python.git;
    rev = "v${version}";
    sha256 = "1zv3fgwmnkvqif0qsnvpx8hhb6bdfr2b4v55z3nh93bfg8s4rbm8";
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
