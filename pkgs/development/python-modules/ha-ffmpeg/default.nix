{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, ffmpeg, async-timeout }:

buildPythonPackage rec {
  pname = "ha-ffmpeg";
  version = "1.11";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "386cc5bbec3a341d8bafec1c524bd8e64f41f9be8195808dec80f76661bf1cc3";
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
