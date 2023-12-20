{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "propka";
  version = "3.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jensengroup";
    repo = "propka";
    rev = "refs/tags/v${version}";
    hash = "sha256-NbvrlapBALGbUyBqdqDcDG/igDf/xqxC35DzVUrbHlo=";
  };

  patches = [
    # https://github.com/jensengroup/propka/pull/171
    (fetchpatch {
      name = "python312-compatibility.patch";
      url = "https://github.com/jensengroup/propka/commit/1c8885d4003e5fd8a2921909268001b197066beb.patch";
      hash = "sha256-fB2WKVHoIgqDA/EYt7369HrIDCEJ1rmKP2tmxAdhCRs=";
    })
  ];

  propagatedBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "propka"
  ];

  meta = with lib; {
    description = "A predictor of the pKa values of ionizable groups in proteins and protein-ligand complexes based in the 3D structure";
    homepage = "https://github.com/jensengroup/propka";
    changelog = "https://github.com/jensengroup/propka/releases/tag/v${version}";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ natsukium ];
  };
}
