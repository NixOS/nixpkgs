{ buildPythonPackage
, fetchFromGitHub
, python
, stdenv
, pandas
, GitPython
, requests
, redis
}:

buildPythonPackage rec {
  pname = "git-pandas";
  version = "1.2.0+git20170723";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "wdm0006";
    repo = "git-pandas";
    rev = "4ba60a3878520afa86184dce825f5ed3fe07b5f7";
    sha256 = "1ggp4zlrbmi13wi6mdx5cs15mlgjiv53qpp34h8vngzzbvsylxp0";
  };

  propagatedBuildInputs = [ pandas GitPython requests redis ];

  doCheck = false;

  meta = {
    homepage = https://github.com/wdm0006/git-pandas;
    description = "A simple set of wrappers around gitpython for creating pandas dataframes out of git data";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ globin ];
    platforms = stdenv.lib.platforms.unix;
  };
}
