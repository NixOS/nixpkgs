{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, aiohttp
, beautifulsoup4
, importlib-metadata
, multidict
, poetry
, pytest-asyncio
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, typer
, yarl
}:

buildPythonPackage rec {
  pname = "authcaptureproxy";
  version = "0.4.2";
  format = "pyproject";

  # Fetch from Github because PyPI distribution does not include tests
  src = fetchFromGitHub {
    owner = "alandtse";
    repo = "auth_capture_proxy";
    rev = "v${version}";
    sha256 = "1r22k5h35nrqcg128z2jyfa7shkf873d3l813fzfv7869c9msbs9";
  };

  disabled = !isPy3k;

  # Lower importlib-metadata requirement and remove entirely Python >= 3.8 since
  # it's built-in (and the code will use the built-in version)
  #
  # TODO: update once we have importlib-metadata >= 3.4.0 in nixpkgs
  patchPhase = if pythonAtLeast "3.8" then ''
    sed -i '/importlib-metadata/d' pyproject.toml
  '' else ''
    sed -i 's/importlib-metadata = "^3.4.0"/importlib-metadata = "^1.7.0"/' pyproject.toml
  '';

  nativeBuildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    aiohttp
    beautifulsoup4
    multidict
    typer
    yarl
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/alandtse/auth_capture_proxy";
    license = licenses.asl20;
    description = "A Python project to create a proxy to capture authentication information from a webpage.";
    maintainers = with maintainers; [ graham33 ];
  };
}
