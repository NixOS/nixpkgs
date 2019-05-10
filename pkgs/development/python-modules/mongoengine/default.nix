{ stdenv
, buildPythonPackage
, python
, fetchPypi
, pymongo
, six
, pillow
, blinker
}:

buildPythonPackage rec {
  pname = "mongoengine";
  version = "0.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0947qk3yiyzixyd7pm74kzfbqi17q23a0ny7sdyfc9ypqzd9894c";
  };

  buildInputs = [
    pymongo
    six
    pillow
    blinker
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "MongoEngine is an ORM-like layer on top of PyMongo";
    longDescription = ''
      MongoEngine is a Python Object-Document Mapper for working with MongoDB.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ kuznero ];
    homepage = https://github.com/MongoEngine/mongoengine;
  };
}
