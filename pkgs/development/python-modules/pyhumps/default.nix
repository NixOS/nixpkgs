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
  version = "3.7.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nficano";
    repo = "humps";
    rev = "v${version}";
    hash = "sha256-MxynGgl0bgRUNPdyGqtEpIo1OFEKsSfXFiG4lAL0aPQ=";
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
      url = "https://github.com/nficano/humps/commit/04739529247ec6c6715a0242a209863d8c66a24d.patch";
      sha256 = "sha256-6nCKO8BHSPXuT5pE/T/6Dsb6qKVdtRV22Ijbbgtm6ao=";
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
