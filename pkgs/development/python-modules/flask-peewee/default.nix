{ stdenv
, buildPythonPackage
, python
, fetchPypi
, flask
, wtf-peewee
}:

buildPythonPackage rec {
  pname = "flask-peewee";
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z9v068367jd72mbr1m87xpdlsc9hwxq5shkrw9sjswpqhx4h29c";
  };

  buildInputs = [
    wtf-peewee
  ];

  doCheck = false;

  propagatedBuildInputs = [
    flask
    wtf-peewee
  ];

  meta = with stdenv.lib; {
    description = "flask integration for peewee, including admin, authentication, rest api and more";
    license = licenses.mit;
    maintainers = with maintainers; [ kuznero ];
    homepage = https://github.com/coleifer/flask-peewee;
  };
}
