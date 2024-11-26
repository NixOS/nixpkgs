{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pymongo,
  isPy27,
  six,
  blinker,
  pytestCheckHook,
  pillow,
  coverage,
}:

buildPythonPackage rec {
  pname = "mongoengine";
  version = "0.29.1";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "MongoEngine";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-trWCKmCa+q+qtzF0HKCZMnko1cvvpwJvczLFuKtB83E=";
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

  meta = with lib; {
    description = "MongoEngine is a Python Object-Document Mapper for working with MongoDB";
    homepage = "http://mongoengine.org/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
