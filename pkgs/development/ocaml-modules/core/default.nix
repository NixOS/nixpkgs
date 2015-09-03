{stdenv, buildOcaml, fetchurl, type-conv,
 core-kernel, bin-prot, comparelib, custom-printf, enumerate,
 fieldslib, herelib, pa-bench, pa-test, pa-ounit,
 pipebang, sexplib, typerep, variantslib}:

buildOcaml rec {
  name = "core";
  version = "112.24.01";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/core/archive/${version}.tar.gz";
    sha256 = "be5d53ebd4fd04ef23ebf9b3b2840c7aeced6bc4cc6cd3f5e89f71c9949000f4";
  };

  hasSharedObjects = true;

  buildInputs = [ pa-bench pa-test pa-ounit ];
  propagatedBuildInputs = [ type-conv core-kernel bin-prot comparelib
                            custom-printf enumerate fieldslib herelib
                            pipebang sexplib typerep variantslib ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/core;
    description = "Jane Street Capital's standard library overlay";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
