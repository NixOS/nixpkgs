{ stdenv, python3Packages, fetchgit, pkgconfig, lxml, libvirt, nose }:

python3Packages.buildPythonPackage rec {
  pname = "libvirt";
  version = "6.2.0";

  src = assert version == libvirt.version; fetchgit {
    url = "https://libvirt.org/git/libvirt-python.git";
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
    homepage = "https://www.libvirt.org/";
    description = "libvirt Python bindings";
    license = licenses.lgpl2;
    maintainers = with maintainers [ fpletz kmcopper ];
  };
}
