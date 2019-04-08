{ stdenv
, buildPythonPackage
, fetchurl
, sphinx
, tracing
, ttystatus
, cliapp
}:

buildPythonPackage rec {
  pname = "larch";
  version = "1.20131130";

  src = fetchurl {
    url = "http://code.liw.fi/debian/pool/main/p/python-larch/python-larch_${version}.orig.tar.gz";
    sha256 = "1hfanp9l6yc5348i3f5sb8c5s4r43y382hflnbl6cnz4pm8yh5r7";
  };

  buildInputs = [ sphinx ];
  propagatedBuildInputs = [ tracing ttystatus cliapp ];

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://liw.fi/larch/;
    description = "Python B-tree library";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rickynils ];
  };

}
