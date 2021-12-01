{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aubio";
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0fhxikvlr010nbh02g455d5y8bq6j5yw180cdh4gsd0hb43y3z26";
  };

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aubio" ];

  meta = with lib; {
    description = "a library for audio and music analysis";
    homepage = "https://aubio.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ hexa ];
  };
}
