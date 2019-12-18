{ lib, buildPythonPackage, fetchPypi, callPackage
, isPy27, isPy34
, cleo
, requests
, cachy
, requests-toolbelt
, pyrsistent
, pyparsing
, cachecontrol
, lockfile
, pkginfo
, html5lib
, shellingham
, subprocess32
, tomlkit
, typing
, pathlib2
, virtualenv
, functools32
, pytest
, jsonschema
, intreehooks
, keyring
, pexpect
}:

let
  glob2 = callPackage ./glob2.nix { };

in buildPythonPackage rec {
  pname = "poetry";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gzifln8mns4cr43gc1gacbhzr83wpdwfaz65am4i9vi0f8k0agm";
  };

  patchPhase = ''
    substituteInPlace pyproject.toml \
      --replace 'requests-toolbelt = "^0.8.0"' 'requests-toolbelt = ">=0.8.0"' \
      --replace 'pyrsistent = "^0.14.2"' 'pyrsistent = ">=0.14.2"'
  '';

  format = "pyproject";

  propagatedBuildInputs = [
    cachy
    cleo
    requests
    cachy
    requests-toolbelt
    jsonschema
    pyrsistent
    pyparsing
    cachecontrol
    lockfile
    pkginfo
    html5lib
    shellingham
    tomlkit
    intreehooks
    keyring
    pexpect
  ] ++ lib.optionals (isPy27 || isPy34) [ typing pathlib2 glob2 ]
    ++ lib.optionals isPy27 [ virtualenv functools32 subprocess32 ];

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
    homepage = https://github.com/python-poetry/poetry;
    description = "Python dependency management and packaging made easy";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
