{ stdenv, buildPythonPackage, fetchPypi, pytest, pytestrunner, six, regex}:

buildPythonPackage rec {
  pname = "rebulk";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11164sy9vwphf7iw60n4hmns2q6anazrkhc15lwi6sb2qmkjc541";
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
