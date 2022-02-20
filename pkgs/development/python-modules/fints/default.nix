{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, bleach
, mt-940
, requests
, sepaxml
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  version = "3.0.1";
  pname = "fints";

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "python-fints";
    rev = "v${version}";
    sha256 = "sha256-P9+3QuB5c7WMjic2fSp8pwXrOUHIrLThvfodtbBXLMY=";
  };

  patches = [
    (fetchpatch {
      name = "py310-compat.patch";
      url = "https://github.com/raphaelm/python-fints/commit/901805f1c0a0a4785db0abba7ff770fb97e095a2.patch";
      hash = "sha256-v5vzYyKMoNu6LrU8WNOSEJiLKEmUYD3giz/wiF/xReo=";
    })
  ];

  propagatedBuildInputs = [ requests mt-940 sepaxml bleach ];

  checkInputs = [ pytestCheckHook pytest-mock ];

  meta = with lib; {
    homepage = "https://github.com/raphaelm/python-fints/";
    description = "Pure-python FinTS (formerly known as HBCI) implementation";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ elohmeier dotlambda ];
  };
}
