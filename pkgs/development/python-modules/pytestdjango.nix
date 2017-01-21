{ stdenv, buildPythonPackage, fetchurl
, pytest, django, setuptools_scm
}:
buildPythonPackage rec {
  name = "pytest-django-${version}";
  version = "3.1.2";

  src = fetchurl {
    url = "mirror://pypi/p/pytest-django/${name}.tar.gz";
    sha256 = "02932m2sr8x22m4az8syr8g835g4ak77varrnw71n6xakmdcr303";
  };

  buildInputs = [ pytest setuptools_scm ];
  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "py.test plugin for testing of Django applications";
    homepage = http://pytest-django.readthedocs.org/en/latest/;
    license = licenses.bsd3;
  };
}
