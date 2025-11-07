{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "allpairspy";
  version = "2.5.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "allpairspy";
    tag = "v${version}";
    hash = "sha256-0wzoQDHB7Tt80ZTlKrNxFutztsgUuin5D2eb80c4PBI=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "allpairspy" ];

  meta = with lib; {
    description = "Pairwise test combinations generator";
    homepage = "https://github.com/thombashi/allpairspy";
    changelog = "https://github.com/thombashi/allpairspy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
  };
}
