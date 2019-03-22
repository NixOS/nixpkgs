{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, robotframework
, moretools
, pathpy
, six
, zetup
}:

buildPythonPackage rec {
  version = "0.1a115";
  pname = "robotframework-tools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04gkn1zpf3rsvbqdxrrjqqi8sa0md9gqwh6n5w2m03fdwjg4lc7q";
  };

  nativeBuildInputs = [ zetup ];

  propagatedBuildInputs = [ robotframework moretools pathpy six ];

  meta = with stdenv.lib; {
    description = "Python Tools for Robot Framework and Test Libraries";
    homepage = https://bitbucket.org/userzimmermann/robotframework-tools;
    license = licenses.gpl3;
    broken = isPy3k; # 2019-03-15, missing dependency robotframework-python3
  };
}
