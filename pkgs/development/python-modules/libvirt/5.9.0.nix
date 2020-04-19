{ stdenv,python3Packages, fetchgit, pkgconfig, lxml, libvirt, nose }:

python3Packages.buildPythonPackage rec {
  pname = "libvirt";
  version = "5.9.0";

  src = fetchgit {
    url = "https://libvirt.org/git/libvirt-python.git";
    rev = "v${version}";
    sha256 = "0qvr0s7yasswy1s5cvkm91iifk33pb8s7nbb38zznc46706b358r";
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
    maintainers = with maintainers [ fpletz kmcopper ];
  };
}
