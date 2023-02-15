{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "patchy";
  version = "2.6.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = pname;
    rev = version;
    hash = "sha256-fQ4nOLpZ0XKN3W1PyhtoCgaSEiTVzrxCvYEoreZEtcQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = true;

  meta = with lib; {
    description = "Patch the inner source of python functions at runtime.";
    homepage = "https://github.com/adamchainz/patchy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ qbit ];
  };
}
