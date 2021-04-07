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
  version = "0.4.22";

  src = fetchFromGitHub {
    owner = "ahupp";
    repo = "python-magic";
    rev = version;
    sha256 = "0zbdjr5shijs0jayz7gycpx0kn6v2bh83dpanyajk2vmy47jvbd6";
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

  meta = {
    description = "A python interface to the libmagic file type identification library";
    homepage = "https://github.com/ahupp/python-magic";
    license = lib.licenses.mit;
  };
}
