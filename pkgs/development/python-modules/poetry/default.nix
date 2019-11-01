{ lib, buildPythonPackage, fetchPypi, fetchFromGitHub, callPackage
, isPy27, isPy34
, cachecontrol
, cachy
, cleo
, functools32
, glob2
, html5lib
, httpretty
, jsonschema
, lockfile
, pathlib2
, pkginfo
, pyparsing
, pyrsistent
, pytest
, pytest-mock
, requests
, requests-toolbelt
, shellingham
, subprocess32
, tomlkit
, typing
, virtualenv
}:

let
  cleo6 = cleo.overridePythonAttrs (oldAttrs: rec {
    version = "0.6.8";
    src = fetchPypi {
      inherit (oldAttrs) pname;
      inherit version;
      sha256 = "06zp695hq835rkaq6irr1ds1dp2qfzyf32v60vxpd8rcnxv319l5";
    };
  });

  # used for tests, can't be used directly for install because
  # it's missing a setup.py
  githubSrc = fetchFromGitHub {
    owner = "sdispater";
    repo = "poetry";
    rev = version;
    sha256 = "004s747wkil5f00r0vjff73r6vhlrrcnfan2k7pl7gyf62wfp02a";
  };

  version = "0.12.17";
in buildPythonPackage rec {
  pname = "poetry";
  inherit version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gxwcd65qjmzqzppf53x51sic1rbcd9py6cdzx3aprppipimslvf";
  };

  postPatch = ''
    substituteInPlace setup.py --replace \
      "requests-toolbelt>=0.8.0,<0.9.0" \
      "requests-toolbelt>=0.8.0,<0.10.0" \
      --replace 'pyrsistent>=0.14.2,<0.15.0' 'pyrsistent>=0.14.2,<0.16.0' \
      --replace 'glob2>=0.6,<0.7' 'glob2' \
      --replace 'cachy<0.3,>=0.2' 'cachy'
  '';

  propagatedBuildInputs = [
    cachy
    cleo6
    requests
    cachy
    requests-toolbelt
    lockfile
    jsonschema
    pyrsistent
    pyparsing
    cachecontrol
    pkginfo
    html5lib
    shellingham
    tomlkit
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

  # copy the tests to a directory where we have write permissions
  # only do tests on test suites which are pure
  checkInputs = [ pytest httpretty pytest-mock ];
  checkPhase = ''
    cp -r ${githubSrc}/tests ./tests
    HOME=$TMPDIR pytest tests/{mixology,packages,repositories,semver}
  '';

  meta = with lib; {
    homepage = https://github.com/sdispater/poetry;
    description = "Python dependency management and packaging made easy";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
