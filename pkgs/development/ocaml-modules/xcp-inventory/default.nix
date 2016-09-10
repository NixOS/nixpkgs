{stdenv, fetchurl, ocaml, cmdliner, findlib, obuild, stdext, uuidm}:

stdenv.mkDerivation {
  name = "ocaml-xcp-inventory-0.9.1";
  version = "0.9.1";

  src = fetchurl {
    url = "https://github.com/xapi-project/xcp-inventory/archive/v0.9.1/xcp-inventory-0.9.1.tar.gz";
    sha256 = "1gpyrqvagjw8vic3lswzx23pqzgb2yja4m9alnavbm9xfzcs20dz";
  };

  buildInputs = [ ocaml cmdliner findlib obuild ];

  propagatedBuildInputs = [ stdext uuidm ];

  configurePhase = ''
    if [ -x ./configure ]; then
      ./configure --default_inventory=$out/etc/xcp/inventory
    fi
    '';

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    make install DESTDIR=$out/lib/ocaml
    mkdir -p $out/etc/xcp
    '';

  meta = {
    homepage = https://github.com/xapi-project/xcp-inventory;
    description = "OCaml library to read and write the XCP inventory file";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
