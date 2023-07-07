{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "discovery30303";
  version = "0.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    # Commit points to 0.2.1, https://github.com/bdraco/discovery30303/issues/1
    rev = "0d0b0fdca1a98662dd2e6174d25853703bd6bf07";
    hash = "sha256-WSVMhiJxASxAkxs6RGuAVvEFS8TPxDKE9M99Rp8HKGM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=discovery30303" ""
  '';

  pythonImportsCheck = [
    "discovery30303"
  ];

  meta = with lib; {
    description = "Module to discover devices that respond on port 30303";
    homepage = "https://github.com/bdraco/discovery30303";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
