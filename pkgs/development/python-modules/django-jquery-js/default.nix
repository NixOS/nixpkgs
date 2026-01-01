{
  lib,
  buildPythonPackage,
  fetchFromBitbucket,
  django,
}:

buildPythonPackage rec {
  pname = "django-jquery-js";
  version = "3.1.1";
  format = "setuptools";

  src = fetchFromBitbucket {
    owner = "tim_heap";
    repo = "django-jquery";
    rev = "refs/tags/v${version}";
    hash = "sha256-TzMo31jFhcvlrmq2TJgQyds9n8eATaChnyhnQ7bwdzs=";
  };

  buildInputs = [ django ];

  pythonImportsCheck = [ "jquery" ];

  doCheck = false; # no tests

<<<<<<< HEAD
  meta = {
    description = "jQuery, bundled up so apps can depend upon it";
    homepage = "https://bitbucket.org/tim_heap/django-jquery";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
=======
  meta = with lib; {
    description = "jQuery, bundled up so apps can depend upon it";
    homepage = "https://bitbucket.org/tim_heap/django-jquery";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
