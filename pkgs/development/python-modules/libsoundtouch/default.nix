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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner  = "CharlesBlonde";
    repo   = "libsoundtouch";
    rev    = "875074b7a23734021974345b3dc297918e453aa2";
    sha256 = "1psd556j4x77hjxahxxgdgnq2mcd769whvnf0gmwf3jy2svfkqlg";
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
