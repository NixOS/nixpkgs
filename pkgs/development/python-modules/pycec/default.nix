{ lib
, buildPythonPackage
, fetchFromGitHub
, libcec
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pycec";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "konikvranik";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ivnmihajhfkwwghgl0f8n9ragpirbmbj1mhj9bmjjc29zzdc3m6";
  };

  propagatedBuildInputs = [
    libcec
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pycec" ];

  meta = with lib; {
    description = "Python modules to access HDMI CEC devices";
    homepage = "https://github.com/konikvranik/pycec/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
