{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  wrapt,
}:

buildPythonPackage rec {
  pname = "aiounittest";
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kwarunek";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-7lDOI1SHPpRZLTHRTmfbKlZH18T73poJdFyVmb+HKms=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ wrapt ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aiounittest" ];

  meta = with lib; {
    description = "Test asyncio code more easily";
    homepage = "https://github.com/kwarunek/aiounittest";
    license = licenses.mit;
    maintainers = [ ];
  };
}
