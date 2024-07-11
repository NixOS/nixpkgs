{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "lcgit";
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cisagov";
    repo = "lcgit";
    rev = "refs/tags/v${version}";
    hash = "sha256-bLeblC68+j+YwvgnV1wgJiWm/jxZFzhTSDwXpoSzUTg=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace " --cov" ""
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "lcgit" ];

  meta = with lib; {
    description = "Pythonic Linear Congruential Generator iterator";
    homepage = "https://github.com/cisagov/lcgit";
    changelog = "https://github.com/cisagov/lcgit/releases/tag/v${version}";
    license = licenses.cc0;
    maintainers = with maintainers; [ fab ];
  };
}
