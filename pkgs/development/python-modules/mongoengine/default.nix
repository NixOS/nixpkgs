{ lib
, buildPythonPackage
, fetchFromGitHub
, pymongo
, six
, blinker
, nose
, pillow
, coverage
}:

buildPythonPackage rec {
  pname = "mongoengine";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "MongoEngine";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gx091h9rcykdj233srrl3dfc0ly52p6r4qc9ah6z0f694kmqj1v";
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
    homepage = http://mongoengine.org/;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
