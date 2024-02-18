{ lib
, buildPythonPackage
, django
, fetchPypi
, fetchurl
, mock
, python
, six
}:
let
  # tests script. It's not included in pypi but we can't use a GitHub src because versions > 1.2.5
  # are not tagged.
  runtests = fetchurl {
    url = "https://raw.githubusercontent.com/meneses-pt/django-background-tasks/cca4921806087c9f87e9698369ae4c61ef74660f/runtests.py";
    hash = "sha256-BNziFzBborafjsp1BfgqbbnIVONO4qZpUYPvjfQCuac=";
  };
in
buildPythonPackage rec {
  pname = "django4-background-tasks";
  version = "1.2.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-on3eyKDIUOXu3u9HZ9rNBnZXrrSEx+g1k9r1nBZDPOI=";
  };

  propagatedBuildInputs = [
    django
    six
  ];

  nativeCheckInputs = [
    mock
  ];

  pythonImportsCheck = [
    "background_task"
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} ${runtests}
    runHook postCheck
  '';

  meta = with lib; {
    description = "A database-backed work queue for Django ";
    homepage = "https://github.com/meneses-pt/django-background-tasks";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rogryza ];
  };
}
