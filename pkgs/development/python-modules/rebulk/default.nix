{ stdenv, buildPythonPackage, fetchPypi, pytest, pytestrunner, six, regex}:

buildPythonPackage rec {
  pname = "rebulk";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "320ded3cc456347d828f95e9aa5f8bab77ac01943cad024c06012069fe19690a";
  };

  # Some kind of trickery with imports that doesn't work.
  doCheck = false;
  buildInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ six regex ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/Toilal/rebulk/";
    license = licenses.mit;
    description = "Advanced string matching from simple patterns";
  };
}
