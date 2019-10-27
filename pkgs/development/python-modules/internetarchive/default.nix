{ buildPythonPackage, fetchFromGitHub, pytest, six, clint, pyyaml, docopt
, requests, jsonpatch, args, schema, responses, backports_csv, isPy3k
, lib, glibcLocales }:

buildPythonPackage rec {
  pname = "internetarchive";
  version = "1.8.1";

  # Can't use pypi, data files for tests missing
  src = fetchFromGitHub {
    owner = "jjjake";
    repo = "internetarchive";
    rev = "v${version}";
    sha256 = "1fdb0kr9hzgyh0l8d02khcjpsgyd63nbablhc49ncdsav3dhhr3f";
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
  ] ++ lib.optional (!isPy3k) backports_csv;

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
