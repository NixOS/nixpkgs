{ lib, buildPythonPackage, fetchPypi, isPy3k
, ffmpeg_3, async-timeout }:

buildPythonPackage rec {
  pname = "ha-ffmpeg";
  version = "3.0.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d92f2f5790da038d828ac862673e0bb43e8e972e4c70b1714dd9a0fb776c8d1";
  };

  buildInputs = [ ffmpeg_3 ];

  propagatedBuildInputs = [ async-timeout ];

  # only manual tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/pvizeli/ha-ffmpeg";
    description = "Library for home-assistant to handle ffmpeg";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
