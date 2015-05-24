{stdenv, buildOcaml, fetchurl, async, comparelib, core, ctypes, openssl,
 fieldslib, herelib, pa_bench, pa_ounit, pipebang, pa_test, sexplib}:

buildOcaml rec {
  name = "async_ssl";
  version = "112.24.03";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/async_ssl/archive/${version}.tar.gz";
    sha256 = "1b0bea92142eef11da6bf649bbe229bd4b8d9cc807303d8142406908c0d28c68";
  };

  buildInputs = [ pa_bench pa_test ];
  propagatedBuildInputs = [ ctypes async comparelib core fieldslib pa_ounit
                            herelib pipebang sexplib openssl ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/async_ssl;
    description = "Async wrappers for ssl";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
