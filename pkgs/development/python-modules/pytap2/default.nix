{ lib
, buildPythonPackage
, nettools
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytap2";
  version = "2.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "johnthagen";
    repo = "pytap2";
    rev = "v${version}";
    hash = "sha256-/t0Seg+8ZrOWOHBu9ftE1xkrnDeoYdHopXBvJTMGYRI=";
  };

  propagatedBuildInputs = [
    nettools
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytap2"
  ];

  meta = with lib; {
    description = "Object-oriented wrapper around the Linux Tun/Tap device";
    homepage = "https://github.com/johnthagen/pytap2";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
