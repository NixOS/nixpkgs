{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  python,
}:

buildPythonPackage rec {
  pname = "django-js-asset";
  version = "3.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "matthiask";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-WBybDzGPoPbeUnrw6O41ton0x0rLjPcHBVMg1RZceWI=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ django ];

  pythonImportsCheck = [ "js_asset" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} tests/manage.py test testapp
    runHook postCheck
  '';

  meta = with lib; {
    description = "Script tag with additional attributes for django.forms.Media";
    homepage = "https://github.com/matthiask/django-js-asset";
    maintainers = with maintainers; [ hexa ];
    license = with licenses; [ bsd3 ];
  };
}
