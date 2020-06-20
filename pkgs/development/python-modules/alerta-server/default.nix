{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, pyyaml
, python-dateutil, requests, pymongo, raven, bcrypt, flask, pyjwt, flask-cors, psycopg2, pytz, flask-compress, jinja2
}:

buildPythonPackage rec {
  pname = "alerta-server";
  version = "7.5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6d80654f063af45167c6b4f5f25a9015e728f3f600c5565ddb85964b8c9874b";
  };

  propagatedBuildInputs = [ python-dateutil requests pymongo raven bcrypt flask pyjwt flask-cors psycopg2 pytz flask-compress jinja2 pyyaml];

  doCheck = false; # We can't run the tests from Nix, because they rely on the presence of a working MongoDB server

  postInstall = ''
    wrapProgram $out/bin/alertad --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  disabled = pythonOlder "3.5";

  meta = with stdenv.lib; {
    homepage = "https://alerta.io";
    description = "Alerta Monitoring System server";
    license = licenses.asl20;
  };
}
