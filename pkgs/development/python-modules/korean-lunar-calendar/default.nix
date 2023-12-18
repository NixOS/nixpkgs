{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "korean-lunar-calendar";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "korean_lunar_calendar";
    hash = "sha256-6yxIUSSgYQFpJr3qbYnv35uf2/FttViVts8eW+wXuFc=";
  };

  # no real tests
  pythonImportsCheck = [ "korean_lunar_calendar" ];

  meta = with lib; {
    description = "A library to convert Korean lunar-calendar to Gregorian calendar.";
    homepage = "https://github.com/usingsky/korean_lunar_calendar_py";
    license = licenses.mit;
    maintainers = [ maintainers.ris ];
  };
}
