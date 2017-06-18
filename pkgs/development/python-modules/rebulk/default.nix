{ stdenv, buildPythonPackage, fetchPypi, pytest, pytestrunner, six, regex}:

buildPythonPackage rec {
  pname = "rebulk";
  version = "0.9.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sw516ihfrb7i9bfl1n3049akvb23mpsk3llh7w3xfnbvkfrpip0";
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
