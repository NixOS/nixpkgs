{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  markdown,
  pillow,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-markdownx";
  version = "4.0.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "neutronX";
    repo = "django-markdownx";
    tag = "v${version}";
    hash = "sha256-il9bXi8URq7mQMCyKl5ikHT4nH2R9ixMDHSpH8gfnVU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    django
    markdown
    pillow
  ];

  # tests only executable in vagrant
  doCheck = false;

  pythonImportsCheck = [ "markdownx" ];

  meta = with lib; {
    description = "Comprehensive Markdown plugin built for Django";
    homepage = "https://github.com/neutronX/django-markdownx/";
    changelog = "https://github.com/neutronX/django-markdownx/releases/tag/${src.tag}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ derdennisop ];
  };
}
