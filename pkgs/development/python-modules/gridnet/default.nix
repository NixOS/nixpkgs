{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, aiohttp
, yarl
, aresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "gridnet";
<<<<<<< HEAD
  version = "4.3.0";
=======
  version = "4.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.9";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-gridnet";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-8R8vPVL1Iq0NneN8G2bjUOrEq96LW9Zk5RcWG/LSJTY=";
=======
    hash = "sha256-Enld68P9Cyq9Au4bsZQqPV26TL72pcmIm/Vg1DnheLk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}" \
      --replace "--cov" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gridnet" ];

  meta = with lib; {
    description = "Asynchronous Python client for NET2GRID devices";
    homepage = "https://github.com/klaasnicolaas/python-gridnet";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
