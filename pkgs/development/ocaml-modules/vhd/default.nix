{stdenv, fetchurl, ocaml, camlp4, cstruct, findlib, io-page, lwt, mirage-types, ounit, uuidm, libev}:

stdenv.mkDerivation {
  name = "ocaml-vhd-0.7.2";
  version = "0.7.2";

  src = fetchurl {
    url = "https://github.com/djs55/ocaml-vhd/archive/v0.7.2/ocaml-vhd-0.7.2.tar.gz";
    sha256 = "1g16ydavmr6v4lc6nhmrjvn3d40n2hqdn6in9x0g64753zhf5xdh";
  };

  buildInputs = [ ocaml camlp4 cstruct findlib io-page lwt ounit uuidm libev ];

  propagatedBuildInputs = [ mirage-types ];

  configurePhase = ''
    if [ -x ./configure ]; then
      ./configure
    fi
    '';

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    mkdir -p $OCAMLFIND_DESTDIR $OCAMLFIND_DESTDIR/stublibs
    ocaml setup.ml -install
    '';

  meta = {
    homepage = https://github.com/djs55/ocaml-vhd;
    description = "Pure OCaml library for reading, writing, streaming, converting vhd format files";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
