{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fonttools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "arabic-reshaper";
  version = "3.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mpcabd";
    repo = "python-arabic-reshaper";
    tag = "v${version}";
    hash = "sha256-ucSC5aTvpnlAVQcT0afVecnoN3hIZKtzUhEQ6Qg0jQM=";
  };

  optional-dependencies = {
    with-fonttools = [ fonttools ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "arabic_reshaper" ];

  meta = {
    description = "Reconstruct Arabic sentences to be used in applications that don't support Arabic";
    homepage = "https://github.com/mpcabd/python-arabic-reshaper";
    changelog = "https://github.com/mpcabd/python-arabic-reshaper/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
  };
}
