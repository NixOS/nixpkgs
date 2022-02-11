{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, poetry-core
, pytest-aiohttp
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "hyperion-py";
  version = "0.7.4";
  disabled = pythonOlder "3.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dermotduffy";
    repo = pname;
    rev = "v${version}";
    sha256 = "00x12ppmvlxs3qbdxq06wnzakvwm2m39qhmpp27qfpl137b0qqyj";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
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
