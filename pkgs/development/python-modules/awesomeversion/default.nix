{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  pytest-codspeed,
  pytest-snapshot,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "awesomeversion";
  version = "25.8.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = "awesomeversion";
    tag = version;
    hash = "sha256-2CEuJagUkYwtjzpQLYLlz+V5e2feEU6di3wI0+uWuy4=";
  };

  postPatch = ''
    # Upstream doesn't set a version
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0"' 'version = "${version}"'
  '';

  nativeBuildInputs = [ hatchling ];

  pythonImportsCheck = [ "awesomeversion" ];

  nativeCheckInputs = [
    pytest-codspeed
    pytest-snapshot
    pytestCheckHook
  ];

<<<<<<< HEAD
  meta = {
    description = "Python module to deal with versions";
    homepage = "https://github.com/ludeeus/awesomeversion";
    changelog = "https://github.com/ludeeus/awesomeversion/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python module to deal with versions";
    homepage = "https://github.com/ludeeus/awesomeversion";
    changelog = "https://github.com/ludeeus/awesomeversion/releases/tag/${src.tag}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
