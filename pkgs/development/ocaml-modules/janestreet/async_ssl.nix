{ stdenv, ocaml, buildOcamlJane, fetchurl, async, comparelib, core, ctypes
, openssl, fieldslib, herelib, pipebang, sexplib, ocaml_oasis, integers
}:

buildOcamlJane rec {
  name = "async_ssl";
  version = "113.33.07";
  hash = "0bhzpnmlx6dy4fli3i7ipjwqbsdi7fq171jrila5dr3ciy3841xs";
  postPatch = "export CAML_LD_LIBRARY_PATH=${integers}/lib/ocaml/${ocaml.version}/site-lib/stubslibs:$CAML_LD_LIBRARY_PATH";
  propagatedBuildInputs = [ ctypes async comparelib core fieldslib
                            herelib pipebang sexplib openssl ocaml_oasis ];
  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/async_ssl;
    description = "Async wrappers for ssl";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
