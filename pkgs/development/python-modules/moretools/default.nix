{ stdenv, buildPythonPackage, fetchPypi
, six, pathpy, zetup, pytest
, decorator }:

buildPythonPackage rec {
  pname = "moretools";
  version = "0.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f531cc79b7cd0c4aab590d5d4d0291f7cf6f083398be1dd523224b3385b732f4";
  };

  checkPhase = ''
    py.test test
  '';

  nativeBuildInputs = [ zetup ];
  checkInputs = [ six pathpy pytest ];
  propagatedBuildInputs = [ decorator ];

  meta = with stdenv.lib; {
    description = ''
      Many more basic tools for python 2/3 extending itertools, functools, operator and collections
    '';
    homepage = https://bitbucket.org/userzimmermann/python-moretools;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
