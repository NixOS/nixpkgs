{ stdenv, buildPythonPackage, fetchPypi, django }:
buildPythonPackage rec {
  version = "3.10.3";
  pname = "djangorestframework";

  src = fetchPypi {
    inherit pname version;
    sha256 = "140hwz52rlqqc10gbw5bhyyi4zbpqj3z7wgnh2jrhs2wfzwwp0fw";
  };

  # Test settings are missing
  doCheck = false;

  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "Web APIs for Django, made easy";
    homepage = https://www.django-rest-framework.org/;
    maintainers = with maintainers; [ desiderius ];
    license = licenses.bsd2;
  };
}
