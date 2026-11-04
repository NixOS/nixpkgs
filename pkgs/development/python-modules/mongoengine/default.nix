{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pymongo,
  six,
  blinker,
  pytestCheckHook,
  pillow,
  coverage,
}:

buildPythonPackage rec {
  pname = "mongoengine";
  version = "0.29.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "MongoEngine";
    repo = "mongoengine";
    tag = "v${version}";
    hash = "sha256-Y+cRQW29GBGt4aC+ENx8zSocV9A5Exzq1sMDv/wcJ3M=";
  };

  propagatedBuildInputs = [
    pymongo
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
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

  meta = {
    description = "MongoEngine is a Python Object-Document Mapper for working with MongoDB";
    homepage = "http://mongoengine.org/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
