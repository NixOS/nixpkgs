{ stdenv, fetchgit, libvirt, autoconf, ocaml, findlib }:

stdenv.mkDerivation rec {
  name = "ocaml-libvirt-${version}";
  rev = "3169af3";
  version = "0.6.1.4-rev.${rev}"; # libguestfs-1.34 needs ocaml-libvirt newer than the latest release 0.6.1.4

  src = fetchgit {
    url = "git://git.annexia.org/git/ocaml-libvirt.git";
    rev = rev;
    sha256 = "0z8p6q6k42rdrvy248siq922m1yszny1hfklf6djynvk2viyqdbg";
  };

  propagatedBuildInputs = [ libvirt ];

  nativeBuildInputs = [ autoconf findlib ];

  buildInputs = [ ocaml ];

  createFindlibDestdir = true;

  preConfigure = ''
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
