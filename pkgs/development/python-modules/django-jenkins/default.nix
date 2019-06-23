{ stdenv, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-jenkins";
  version = "0.110.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mhrnki73sk705aldj4k1ssl13qw6j2fbz41wxvxr41w6a3i98d8";
  };

  propagatedBuildInputs = [ django ];

  # starts selenium server which fails with:
  # selenium.common.exceptions.SessionNotCreatedException: Message: Unable to find a matching set of capabilities
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Plug and play continuous integration with django and jenkins";
    homepage = https://github.com/kmmbvnr/django-jenkins;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ gerschtli ];
  };
}
