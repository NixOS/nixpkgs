{ stdenv, buildPythonPackage, fetchPypi, pytest, pytestrunner, six, regex}:

buildPythonPackage rec {
  pname = "rebulk";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "162rad86slg4gmzxy33pnyyzm4hhcszcpjpw1vk79f3gxzvy8j8x";
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
