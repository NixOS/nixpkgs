{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "awesomeversion";
  version = "22.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    sha256 = "sha256-FlJrk/PH3nBLakQfS+ruDwAPH/oo16JcfrtVRFgbUXY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
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
