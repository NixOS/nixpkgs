{ lib, buildPythonPackage, fetchgit, pkg-config, lxml, libvirt, nose }:

buildPythonPackage rec {
  pname = "libvirt";
  version = "5.9.0";

  src = fetchgit {
    url = "git://libvirt.org/libvirt-python.git";
    rev = "v${version}";
    sha256 = "0qvr0s7yasswy1s5cvkm91iifk33pb8s7nbb38zznc46706b358r";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libvirt lxml ];

  checkInputs = [ nose ];
  checkPhase = ''
    nosetests
  '';

  passthru = {
    inherit libvirt;
  };

  meta = with lib; {
    homepage = "http://www.libvirt.org/";
    description = "libvirt Python bindings";
    license = licenses.lgpl2;
    maintainers = [ maintainers.fpletz ];
  };
}
