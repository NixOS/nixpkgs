{stdenv, buildOcaml, fetchurl, type-conv,
 bin-prot, comparelib, custom-printf, enumerate,
 fieldslib, herelib, pa-bench, pa-test, pa-ounit,
 pipebang, sexplib, typerep, variantslib}:

buildOcaml rec {
  name = "core-kernel";
  version = "112.24.00";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/core_kernel/archive/${version}.tar.gz";
    sha256 = "93e1f21e35ade98a2bfbe45ba76eef4a8ad3fed97cdc0769f96e0fcc86d6a761";
  };

  hasSharedObjects = true;

  buildInputs = [ pa-test pa-ounit ];
  propagatedBuildInputs = [ type-conv pa-bench bin-prot comparelib custom-printf
                            enumerate fieldslib herelib pipebang sexplib
                            typerep variantslib ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/core_kernel;
    description = "Jane Street Capital's standard library overlay (kernel)";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
