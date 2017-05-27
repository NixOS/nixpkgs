{ stdenv, buildPythonPackage, fetchurl,
  django, django_nose, six
}:
buildPythonPackage rec {
  pname = "django-compat";
  name = "${pname}-${version}";
  version = "1.0.14";

  src = fetchurl {
    url = "mirror://pypi/d/django-compat/${name}.tar.gz";
    sha256 = "18y5bxxmafcd4np42mzbalva5lpssq0b8ki7zckbzvdv2mnv43xj";
  };

  doCheck = false;

  buildInputs = [ django_nose ];
  propagatedBuildInputs = [ django six ];

  meta = with stdenv.lib; {
    description = "Forward and backwards compatibility layer for Django 1.4, 1.7, 1.8, 1.9, 1.10 and 1.11";
    homepage = https://github.com/arteria/django-compat;
    license = licenses.mit;
  };
}
