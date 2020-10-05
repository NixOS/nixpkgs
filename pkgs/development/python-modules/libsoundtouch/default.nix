{ buildPythonPackage
, fetchFromGitHub
, stdenv
, lib
, pythonOlder
, requests
, enum34
}:

buildPythonPackage {
  pname   = "libsoundtouch";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner  = "CharlesBlonde";
    repo   = "libsoundtouch";
    rev    = version;
    sha256 = "1wl2w5xfdkrv0qzsz084z2k6sycfyq62mqqgciycha3dywf2fvva";
  };

  postPatch = lib.optionalString (! (pythonOlder "3.4")) ''
    substituteInPlace setup.py --replace "'enum34>=1.1.6'" ""
  '';

  propagatedBuildInputs = [ requests enum34 ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Bose Soundtouch Python library";
    homepage    = "https://github.com/CharlesBlonde/libsoundtouch";
    license     = licenses.asl20;
  };
}
