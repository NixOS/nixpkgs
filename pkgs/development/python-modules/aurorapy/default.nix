{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pyserial,
  pytestCheckHook,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "aurorapy";
  version = "0.2.7";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "energievalsabbia";
    repo = "aurorapy";
    rev = version;
    hash = "sha256-rGwfGq3zdoG9NCGqVN29Q4bWApk5B6CRdsW9ctWgOec=";
  };

  postPatch = ''
    sed -i "/from past.builtins import map/d" aurorapy/client.py
  '';

  build-system = [ setuptools ];

  pythonRemoveDeps = [ "future" ];

  dependencies = [ pyserial ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  pythonImportsCheck = [ "aurorapy" ];

  meta = with lib; {
    description = "Implementation of the communication protocol for Power-One Aurora inverters";
    homepage = "https://gitlab.com/energievalsabbia/aurorapy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
