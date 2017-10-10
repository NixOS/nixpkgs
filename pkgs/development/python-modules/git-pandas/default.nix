{ buildPythonPackage
, fetchPypi
, python
, stdenv
, pandas
, GitPython
, requests
}:

buildPythonPackage rec {
  pname = "git-pandas";
  version = "1.2.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bgyspzf9yb6s9s5p68qr0pi7vg91xj4rll9axm1wahafqfvf729";
  };

  propagatedBuildInputs = [ pandas GitPython requests ];

  doCheck = false;

  meta = {
    homepage = https://github.com/wdm0006/git-pandas;
    description = "A simple set of wrappers around gitpython for creating pandas dataframes out of git data";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ globin ];
    platforms = stdenv.lib.platforms.unix;
  };
}
