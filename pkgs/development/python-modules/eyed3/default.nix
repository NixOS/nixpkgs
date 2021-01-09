{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, python
, isPyPy
, six
, lib
, filetype
, deprecation
, dataclasses
}:

buildPythonPackage rec {
  version = "0.9.6";
  pname    = "eyeD3";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4b5064ec0fb3999294cca0020d4a27ffe4f29149e8292fdf7b2de9b9cabb7518";
  };

  # requires special test data:
  # https://github.com/nicfit/eyeD3/blob/103198e265e3279384f35304e8218be6717c2976/Makefile#L97
  doCheck = false;

  propagatedBuildInputs = [
    six filetype deprecation
  ] ++ lib.optional (pythonOlder "3.7") dataclasses;

  postInstall = ''
    for prog in "$out/bin/"*; do
      wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH" \
                          --prefix PATH : ${python}/bin
    done
  '';

  meta = with stdenv.lib; {
    description = "A Python module and command line program for processing ID3 tags";
    homepage    = "https://eyed3.nicfit.net/";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
    longDescription = ''
      eyeD3 is a Python module and command line program for processing ID3
      tags. Information about mp3 files (i.e bit rate, sample frequency, play
      time, etc.) is also provided. The formats supported are ID3 v1.0/v1.1
      and v2.3/v2.4.
    '';
  };
}
