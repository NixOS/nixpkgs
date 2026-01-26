{
  lib,
  buildPythonPackage,
  fetchFromBitbucket,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "defang";
  version = "0.5.3";
  pyproject = true;

  src = fetchFromBitbucket {
    owner = "johannestaas";
    repo = "defang";
    tag = version;
    hash = "sha256-OJfayJeVf2H1/jg7/fu2NiHhRHNCaLGI29SY8BnJyxI=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "defang" ];

  meta = {
    description = "Module to defang and refang malicious URLs";
    homepage = "https://bitbucket.org/johannestaas/defang";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
