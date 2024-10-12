{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  dnspython,
  pytestCheckHook,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "localzone";
  version = "0.9.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ags-slc";
    repo = "localzone";
    rev = "refs/tags/v${version}";
    hash = "sha256-quAo5w4Oxu9Hu96inu3vuiQ9GZMLpq0M8Vj67IPYcbE=";
  };

  build-system = [ setuptools ];

  dependencies = [ dnspython ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "localzone" ];

  meta = with lib; {
    description = "Simple DNS library for managing zone files";
    homepage = "https://localzone.iomaestro.com";
    changelog = "https://github.com/ags-slc/localzone/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ flyfloh ];
  };
}
