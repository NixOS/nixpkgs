{ lib
, buildPythonPackage
, fetchFromGitHub
, fonttools
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "arabic-reshaper";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mpcabd";
    repo = "python-arabic-reshaper";
    rev = "refs/tags/v${version}";
    hash = "sha256-ucSC5aTvpnlAVQcT0afVecnoN3hIZKtzUhEQ6Qg0jQM=";
  };

  passthru.optional-dependencies = {
    with-fonttools = [
      fonttools
    ];
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "arabic_reshaper"
  ];

  meta = with lib; {
    description = "Reconstruct Arabic sentences to be used in applications that don't support Arabic";
    homepage = "https://github.com/mpcabd/python-arabic-reshaper";
    changelog = "https://github.com/mpcabd/python-arabic-reshaper/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ freezeboy ];
  };
}
