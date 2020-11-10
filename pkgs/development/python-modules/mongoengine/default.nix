{ lib
, buildPythonPackage
, fetchFromGitHub
, pymongo
, isPy27
, six
, blinker
, nose
, pillow
, coverage
}:

buildPythonPackage rec {
  pname = "mongoengine";
  version = "0.20.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "MongoEngine";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wc0cvjanlszn09n61jj38pq9wdlphkjgrp3c8hvd16754is3n7f";
  };

  propagatedBuildInputs = [
    pymongo
    six
  ];

  checkInputs = [
    nose
    pillow
    coverage
    blinker
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "coverage==4.2" "coverage"
  '';

  # tests require mongodb running in background
  doCheck = false;

  meta = with lib; {
    description = "MongoEngine is a Python Object-Document Mapper for working with MongoDB";
    homepage = "http://mongoengine.org/";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
