{stdenv, buildOcaml, fetchurl, async_kernel_p4, async_unix_p4,
 bin_prot_p4, core_p4, custom_printf, fieldslib_p4, herelib, pa_ounit,
 pipebang, pa_test, sexplib_p4}:

buildOcaml rec {
  name = "async_extra";
  version = "112.24.00";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/async_extra/archive/${version}.tar.gz";
    sha256 = "51f6f67a9ad56fe5dcf09faeeca6ec2fea53a7a975a72bc80504b90841212e28";
  };

  buildInputs = [ pa_test pa_ounit ];
  propagatedBuildInputs = [ async_kernel_p4 async_unix_p4 core_p4 bin_prot_p4 custom_printf
                            fieldslib_p4 herelib pipebang sexplib_p4 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/async_extra;
    description = "Jane Street Capital's asynchronous execution library (extra)";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
