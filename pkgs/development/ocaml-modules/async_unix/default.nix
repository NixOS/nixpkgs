{stdenv, buildOcaml, fetchurl, async_kernel,
 bin_prot, comparelib, core, fieldslib, herelib, pa_ounit,
 pipebang, pa_test, sexplib}:

buildOcaml rec {
  name = "async_unix";
  version = "112.24.00";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/async_unix/archive/${version}.tar.gz";
    sha256 = "d490b1dc42f0987a131fa9695b55f215ad90cdaffbfac35b7f9f88f3834337ab";
  };

  hasSharedObjects = true;
  buildInputs = [ pa_ounit ];
  propagatedBuildInputs = [ async_kernel core bin_prot comparelib
                            fieldslib herelib pipebang pa_test sexplib ];

   meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/async_unix;
    description = "Jane Street Capital's asynchronous execution library (unix)";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
   };
}
