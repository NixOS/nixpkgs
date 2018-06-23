{ stdenv, buildPythonPackage, fetchFromGitHub, pytest, six, clint, pyyaml, docopt
, requests, jsonpatch, args, schema, responses, backports_csv }:

buildPythonPackage rec {

  pname = "internetarchive";
  version = "1.7.2";

  # Can't use pypi, data files for tests missing
  src = fetchFromGitHub {
    owner = "jjjake";
    repo = "internetarchive";
    rev = "v${version}";
    sha256 = "1cijagy22qi8ydrvizqmi1whnc3qr94yk0910lwgpxjywcygggir";
  };
    # It is hardcoded to specific versions, I don't know why.
    preConfigure = ''
        sed "s/schema>=.*/schema>=0.4.0',/" -i setup.py
        sed "/backports.csv/d" -i setup.py
    '';

    #phases = [ "unpackPhase" "configurePhase" "installPhase" "fixupPhase" "installCheckPhase" ];
    buildInputs = [ pytest responses ];
    propagatedBuildInputs = [
      six
      clint
      pyyaml
      docopt
      requests
      jsonpatch
      args
      schema
      backports_csv
    ];

    # Tests disabled because ia binary doesn't exist when tests run
    doCheck = false;

    checkPhase = "pytest tests";


  meta = with stdenv.lib; {
      description = "A python wrapper for the various Internet Archive APIs";
    homepage = https://github.com/jjjake/internetarchive;
    license = licenses.agpl3;
  };
}
