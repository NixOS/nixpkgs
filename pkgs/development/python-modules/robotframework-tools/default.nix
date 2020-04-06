{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, robotframework
, moretools
, pathpy
, six
, zetup
, modeled
, pytest
}:

buildPythonPackage rec {
  version = "0.1rc4";
  pname = "robotframework-tools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0377ikajf6c3zcy3lc0kh4w9zmlqyplk2c2hb0yyc7h3jnfnya96";
  };

  nativeBuildInputs = [
    zetup
  ];

  propagatedBuildInputs = [
    robotframework
    moretools
    pathpy
    six
    modeled
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    # tests require network
    pytest test --ignore test/remote/test_remote.py
  '';

  meta = with stdenv.lib; {
    description = "Python Tools for Robot Framework and Test Libraries";
    homepage = https://bitbucket.org/userzimmermann/robotframework-tools;
    license = licenses.gpl3;
    maintainers = [ maintainers.costrouc ];
  };
}
