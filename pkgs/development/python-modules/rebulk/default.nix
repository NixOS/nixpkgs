{ stdenv, buildPythonPackage, fetchPypi, pytest, pytestrunner, six, regex}:

buildPythonPackage rec {
  pname = "rebulk";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b0d526859ef3e8647f37c606d7ae7c32259e370b3f1519e4219a3ba72740aec";
  };

  # Some kind of trickery with imports that doesn't work.
  doCheck = false;
  buildInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ six regex ];

  meta = with stdenv.lib; {
    homepage = https://github.com/Toilal/rebulk/;
    license = licenses.mit;
    description = "Advanced string matching from simple patterns";
  };
}
