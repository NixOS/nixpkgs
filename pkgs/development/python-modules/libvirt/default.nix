{ stdenv, buildPythonPackage, fetchgit, python, pkgconfig, lxml, libvirt, nose }:

buildPythonPackage rec {
  pname = "libvirt";
  version = "4.4.0";

  src = assert version == libvirt.version; fetchgit {
    url = git://libvirt.org/libvirt-python.git;
    rev = "v${version}";
    sha256 = "01kwwwacbq7kbsslb2ac3wwfs4r8nsv7jhn0df2mmff30izbhq34";
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
