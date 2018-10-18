{ stdenv
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-classy-tags";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wxvpmjdzk0aajk33y4himn3wqjx7k0aqlka9j8ay3yfav78bdq0";
  };

  propagatedBuildInputs = [ django ];

  # tests appear to be broken on 0.6.1 at least
  doCheck = ( version != "0.6.1" );

  meta = with stdenv.lib; {
    description = "Class based template tags for Django";
    homepage = https://github.com/ojii/django-classy-tags;
    license = licenses.bsd3;
  };

}
