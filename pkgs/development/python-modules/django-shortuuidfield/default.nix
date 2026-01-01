{
  lib,
  buildPythonPackage,
  django,
  fetchPypi,
  shortuuid,
  six,
}:

buildPythonPackage rec {
  pname = "django-shortuuidfield";
  version = "0.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-opLA/lU4q+lHsTHiuRTt2axEr8xqQOrscUSOYjGj7wA=";
  };

  propagatedBuildInputs = [
    django
    shortuuid
    six
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "shortuuidfield" ];

<<<<<<< HEAD
  meta = {
    description = "Short UUIDField for Django. Good for use in urls & file names";
    homepage = "https://github.com/benrobster/django-shortuuidfield";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ derdennisop ];
=======
  meta = with lib; {
    description = "Short UUIDField for Django. Good for use in urls & file names";
    homepage = "https://github.com/benrobster/django-shortuuidfield";
    license = licenses.bsd3;
    maintainers = with maintainers; [ derdennisop ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
