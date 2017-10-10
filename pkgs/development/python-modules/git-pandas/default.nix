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
    sha256 = "071pgy79ikfwqzvazp8zv4ikaap7phrasfn13wi6lz6rcbp2c0z8";
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
