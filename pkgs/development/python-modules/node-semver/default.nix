{ stdenv, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  version = "0.4.2";
  pname = "node-semver";

  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p1in8lw0s5zrya47xn73n10nynrambh62ms4xb6jbadvb06jkz9";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/podhmo/python-semver;
    description = "A port of node-semver";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
