{ lib
, buildPythonPackage
, fetchPypi
, pytest
, django
, setuptools-scm
, django-configurations
, pytest-xdist
, six
}:
buildPythonPackage rec {
  pname = "pytest-django";
  version = "4.5.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9076f759bb7c36939dbdd5ae6633c18edfc2902d1a69fdbefd2426b970ce6c2";
  };

  nativeBuildInputs = [ pytest setuptools-scm ];
  nativeCheckInputs = [ pytest django-configurations pytest-xdist six ];
  propagatedBuildInputs = [ django ];

  # Complicated. Requires Django setup.
  doCheck = false;

  meta = with lib; {
    description = "py.test plugin for testing of Django applications";
    homepage = "https://pytest-django.readthedocs.org/en/latest/";
    license = licenses.bsd3;
  };
}
