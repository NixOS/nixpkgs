{ stdenv, buildPythonPackage, fetchPypi, pytest, pytestrunner, six, regex}:

buildPythonPackage rec {
  pname = "rebulk";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v0afirbm8qr8ag53wdkf3imj8n3wxx6sq3wyd3qcgpgb5l5438v";
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
