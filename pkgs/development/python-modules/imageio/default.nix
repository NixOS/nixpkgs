{ stdenv
, buildPythonPackage
, fetchurl
, pytest
, numpy
}:

buildPythonPackage rec {
  pname = "imageio";
  version = "1.6";

  src = fetchurl {
    url = "https://github.com/imageio/imageio/archive/v${version}.tar.gz";
    sha256 = "195snkk3fsbjqd5g1cfsd9alzs5q45gdbi2ka9ph4yxqb31ijrbv";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ numpy ];

  checkPhase = ''
    py.test
  '';

  # Tries to write in /var/tmp/.imageio
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Library for reading and writing a wide range of image, video, scientific, and volumetric data formats";
    homepage = http://imageio.github.io/;
    license = licenses.bsd2;
  };

}
