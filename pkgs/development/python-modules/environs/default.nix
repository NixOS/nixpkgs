{
  lib,
  buildPythonPackage,
  dj-database-url,
  dj-email-url,
  django-cache-url,
  fetchFromGitHub,
  flit-core,
  marshmallow,
  pytestCheckHook,
  python-dotenv,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "environs";
  version = "14.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sloria";
    repo = "environs";
    tag = version;
    hash = "sha256-g9n4GuVSHB2VourVYlzp3zKO7MnJK4IAakbYV5tM8Uc=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    marshmallow
    python-dotenv
  ];

  nativeCheckInputs = [
    dj-database-url
    dj-email-url
    django-cache-url
    pytestCheckHook
  ];

  pythonImportsCheck = [ "environs" ];

  meta = with lib; {
    description = "Python modle for environment variable parsing";
    homepage = "https://github.com/sloria/environs";
    changelog = "https://github.com/sloria/environs/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
