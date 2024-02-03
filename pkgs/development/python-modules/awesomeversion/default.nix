{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, poetry-core

# tests
, pytest-snapshot
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "awesomeversion";
  version = "23.11.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-glnM32ha5eXVpoaDkEsbwdH1oiG9qMxFwbtqLx+Kl98=";
  };

  postPatch = ''
    # Upstream doesn't set a version
    substituteInPlace pyproject.toml \
      --replace 'version = "0"' 'version = "${version}"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  pythonImportsCheck = [
    "awesomeversion"
  ];

  nativeCheckInputs = [
    pytest-snapshot
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python module to deal with versions";
    homepage = "https://github.com/ludeeus/awesomeversion";
    changelog = "https://github.com/ludeeus/awesomeversion/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
