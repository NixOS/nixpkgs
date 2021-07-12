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
  version = "0.23.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "MongoEngine";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lj33pgdrp4rvjzcg2glvz1f87np1pfnqhlwbdcijav9rxqc0w70";
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
