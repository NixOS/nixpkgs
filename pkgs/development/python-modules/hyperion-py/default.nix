{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, pythonOlder
, pythonAtLeast
, poetry-core
, pytest-aiohttp
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "hyperion-py";
  version = "0.7.5";
  disabled = pythonOlder "3.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dermotduffy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-arcnpCQsRuiWCrAz/t4TCjTe8DRDtRuzYp8k7nnjGDk=";
  };

  patches = [
    (fetchpatch {
      # python3.10 compat: Drop loop kwarg in asyncio.sleep call
      url = "https://github.com/dermotduffy/hyperion-py/commit/f02af52fcce17888984c99bfc03935e372011394.patch";
      hash = "sha256-4nfsQVxd77VV9INwNxTyFRDlAjwdTYqfSGuF487hFCs=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-aiohttp
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # pytest-asyncio 0.17.0 compat
    "--asyncio-mode=auto"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --timeout=9 --cov=hyperion" ""
  '';

  pythonImportsCheck = [ "hyperion" ];

  meta = with lib; {
    description = "Python package for Hyperion Ambient Lighting";
    homepage = "https://github.com/dermotduffy/hyperion-py";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
