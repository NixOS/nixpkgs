{ buildPythonPackage, fetchFromGitHub, pytest, six, clint, pyyaml, docopt
, requests, jsonpatch, args, schema, responses, backports_csv, isPy3k
, lib, glibcLocales, setuptools }:

buildPythonPackage rec {
  pname = "internetarchive";
  version = "1.9.0";

  # Can't use pypi, data files for tests missing
  src = fetchFromGitHub {
    owner = "jjjake";
    repo = "internetarchive";
    rev = "v${version}";
    sha256 = "1h344c04ipzld4s7xk8d84f80samjjlgzvv3y8zsv0n1c895gymb";
  };

  propagatedBuildInputs = [
    six
    clint
    pyyaml
    docopt
    requests
    jsonpatch
    args
    schema
    setuptools
    backports_csv
  ];

  checkInputs = [ pytest responses glibcLocales ];

  # tests depend on network
  doCheck = false;

  checkPhase = ''
    LC_ALL=en_US.utf-8 pytest tests
  '';

  meta = with lib; {
    description = "A python wrapper for the various Internet Archive APIs";
    homepage = https://github.com/jjjake/internetarchive;
    license = licenses.agpl3;
  };
}
