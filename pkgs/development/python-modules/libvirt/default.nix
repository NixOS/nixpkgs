{ stdenv, buildPythonPackage, fetchgit, pkgconfig, lxml, libvirt, nose }:

buildPythonPackage rec {
  pname = "libvirt";
  version = "6.6.0";

  src = assert version == libvirt.version; fetchgit {
    url = "https://gitlab.com/libvirt/libvirt-python.git";
    rev = "v${version}";
    sha256 = "0jj6b2nlx7qldwbvixz74abn3p0sq4lkf6ak74vynrv5xvlycb9v";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libvirt lxml ];

  checkInputs = [ nose ];
  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    homepage = "https://libvirt.org/python.html";
    description = "libvirt Python bindings";
    license = licenses.lgpl2;
    maintainers = [ maintainers.fpletz ];
  };
}
