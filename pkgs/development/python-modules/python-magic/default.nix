{ lib
, stdenv
, python
, buildPythonPackage
, fetchFromGitHub
, substituteAll
, file
, glibcLocales
}:

buildPythonPackage rec {
  pname = "python-magic";
  version = "0.4.25";

  src = fetchFromGitHub {
    owner = "ahupp";
    repo = "python-magic";
    rev = version;
    sha256 = "sha256-h7YQVH5Z7zunT6AdLPBh3TWpxLpZ5unSHDhkVDFOWDI=";
  };

  patches = [
    (substituteAll {
      src = ./libmagic-path.patch;
      libmagic = "${file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  checkInputs = [ glibcLocales ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" ${python.interpreter} test/test.py
  '';

  meta = with lib; {
    description = "A python interface to the libmagic file type identification library";
    homepage = "https://github.com/ahupp/python-magic";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
