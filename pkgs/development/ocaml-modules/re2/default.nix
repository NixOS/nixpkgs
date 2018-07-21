{stdenv, buildOcaml, fetchurl, core_p4, pa_ounit, pa_test,
 bin_prot_p4, comparelib, sexplib_p4, rsync}:

buildOcaml rec {
  name = "re2";
  version = "112.06.00";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchurl {
    url = "https://github.com/janestreet/re2/archive/${version}.tar.gz";
    sha256 = "a538765872363fcb67f12b95c07455a0afd68f5ae9008b59bb85a996d97cc752";
  };
  patches = if stdenv.isDarwin
            then [./Makefile.patch ./myocamlbuild.patch]
            else null;

  buildInputs = [ pa_ounit pa_test rsync ];
  propagatedBuildInputs = [ core_p4 bin_prot_p4 comparelib sexplib_p4 ];

  hasSharedObjects = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/re2;
    description = "OCaml bindings for RE2";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
