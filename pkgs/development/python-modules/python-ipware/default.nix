{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  unittestCheckHook,
  setuptools,
}:
buildPythonPackage rec {
  pname = "python-ipware";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "un33k";
    repo = "python-ipware";
    rev = "v${version}";
    hash = "sha256-j43uAcb1dyKe/SHQLLR+QJS6hKGB5qxjb9NiJaUPj8Y=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "python_ipware" ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    description = "Python package for server applications to retrieve client's IP address";
    homepage = "https://github.com/un33k/python-ipware";
    changelog = "https://github.com/un33k/python-ipware/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ e1mo ];
  };
}
