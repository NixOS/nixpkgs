{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "precis-i18n";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "byllyfish";
    repo = "precis_i18n";
    tag = "v${version}";
    hash = "sha256-ZMj9KqiPVrpmq4/FweLMDxWQVQEtykimNhMTS9Mh5QY=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "precis_i18n" ];

  meta = with lib; {
    description = "Internationalized usernames and passwords";
    homepage = "https://github.com/byllyfish/precis_i18n";
    changelog = "https://github.com/byllyfish/precis_i18n/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
