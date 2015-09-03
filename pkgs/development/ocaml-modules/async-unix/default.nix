{stdenv, buildOcaml, fetchurl, async-kernel,
 bin-prot, comparelib, core, fieldslib, herelib, pa-ounit,
 pipebang, pa-test, sexplib}:

buildOcaml rec {
  name = "async-unix";
  version = "112.24.00";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/async_unix/archive/${version}.tar.gz";
    sha256 = "d490b1dc42f0987a131fa9695b55f215ad90cdaffbfac35b7f9f88f3834337ab";
  };

  hasSharedObjects = true;
  buildInputs = [ pa-ounit ];
  propagatedBuildInputs = [ async-kernel core bin-prot comparelib
                            fieldslib herelib pipebang pa-test sexplib ];

   meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/async_unix;
    description = "Jane Street Capital's asynchronous execution library (unix)";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
   };
}
