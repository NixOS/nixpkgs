{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, ipaddr }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.01";

stdenv.mkDerivation {
  name = "ocaml-tuntap-1.3.0";

  src = fetchzip {
    url = https://github.com/mirage/ocaml-tuntap/archive/v1.3.0.tar.gz;
    sha256 = "1cmd4kky875ks02gm2nb8yr80hmlfcnjdfyc63hvkh49acssy3d5";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];
  propagatedBuildInputs = [ ipaddr ];

  createFindlibDestdir = true;

  meta = {
    description = "Bindings to the UNIX tuntap facility";
    license = stdenv.lib.licenses.isc;
    homepage = https://github.com/mirage/ocaml-tuntap;
    inherit (ocaml.meta) platforms;
  };

}
