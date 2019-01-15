{ stdenv, fetchFromGitHub, buildPythonPackage, pyparsing, six }:

buildPythonPackage rec {
  pname = "configshell";
  version = "1.1.fb25";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo ="${pname}-fb";
    rev = "v${version}";
    sha256 = "0zpr2n4105qqsklyfyr9lzl1rhxjcv0mnsl57hgk0m763w6na90h";
  };

  propagatedBuildInputs = [ pyparsing six ];

  meta = with stdenv.lib; {
    description = "A Python library for building configuration shells";
    homepage = https://github.com/open-iscsi/configshell-fb;
    license = licenses.asl20;
  };
}
