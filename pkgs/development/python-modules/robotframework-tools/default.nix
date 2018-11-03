{ stdenv
, buildPythonPackage
, fetchPypi
, robotframework
, moretools
, pathpy
, six
, setuptools
}:

buildPythonPackage rec {
  version = "0.1a115";
  pname = "robotframework-tools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04gkn1zpf3rsvbqdxrrjqqi8sa0md9gqwh6n5w2m03fdwjg4lc7q";
  };

  propagatedBuildInputs = [ robotframework moretools pathpy six setuptools ];

  meta = with stdenv.lib; {
    description = "Python Tools for Robot Framework and Test Libraries";
    homepage = https://bitbucket.org/userzimmermann/robotframework-tools;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };

}
