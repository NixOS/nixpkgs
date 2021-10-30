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
  version = "0.4.24";

  src = fetchFromGitHub {
    owner = "ahupp";
    repo = "python-magic";
    rev = version;
    sha256 = "17jalhjbfd600lzfz296m0nvgp6c7vx1mgz82jbzn8hgdzknf4w0";
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
