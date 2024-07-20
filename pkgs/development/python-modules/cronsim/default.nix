{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "cronsim";
  version = "2.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cuu508";
    repo = "cronsim";
    rev = "refs/tags/${version}";
    hash = "sha256-TSVFkMCMmrMXaPJPPNjIML+z98i1iIYuKH7hHiZnJkg=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cronsim" ];

  meta = with lib; {
    description = "Cron expression parser and evaluator";
    homepage = "https://github.com/cuu508/cronsim";
    license = licenses.bsd3;
    maintainers = with maintainers; [ phaer ];
  };
}
