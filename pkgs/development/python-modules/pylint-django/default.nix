{ buildPythonPackage
, fetchFromGitHub
, isPy3k
, lib

# pythonPackages
, django
, pylint-plugin-utils
}:

buildPythonPackage rec {
  pname = "pylint-django";
  version = "2.0.14";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "v${version}";
    sha256 = "07fkwb4phfr71dpajnq6l64phjxvljx2nf8ibs12n9gwjdvm9i52";
  };

  propagatedBuildInputs = [
    django
    pylint-plugin-utils
  ];

  # Testing requires checkout from other repositories
  doCheck = false;

  meta = with lib; {
    description = "A Pylint plugin to analyze Django applications";
    homepage = "https://github.com/PyCQA/pylint-django";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
