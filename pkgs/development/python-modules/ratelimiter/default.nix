{ stdenv, buildPythonPackage, fetchPypi, pytest }:

let
  pname = "ratelimiter";
  version = "1.2.0.post0";
in buildPythonPackage {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c395dcabdbbde2e5178ef3f89b568a3066454a6ddc223b76473dac22f89b4f7";
  };

  preConfigure = ''
    export LC_ALL="en_US.UTF-8"
  '';

  buildInputs = [ pytest ];

  meta = with stdenv.lib; {
    homepage = https://github.com/RazerM/ratelimiter;
    description = "Simple Python module providing rate limiting";
    license = licenses.asl20;
    longDescription = ''
    The RateLimiter module ensures that an operation will not be executed more than a
    given number of times on a given period. This can prove useful when working with third
    parties APIs which require for example a maximum of 10 requests per second.
    '';
    platforms = platforms.all;
    maintainers = [ maintainers.renatoGarcia ];
  };
}
