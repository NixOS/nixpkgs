{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,
  setuptools,
  filetype,
  deprecation,
}:

buildPythonPackage rec {
  version = "0.9.9";
  pname = "eyed3";
  pyproject = true;

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "nicfit";
    repo = "eyeD3";
    tag = "v${version}";
    hash = "sha256-Brtxi0B52kvSU12va5X+KNtNV9cyK2TUefyZYZI87JQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    deprecation
    filetype
  ];

  # requires special test data:
  # https://github.com/nicfit/eyeD3/blob/103198e265e3279384f35304e8218be6717c2976/Makefile#L97
  doCheck = false;

  meta = {
    description = "Python module and command line program for processing ID3 tags";
    mainProgram = "eyeD3";
    downloadPage = "https://github.com/nicfit/eyeD3";
    homepage = "https://eyed3.nicfit.net/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ lovek323 ];
    platforms = lib.platforms.unix;
    longDescription = ''
      eyeD3 is a Python module and command line program for processing ID3
      tags. Information about mp3 files (i.e bit rate, sample frequency, play
      time, etc.) is also provided. The formats supported are ID3 v1.0/v1.1
      and v2.3/v2.4.
    '';
  };
}
