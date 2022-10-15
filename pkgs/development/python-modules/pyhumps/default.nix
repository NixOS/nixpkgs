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
  version = "3.7.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nficano";
    repo = "humps";
    rev = "v${version}";
    hash = "sha256-7jkwf4qGQ+AD4/hOrEe/oAPY+gnSySUVBWFf70rU7xc=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/nficano/humps/pull/281
      url = "https://github.com/nficano/humps/commit/e248c26195804fa04c43e88c5682528f367e27b3.patch";
      hash = "sha256-+TCVfuMgfkDaS1tPu4q6PIOC3Kn1MBWyuoyAO6W0/h4=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    pytestCheckHook
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
