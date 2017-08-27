{ stdenv, fetchPypi, buildPythonPackage
, nose, flask, six }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Flask-Cors";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mnsyyqn8akin2vz98b9fbv63hcvwmfkaapsglw5jizdkmaz628a";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ flask six ];

  meta = with stdenv.lib; {
    description = "A Flask extension adding a decorator for CORS support";
    homepage = https://github.com/corydolphin/flask-cors;
    license = with licenses; [ mit ];
  };
}
