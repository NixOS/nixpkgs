{ stdenv, fetchgit, libvirt, autoconf, ocaml, findlib }:

stdenv.mkDerivation rec {
  name = "ocaml-libvirt-${version}";
  version = "0.6.1.5"; # FIXME: libguestfs depends on not yet released 0.6.1.5, so the latest post-0.6.1.4 master from git is used

  src = fetchgit {
    url = "git://git.annexia.org/git/ocaml-libvirt.git";
    rev = "8853f5a49587f00a7d2a5c8c7e52480a16bbdb02";
    sha256 = "1lnsvyb6dll58blacc629nz1lzc20p7ayqn9pag1rrx5i54q9v24";
  };

  propagatedBuildInputs = [ libvirt ];

  nativeBuildInputs = [ autoconf findlib ];

  buildInputs = [ ocaml ];

  createFindlibDestdir = true;

  preConfigure = ''
    substituteInPlace configure.ac --replace 0.6.1.4 0.6.1.5
    autoconf
  '';

  buildPhase = if stdenv.cc.isClang then "make all opt CPPFLAGS=-Wno-error" else "make all opt";

  installPhase = "make install-opt";

  meta = with stdenv.lib; {
    description = "OCaml bindings for libvirt";
    homepage = https://libvirt.org/ocaml/;
    license = licenses.gpl2;
    maintainers = [ maintainers.volth ];
    platforms = ocaml.meta.platforms or [];
  };
}
