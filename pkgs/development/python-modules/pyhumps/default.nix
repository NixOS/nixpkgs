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
  version = "3.7.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nficano";
    repo = "humps";
    rev = "v${version}";
    hash = "sha256-nxiNYBpbX2GfzYj+DdU89bsyEHDnrKZIAGZY7ut/P6I=";
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
      url = "https://github.com/nficano/humps/commit/8c7de2040e3610760c4df604cdbe849a9b7f0074.patch";
      sha256 = "sha256-dNgPAOxPdCwDteobP4G2/GiVj/Xg+m7u/Or92vo8ilk=";
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
