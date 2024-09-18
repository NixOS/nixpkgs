{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  six,
  filetype,
  deprecation,
}:

buildPythonPackage rec {
  version = "0.9.7";
  pname = "eyeD3";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k7GOk5M3akURT5QJ18yhGftvT5o31LaXtQCvSLTFzw8=";
  };

  # requires special test data:
  # https://github.com/nicfit/eyeD3/blob/103198e265e3279384f35304e8218be6717c2976/Makefile#L97
  doCheck = false;

  propagatedBuildInputs = [
    deprecation
    filetype
    six
  ];

  meta = with lib; {
    description = "Python module and command line program for processing ID3 tags";
    mainProgram = "eyeD3";
    homepage = "https://eyed3.nicfit.net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.unix;
    longDescription = ''
      eyeD3 is a Python module and command line program for processing ID3
      tags. Information about mp3 files (i.e bit rate, sample frequency, play
      time, etc.) is also provided. The formats supported are ID3 v1.0/v1.1
      and v2.3/v2.4.
    '';
  };
}
