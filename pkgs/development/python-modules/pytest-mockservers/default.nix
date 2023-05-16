{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, poetry-core
, aiohttp
, pytest
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-mockservers";
  version = "0.6.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Gr1N";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-Mb3wSbambC1h+lFI+fafwZzm78IvADNAsF/Uw60DFHc=";
  };

  patches = [
    # https://github.com/Gr1N/pytest-mockservers/pull/75
    (fetchpatch {
      name = "use-poetry-core.patch";
      url = "https://github.com/Gr1N/pytest-mockservers/commit/c7731186a4e12851ab1c15ab56e652bb48ed59c4.patch";
      hash = "sha256-/5X3xjJwt2gs3t6f/6n1QZ+CTBq/5+cQE+MgNWyz+Hs=";
    })
  ];
=======
    sha256 = "0xql0fnw7m2zn103601gqbpyd761kzvgjj2iz9hjsv56nr4z1g9i";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    aiohttp
    pytest-asyncio
  ];

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_mockservers"
  ];

  meta = with lib; {
    description = "A set of fixtures to test your requests to HTTP/UDP servers";
    homepage = "https://github.com/Gr1N/pytest-mockservers";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
