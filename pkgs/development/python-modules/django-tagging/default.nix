{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-tagging";
  version = "0.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-KNaPpIMXBeUa19HoRe1t2eNU+bb4pfY7ZVpDBkbvTo0=";
  };

  # error: invalid command 'test'
  doCheck = false;

  propagatedBuildInputs = [ django ];

  meta = {
    description = "Generic tagging application for Django projects";
    homepage = "https://github.com/Fantomas42/django-tagging";
    license = lib.licenses.AND [
      lib.licenses.mit
      lib.licenses.bsd3
    ];
  };
})
