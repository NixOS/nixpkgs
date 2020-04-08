{ stdenv, fetchgit, libvirt, autoconf, ocaml, findlib }:

stdenv.mkDerivation rec {
  pname = "ocaml-libvirt";
  rev = "bab7f84ade84ceaddb08b6948792d49b3d04b897";
  version = "0.6.1.4.2017-11-08-unstable"; # libguestfs-1.34+ needs ocaml-libvirt newer than the latest release 0.6.1.4

  src = fetchgit {
    url = "git://git.annexia.org/git/ocaml-libvirt.git";
    rev = rev;
    sha256 = "0vxgx1n58fp4qmly6i5zxiacr7303127d6j78a295xin1p3a8xcw";
  };

  propagatedBuildInputs = [ libvirt ];

  nativeBuildInputs = [ autoconf findlib ];

  buildInputs = [ ocaml ];

  createFindlibDestdir = true;

  preConfigure = ''
    autoconf
  '';

  buildPhase = "make all opt CPPFLAGS=-Wno-error";

  installPhase = "make install-opt";

  meta = with stdenv.lib; {
    description = "OCaml bindings for libvirt";
    homepage = https://libvirt.org/ocaml/;
    license = licenses.gpl2;
    maintainers = [ maintainers.volth ];
    platforms = ocaml.meta.platforms or [];
  };
}
