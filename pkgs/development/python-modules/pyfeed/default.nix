{ stdenv, buildPythonPackage, fetchurl
, xe }:

buildPythonPackage rec {
  url = "http://www.blarg.net/%7Esteveha/pyfeed-0.7.4.tar.gz";

  name = stdenv.lib.nameFromURL url ".tar";

  src = fetchurl {
    inherit url;
    sha256 = "1h4msq573m7wm46h3cqlx4rsn99f0l11rhdqgf50lv17j8a8vvy1";
  };

  propagatedBuildInputs = [ xe ];

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "http://home.blarg.net/~steveha/pyfeed.html";
    description = "Tools for syndication feeds";
  };
}
