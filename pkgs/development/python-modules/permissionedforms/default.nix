{
  buildPythonPackage,
  django,
  django-modelcluster,
  fetchFromGitHub,
  lib,
  python,
}:

buildPythonPackage rec {
  pname = "permissionedforms";
  version = "0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = "django-permissionedforms";
    owner = "wagtail";
    rev = "v${version}";
    sha256 = "sha256-DQzPGmh5UEVpGWnW3IrEVPkZZ8mdiW9J851Ej4agTDc=";
  };

  propagatedBuildInputs = [ django ];

  checkInputs = [ django-modelcluster ];

  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  pythonImportsCheck = [ "permissionedforms" ];

  meta = with lib; {
    description = "A Django extension for creating forms that vary according to user permissions";
    homepage = "https://github.com/wagtail/permissionedforms";
    changelog = "https://github.com/wagtail/permissionedforms/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sephi ];
  };
}
