{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "awesomeversion";
  version = "23.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    hash = "sha256-3bHE3U4MM/fQM9zBYfoLpAObay82vchjX9FpJukMGNg=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # Upstream doesn't set a version
    substituteInPlace pyproject.toml \
      --replace 'version = "0"' 'version = "${version}"'
  '';

  pythonImportsCheck = [
    "awesomeversion"
  ];

  meta = with lib; {
    description = "Python module to deal with versions";
    homepage = "https://github.com/ludeeus/awesomeversion";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
