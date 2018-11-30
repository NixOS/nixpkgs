{ stdenv
, buildPythonPackage
, fetchgit
, fetchurl
, pyramid
, simplejson
, konfig
}:

buildPythonPackage rec {
  pname = "mozsvc";
  version = "0.8";

  src = fetchgit {
    url = https://github.com/mozilla-services/mozservices.git;
    rev = "refs/tags/${version}";
    sha256 = "1zci2ikk83mf7va88c83dr6snfh4ddjqw0lsg3y29qk5nxf80vx2";
  };

  patches = stdenv.lib.singleton (fetchurl {
    url = https://github.com/nbp/mozservices/commit/f86c0b0b870cd8f80ce90accde9e16ecb2e88863.diff;
    sha256 = "1lnghx821f6dqp3pa382ka07cncdz7hq0mkrh44d0q3grvrlrp9n";
  });

  doCheck = false; # lazy packager
  propagatedBuildInputs = [ pyramid simplejson konfig ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mozilla-services/mozservices;
    description = "Various utilities for Mozilla apps";
    license = licenses.mpl20;
  };

}
