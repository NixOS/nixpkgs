{stdenv, buildOcaml, fetchurl, type_conv,
 core_kernel_p4, bin_prot_p4, comparelib, custom_printf, enumerate,
 fieldslib_p4, herelib, pa_bench, pa_test, pa_ounit,
 pipebang, sexplib_p4, typerep_p4, variantslib_p4}:

buildOcaml rec {
  name = "core";
  version = "112.24.01";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/core/archive/${version}.tar.gz";
    sha256 = "be5d53ebd4fd04ef23ebf9b3b2840c7aeced6bc4cc6cd3f5e89f71c9949000f4";
  };

  hasSharedObjects = true;

  buildInputs = [ pa_bench pa_test pa_ounit ];
  propagatedBuildInputs = [ type_conv core_kernel_p4 bin_prot_p4 comparelib
                            custom_printf enumerate fieldslib_p4 herelib
                            pipebang sexplib_p4 typerep_p4 variantslib_p4 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/core;
    description = "Jane Street Capital's standard library overlay";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
