{stdenv, buildOcaml, fetchurl, core_kernel_p4,
 bin_prot_p4, fieldslib_p4, pa_ounit, pa_test,
 sexplib_p4, herelib}:

buildOcaml rec {
  name = "async_kernel";
  version = "112.24.00";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/async_kernel/archive/${version}.tar.gz";
    sha256 = "95caf4249b55c5a6b38da56e314845e9ea9a0876eedd4cf0ddcb6c8dd660c6a0";
  };

  buildInputs = [ pa_test pa_ounit ];
  propagatedBuildInputs = [ core_kernel_p4 bin_prot_p4 fieldslib_p4 herelib sexplib_p4 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/async_kernel;
    description = "Jane Street Capital's asynchronous execution library (core) ";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
