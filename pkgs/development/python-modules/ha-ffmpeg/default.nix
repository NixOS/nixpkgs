{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, ffmpeg, async-timeout }:

buildPythonPackage rec {
  pname = "ha-ffmpeg";
  version = "1.11";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hqwpxhndxw0xj6q15c1pvwl2kz6v15m477cmy5isd1sxjxwav1q";
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
