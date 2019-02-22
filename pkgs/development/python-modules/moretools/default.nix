{ stdenv, buildPythonPackage, fetchPypi
, six, pathpy, zetup, pytest
, decorator }:

buildPythonPackage rec {
  pname = "moretools";
  version = "0.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03ni7k0kcgrm3y605c29gqlyp779fx1xc3r8xb742lzd6ni30kdg";
  };

  checkPhase = ''
    py.test test
  '';

  buildInputs = [ six pathpy pytest ];
  propagatedBuildInputs = [ decorator zetup ];

  meta = with stdenv.lib; {
    description = ''
      Many more basic tools for python 2/3 extending itertools, functools, operator and collections
    '';
    homepage = https://bitbucket.org/userzimmermann/python-moretools;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
