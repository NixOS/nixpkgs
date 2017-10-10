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
  version = "1.2.0+git20171010";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "mayflower";
    repo = "git-pandas";
    rev = "5cb0a49f83e013b780703273a770f36019f7edb9";
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
