{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pythonOlder,
  requests,
  responses,
}:

buildPythonPackage rec {
  pname = "pywaterkotte";
  version = "0.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "chboland";
    repo = "pywaterkotte";
    tag = "v${version}";
    hash = "sha256-zK0x6LyXPPNPA20Zq+S1B1q7ZWGxQmWf4JxEfjNkPQw=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "pywaterkotte" ];

<<<<<<< HEAD
  meta = {
    description = "Library to communicate with Waterkotte heatpumps";
    homepage = "https://github.com/chboland/pywaterkotte";
    changelog = "https://github.com/chboland/pywaterkotte/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Library to communicate with Waterkotte heatpumps";
    homepage = "https://github.com/chboland/pywaterkotte";
    changelog = "https://github.com/chboland/pywaterkotte/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
