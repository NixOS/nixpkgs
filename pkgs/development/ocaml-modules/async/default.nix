{stdenv, buildOcaml, fetchurl, async_kernel_p4,
 async_unix_p4, async_extra_p4, pa_ounit}:

buildOcaml rec {
  name = "async";
  version = "112.24.00";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/async/archive/${version}.tar.gz";
    sha256 = "ecc4ca939ab098e689332921b110dbaacd06d9f8d8bf697023dfff3ca37dc1e9";
  };

  propagatedBuildInputs = [ async_kernel_p4 async_unix_p4 async_extra_p4 pa_ounit ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/async;
    description = "Jane Street Capital's asynchronous execution library";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
