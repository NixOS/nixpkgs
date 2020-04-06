{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, ffmpeg, async-timeout }:

buildPythonPackage rec {
  pname = "ha-ffmpeg";
  version = "2.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "230f2fa990c9caaff1c67c2227b64756062248083849651a9bec7d599e519a42";
  };

  buildInputs = [ ffmpeg ];

  propagatedBuildInputs = [ async-timeout ];

  # only manual tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/pvizeli/ha-ffmpeg;
    description = "Library for home-assistant to handle ffmpeg";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
