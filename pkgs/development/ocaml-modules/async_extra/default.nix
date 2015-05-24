{stdenv, buildOcaml, fetchurl, async_kernel, async_unix,
 bin_prot, core, custom_printf, fieldslib, herelib, pa_ounit,
 pipebang, pa_test, sexplib}:

buildOcaml rec {
  name = "async_extra";
  version = "112.24.00";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/async_extra/archive/${version}.tar.gz";
    sha256 = "51f6f67a9ad56fe5dcf09faeeca6ec2fea53a7a975a72bc80504b90841212e28";
  };

  buildInputs = [ pa_test pa_ounit ];
  propagatedBuildInputs = [ async_kernel async_unix core bin_prot custom_printf
                            fieldslib herelib pipebang sexplib ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/async_extra;
    description = "Jane Street Capital's asynchronous execution library (extra)";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
