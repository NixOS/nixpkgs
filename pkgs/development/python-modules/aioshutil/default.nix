{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "aioshutil";
  version = "1.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kumaraditya303";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XIGjiLjoyS/7vUDIyBPvHNMyHOBa0gsg/c/vGgrhZAg=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov aioshutil --cov-report xml" ""
  '';

  pythonImportsCheck = [
    "aioshutil"
  ];

  meta = with lib; {
    description = "Asynchronous version of function of shutil module";
    homepage = "https://github.com/kumaraditya303/aioshutil";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
