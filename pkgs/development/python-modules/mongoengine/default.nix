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
  version = "0.26.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "MongoEngine";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-mPz9Nyoyke++e9vBWSKunc9VGHCP8pbmldgKty5HIMA=";
  };

  propagatedBuildInputs = [
    pymongo
    six
  ];

  nativeCheckInputs = [
    nose
    pillow
    coverage
    blinker
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "coverage==4.2" "coverage" \
      --replace "pymongo>=3.4,<=4.0" "pymongo"
  '';

  # tests require mongodb running in background
  doCheck = false;

  pythonImportsCheck = [ "mongoengine" ];

  meta = with lib; {
    description = "MongoEngine is a Python Object-Document Mapper for working with MongoDB";
    homepage = "http://mongoengine.org/";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
