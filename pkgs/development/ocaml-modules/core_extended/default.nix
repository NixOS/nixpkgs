{stdenv, buildOcaml, fetchurl, bin_prot, comparelib, core, custom_printf,
 fieldslib, pa_bench, pa_ounit, pipebang, pa_test, textutils, re2, sexplib}:

buildOcaml rec {
  name = "core_extended";
  version = "112.24.00";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/core_extended/archive/${version}.tar.gz";
    sha256 = "f87b0661b6c2cfb545ec61d1cb2ab1b9c4967b6ac14e651de41d3a6fb7f0f1e3";
  };

  hasSharedObjects = true;
  buildInputs = [ pa_bench pa_test pa_ounit ];
  propagatedBuildInputs = [bin_prot comparelib core custom_printf fieldslib
                           pipebang textutils re2 sexplib ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/core_extended;
    description = "Jane Street Capital's standard library overlay";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
