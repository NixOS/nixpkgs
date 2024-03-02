{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, numpy
, pytestCheckHook
, pythonOlder
, rdkit
, scipy
}:

buildPythonPackage rec {
  pname = "meeko";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "forlilab";
    repo = "Meeko";
    rev = "refs/tags/v${version}";
    hash = "sha256-pngFu6M63W26P7wd6FUNLuf0NikxtRtVR/pnR5PR6Wo=";
  };

  patches = [
    # https://github.com/forlilab/Meeko/issues/60
    (fetchpatch {
      name = "fix-unknown-sidechains.patch";
      url = "https://github.com/forlilab/Meeko/commit/28c9fbfe3b778aa1bd5e8d7e4f3e6edf44633a0c.patch";
      hash = "sha256-EJbLnbKTTOsTxKtLiU7Af07yjfY63ungGUHbGvrm0AU=";
    })
    (fetchpatch {
      name = "add-test-data.patch";
      url = "https://github.com/forlilab/Meeko/commit/57b52e3afffb82685cdd1ef1bf6820d55924b97a.patch";
      hash = "sha256-nLnyIjT68iaY3lAEbH9EJ5jZflhxABBwDqw8kaRKf3k=";
    })
  ];

  propagatedBuildInputs = [
    # setup.py only requires numpy but others are needed at runtime
    numpy
    rdkit
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "meeko"
  ];

  meta = {
    description = "Python package for preparing small molecule for docking";
    homepage = "https://github.com/forlilab/Meeko";
    changelog = "https://github.com/forlilab/Meeko/releases/tag/${src.rev}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
