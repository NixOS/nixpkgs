{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pyparsing
, pytestCheckHook
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "pysigma";
  version = "0.3.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma";
    rev = "v${version}";
    hash = "sha256-V/E2rZqVrk0kIvk+hPhNcAifhMM/rN3mk3pB+CGd43w=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pyparsing
    pyyaml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  patches = [
    # Switch to poetry-core, https://github.com/SigmaHQ/pySigma/pull/31
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/SigmaHQ/pySigma/commit/b7a852d18852007da90c2ec35bff347c97b36f07.patch";
      sha256 = "sha256-zgg8Bsc37W2uuQluFpIZT4jHCQaitY2ZgS93Wk6Hxt0=";
    })
  ];

  postPatch = ''
    # https://github.com/SigmaHQ/pySigma/issues/32
    # https://github.com/SigmaHQ/pySigma/issues/33
    substituteInPlace pyproject.toml \
      --replace 'pyparsing = "^2.4.7"' 'pyparsing = "*"' \
      --replace 'pyyaml = "^5.3.1"' 'pyyaml = "*"'
  '';

  pythonImportsCheck = [
    "sigma"
  ];

  meta = with lib; {
    description = "Library to parse and convert Sigma rules into queries";
    homepage = "https://github.com/SigmaHQ/pySigma";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
