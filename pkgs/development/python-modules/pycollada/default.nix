{ stdenv, fetchurl, buildPythonPackage, numpy, isPy3k, dateutil, dateutil_1_5 }:

buildPythonPackage rec {
  name = "pycollada-0.4.1";

  src = fetchurl {
    url = "mirror://pypi/p/pycollada/${name}.tar.gz";
    sha256 = "0i50lh98550pwr95zgzrgiqzsspm09wl52xlv83y5nrsz4mblylv";
  };

  buildInputs = [ numpy ] ++ (if isPy3k then [dateutil] else [dateutil_1_5]);

  # Some tests fail because they refer to test data files that don't exist
  # (upstream packaging issue)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python library for reading and writing collada documents";
    homepage = http://pycollada.github.io/;
    license = "BSD"; # they don't specify which BSD variant
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ bjornfor ];
  };
}
