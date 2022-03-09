{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyhumps";
  version = "3.5.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nficano";
    repo = "humps";
    rev = "v${version}";
    hash = "sha256-6F61y0niPPuZBci15j68MFXzzBBimvbZ24+i9AZ7XJs=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    pytestCheckHook
  ];

  patches = [
    # Fix naming, https://github.com/nficano/humps/pull/246
    (fetchpatch {
      name = "fix-naming.patch";
      url = "https://github.com/nficano/humps/commit/118f6bce785d170b10dd3afee467d26dcc8b425d.patch";
      sha256 = "sha256-oQxkLsihnHZlHiZEupwG9Dr1Ss1w+KjDsBtbEVDced4=";
    })
  ];

  pythonImportsCheck = [
    "humps"
  ];

  meta = with lib; {
    description = "Module to convert strings (and dictionary keys) between snake case, camel case and pascal case";
    homepage = "https://github.com/nficano/humps";
    license = with licenses; [ unlicense ];
    maintainers = with maintainers; [ fab ];
  };
}
