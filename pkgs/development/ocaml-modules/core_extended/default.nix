{stdenv, buildOcaml, fetchurl, bin_prot_p4, comparelib, core_p4, custom_printf,
 fieldslib_p4, pa_bench, pa_ounit, pipebang, pa_test, textutils_p4, re2_p4, sexplib_p4}:

buildOcaml rec {
  name = "core_extended";
  version = "112.24.00";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/core_extended/archive/${version}.tar.gz";
    sha256 = "f87b0661b6c2cfb545ec61d1cb2ab1b9c4967b6ac14e651de41d3a6fb7f0f1e3";
  };

  preConfigure = stdenv.lib.optionalString stdenv.isLinux ''
    patch lib/extended_unix_stubs.c <<EOF
    0a1
    > #define _LINUX_QUOTA_VERSION 2
    EOF
  '';

  hasSharedObjects = true;
  buildInputs = [ pa_bench pa_test pa_ounit ];
  propagatedBuildInputs = [bin_prot_p4 comparelib core_p4 custom_printf fieldslib_p4
                           pipebang textutils_p4 re2_p4 sexplib_p4 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/core_extended;
    description = "Jane Street Capital's standard library overlay";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
