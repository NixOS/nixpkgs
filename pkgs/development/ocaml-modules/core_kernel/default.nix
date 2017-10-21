{stdenv, buildOcaml, fetchurl, type_conv,
 bin_prot_p4, comparelib, custom_printf, enumerate,
 fieldslib_p4, herelib, pa_bench, pa_test, pa_ounit,
 pipebang, sexplib_p4, typerep_p4, variantslib_p4}:

buildOcaml rec {
  name = "core_kernel";
  version = "112.24.00";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/core_kernel/archive/${version}.tar.gz";
    sha256 = "93e1f21e35ade98a2bfbe45ba76eef4a8ad3fed97cdc0769f96e0fcc86d6a761";
  };

  hasSharedObjects = true;

  buildInputs = [ pa_test pa_ounit ];
  propagatedBuildInputs = [ type_conv pa_bench bin_prot_p4 comparelib custom_printf
                            enumerate fieldslib_p4 herelib pipebang sexplib_p4
                            typerep_p4 variantslib_p4 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/core_kernel;
    description = "Jane Street Capital's standard library overlay (kernel)";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
