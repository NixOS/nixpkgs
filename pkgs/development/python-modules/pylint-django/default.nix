{ buildPythonPackage
, fetchFromGitHub
, isPy3k
, lib

# pythonPackages
, django
, pylint-plugin-utils

# pythonPackages for checkInputs
, coverage
, factory_boy
, pytest
}:

buildPythonPackage rec {
  pname = "pylint-django";
  version = "2.4.3";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "v${version}";
    sha256 = "1mybq9jynypxbaxj921s3sx8dph8n3hmipmv4nla1g9h07g9g02z";
  };

  propagatedBuildInputs = [
    django
    pylint-plugin-utils
  ];

  checkInputs = [ coverage factory_boy pytest ];

  # Check command taken from scripts/test.sh
  # Skip test external_django_tables2_noerror_meta_class:
  # requires an unpackaged django_tables2
  checkPhase = ''
      python pylint_django/tests/test_func.py -v -k "not tables2"
  '';

  meta = with lib; {
    description = "A Pylint plugin to analyze Django applications";
    homepage = "https://github.com/PyCQA/pylint-django";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
