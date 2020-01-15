{ stdenv, buildPythonPackage, fetchPypi
, six, pathpy, zetup, pytest
, decorator }:

buildPythonPackage rec {
  pname = "moretools";
  version = "0.1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rvd9kl0163gm5kqwsb2m44x87sp72k5pirvcmhy2ffix4pzadqp";
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
