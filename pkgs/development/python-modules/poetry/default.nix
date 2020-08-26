{ lib, buildPythonPackage, fetchFromGitHub, isPy27, pythonOlder
, cachecontrol
, cachy
, cleo
, clikit
, html5lib
, httpretty
, importlib-metadata
, intreehooks
, jsonschema
, keyring
, lockfile
, pexpect
, pkginfo
, pygments
, pyparsing
, pyrsistent
, pytestCheckHook
, pytestcov
, pytest-mock
, requests
, requests-toolbelt
, shellingham
, tomlkit
}:

buildPythonPackage rec {
  pname = "poetry";
  version = "1.0.10";
  format = "pyproject";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = version;
    sha256 = "00qfzjjs6clh93gfl1px3ma9km8qxl3f4z819nmyl58zc8ni3zyv";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
     --replace "pyrsistent = \"^0.14.2\"" "pyrsistent = \"^0.16.0\"" \
     --replace "requests-toolbelt = \"^0.8.0\"" "requests-toolbelt = \"^0.9.1\"" \
     --replace 'importlib-metadata = {version = "~1.1.3", python = "<3.8"}' \
       'importlib-metadata = {version = ">=1.3,<2", python = "<3.8"}' \
     --replace "tomlkit = \"^0.5.11\"" "tomlkit = \"^0.6.0\"" \
     --replace "cleo = \"^0.7.6\"" "cleo = \"^0.8.0\"" \
     --replace "version = \"^20.0.1\", python = \"^3.5\"" "version = \"^21.0.0\", python = \"^3.5\"" \
     --replace "clikit = \"^0.4.2\"" "clikit = \"^0.6.2\""
  '';

  nativeBuildInputs = [ intreehooks ];

  propagatedBuildInputs = [
    cachecontrol
    cachy
    cleo
    clikit
    html5lib
    jsonschema
    keyring
    lockfile
    pexpect
    pkginfo
    pyparsing
    pyrsistent
    requests
    requests-toolbelt
    shellingham
    tomlkit
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  postInstall = ''
    mkdir -p "$out/share/bash-completion/completions"
    "$out/bin/poetry" completions bash > "$out/share/bash-completion/completions/poetry"
    mkdir -p "$out/share/zsh/vendor-completions"
    "$out/bin/poetry" completions zsh > "$out/share/zsh/vendor-completions/_poetry"
    mkdir -p "$out/share/fish/vendor_completions.d"
    "$out/bin/poetry" completions fish > "$out/share/fish/vendor_completions.d/poetry.fish"
  '';

  checkInputs = [ pytestCheckHook httpretty pytest-mock pygments pytestcov ];
  preCheck = "export HOME=$TMPDIR";
  disabledTests = [
    # touches network
    "git"
    "solver"
    "load"
    "vcs"
    "prereleases_if_they_are_compatible"
    # requires git history to work correctly
    "default_with_excluded_data"
  ];

  meta = with lib; {
    homepage = "https://python-poetry.org/";
    description = "Python dependency management and packaging made easy";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
