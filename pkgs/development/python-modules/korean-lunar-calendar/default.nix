{
  lib,
  buildPythonPackage,
  fetchPypi,
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

<<<<<<< HEAD
  meta = {
    description = "Library to convert Korean lunar-calendar to Gregorian calendar";
    homepage = "https://github.com/usingsky/korean_lunar_calendar_py";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ris ];
=======
  meta = with lib; {
    description = "Library to convert Korean lunar-calendar to Gregorian calendar";
    homepage = "https://github.com/usingsky/korean_lunar_calendar_py";
    license = licenses.mit;
    maintainers = [ maintainers.ris ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
