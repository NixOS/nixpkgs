{ lib
, buildPythonPackage
, fetchFromGitHub
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

  postPatch = ''
    # https://github.com/nficano/humps/pull/240
    substituteInPlace pyproject.toml \
      --replace 'version = "3.0.2"' 'version = "${version}"'
  '';

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
