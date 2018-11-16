{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, ffmpeg, async-timeout }:

buildPythonPackage rec {
  pname = "ha-ffmpeg";
  version = "1.9";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0644j5fqw8p6li6nrnm1rw7nhvsixq1c7gik3f1yx50776yg05i8";
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
