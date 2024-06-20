{
  lib,
  buildPythonPackage,
  fetchFromBitbucket,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "defang";
  version = "0.5.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromBitbucket {
    owner = "johannestaas";
    repo = "defang";
    rev = "refs/tags/${version}";
    hash = "sha256-OJfayJeVf2H1/jg7/fu2NiHhRHNCaLGI29SY8BnJyxI=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "defang" ];

  meta = with lib; {
    description = "Module to defang and refang malicious URLs";
    homepage = "https://bitbucket.org/johannestaas/defang";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
