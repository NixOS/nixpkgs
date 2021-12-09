{ lib
, buildPythonPackage
, fetchFromGitHub
, inflection
, ruamel-yaml
, setuptools-scm
, six
, coreapi
, djangorestframework
, pytestCheckHook
, pytest-django
, datadiff
}:

buildPythonPackage rec {
  pname = "drf-yasg";
  version = "1.20.0";

  src = fetchFromGitHub {
     owner = "axnsan12";
     repo = "drf-yasg";
     rev = "1.20.0";
     sha256 = "1k0b7n7cydhw204mzw658q9skakfy95nf4p0rhlrgz1nsvyvxz6d";
  };

  postPatch = ''
    # https://github.com/axnsan12/drf-yasg/pull/710
    substituteInPlace requirements/base.txt --replace packaging ""
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    six
    inflection
    ruamel-yaml
    coreapi
    djangorestframework
  ];

  checkInputs = [
    pytestCheckHook
    pytest-django
    datadiff
  ];

  # ImportError: No module named 'testproj.settings'
  doCheck = false;

  pythonImportsCheck = [ "drf_yasg" ];

  meta = with lib; {
    description = "Generation of Swagger/OpenAPI schemas for Django REST Framework";
    homepage = "https://github.com/axnsan12/drf-yasg";
    maintainers = with maintainers; [ ];
    license = licenses.bsd3;
  };
}
