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
  version = "2.1.0";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gvbh2a480x3ddrq6xzray7kdsz8nb8n16xm2lf03w2nqnsdbkwy";
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
