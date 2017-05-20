{ buildPythonPackage
, fetchFromGitHub
, stdenv
, lib
, pythonOlder
, requests
, enum34
}:

buildPythonPackage rec {
  name    = "${pname}-${version}";
  pname   = "libsoundtouch";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner  = "CharlesBlonde";
    repo   = "libsoundtouch";
    rev    = "7c8f943298bcae5f0c25ad7be7469de51373cdbd";
    sha256 = "1a9mdy09n4bjx6nang7wfn2nq87dg2s18px4yqsj53mn5kjf44n0";
  };

  postPatch = lib.optionalString (! (pythonOlder "3.4")) ''
    substituteInPlace setup.py --replace "'enum34>=1.1.6'" ""
  '';

  propagatedBuildInputs = [ requests enum34 ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Bose Soundtouch Python library";
    homepage    = https://github.com/CharlesBlonde/libsoundtouch;
    license     = licenses.asl20;
  };
}
