{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  pillow,
  python-magic,
}:

buildPythonPackage rec {
  pname = "django-versatileimagefield";
  version = "3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M5DiAEgJjol78pmwNgdj0QzQiWZbeu+OupAO7Lrq0Ng=";
  };
  propagatedBuildInputs = [
    pillow
    python-magic
  ];

  nativeCheckInputs = [ django ];

  # tests not included with pypi release
  doCheck = false;

  pythonImportsCheck = [ "versatileimagefield" ];

<<<<<<< HEAD
  meta = {
    description = "Replaces django's ImageField with a more flexible interface";
    homepage = "https://github.com/respondcreate/django-versatileimagefield/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mmai ];
=======
  meta = with lib; {
    description = "Replaces django's ImageField with a more flexible interface";
    homepage = "https://github.com/respondcreate/django-versatileimagefield/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
