{stdenv, buildOcamlJane, fetchurl, async, ctypes, openssl }:

buildOcamlJane rec {
  name = "async_ssl";
  version = "113.33.03";
  hash = "1f0sprdkhr1wlf4lg3yrbhgpbpx3hw696xnki6v8przhs2z10xsq";
  buildInputs = [ openssl ];
  propagatedBuildInputs = [ async ctypes ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/async_ssl;
    description = "Async wrappers for ssl";
    license = licenses.asl20;
    maintainers = [ maintainers.sternenseemann ];
  };
}
