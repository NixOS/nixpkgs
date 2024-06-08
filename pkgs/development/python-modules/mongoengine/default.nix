{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pymongo,
  isPy27,
  six,
  blinker,
  nose,
  pillow,
  coverage,
}:

buildPythonPackage rec {
  pname = "mongoengine";
  version = "0.28.2";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "MongoEngine";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-5wcviRqUTOKqaeusHxS4Er3LD1BpTMW02Tip3d4zAPM=";
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
    maintainers = [ ];
  };
}
