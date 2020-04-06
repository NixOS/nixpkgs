{ stdenv, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "pybotvac";
  version = "0.0.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f212f0df8a946c0fa25f0c20c3c9decd9ddc4dbd9b48592a3283e7481112923e";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "Python package for controlling Neato pybotvac Connected vacuum robot";
    homepage = https://github.com/stianaske/pybotvac;
    license = licenses.mit;
    maintainers = with maintainers; [ elseym ];
  };
}
