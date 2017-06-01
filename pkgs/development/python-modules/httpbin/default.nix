{ stdenv
, buildPythonPackage
, fetchPypi
, flask
, markupsafe
, decorator
, itsdangerous
, six }:

buildPythonPackage rec {
  pname = "httpbin";
  version = "0.5.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6b57f563900ecfe126015223a259463848daafbdc2687442317c0992773b9054";
  };

  propagatedBuildInputs = [ flask markupsafe decorator itsdangerous six ];

  meta = with stdenv.lib; {
    homepage = https://github.com/kennethreitz/httpbin;
    description = "HTTP Request & Response Service";
    license = licenses.mit;
  };
}
