{ lib, buildPythonPackage, fetchPypi, callPackage
, isPy27, isPy34, pythonOlder
, cleo
, requests
, cachy
, requests-toolbelt
, pyrsistent
, pyparsing
, cachecontrol
, pkginfo
, html5lib
, shellingham
, subprocess32
, tomlkit
, typing
, pathlib2
, virtualenv
, functools32
, clikit
, keyring
, pexpect
, importlib-metadata
, pytest
, jsonschema
, intreehooks
, lockfile
}:

let
  glob2 = callPackage ./glob2.nix { };

in buildPythonPackage rec {
  pname = "poetry";
  version = "1.0.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fx1ilgkrsqjjnpgv5zljsp0wpcsywdqvvi8im9z396qq6qpk830";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
     --replace "pyrsistent = \"^0.14.2\"" "pyrsistent = \"^0.15.0\"" \
     --replace "requests-toolbelt = \"^0.8.0\"" "requests-toolbelt = \"^0.9.0\"" \
     --replace 'importlib-metadata = {version = "~1.1.3", python = "<3.8"}' \
       'importlib-metadata = {version = ">=1.3,<2", python = "<3.8"}'
  '';

  nativeBuildInputs = [ intreehooks ];

  propagatedBuildInputs = [
    cleo
    clikit
    requests
    cachy
    requests-toolbelt
    jsonschema
    pyrsistent
    pyparsing
    cachecontrol
    pkginfo
    html5lib
    shellingham
    tomlkit
    pexpect
    keyring
    lockfile
  ] ++ lib.optionals (isPy27 || isPy34) [ typing pathlib2 glob2 ]
    ++ lib.optionals isPy27 [ virtualenv functools32 subprocess32 ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  postInstall = ''
    mkdir -p "$out/share/bash-completion/completions"
    "$out/bin/poetry" completions bash > "$out/share/bash-completion/completions/poetry"
    mkdir -p "$out/share/zsh/vendor-completions"
    "$out/bin/poetry" completions zsh > "$out/share/zsh/vendor-completions/_poetry"
    mkdir -p "$out/share/fish/vendor_completions.d"
    "$out/bin/poetry" completions fish > "$out/share/fish/vendor_completions.d/poetry.fish"
  '';

  # No tests in Pypi tarball
  doCheck = false;
  checkInputs = [ pytest ];
  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    homepage = "https://python-poetry.org/";
    description = "Python dependency management and packaging made easy";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
