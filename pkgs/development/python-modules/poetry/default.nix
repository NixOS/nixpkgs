{ lib, buildPythonPackage, fetchPypi, callPackage
, isPy27, isPy34
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
, pytest
}:

let
  cleo6 = cleo.overrideAttrs (oldAttrs: rec {
    version = "0.6.8";
    src = fetchPypi {
      inherit (oldAttrs) pname;
      inherit version;
      sha256 = "06zp695hq835rkaq6irr1ds1dp2qfzyf32v60vxpd8rcnxv319l5";
    };
  });

  jsonschema3 = callPackage ./jsonschema.nix { };
  glob2 = callPackage ./glob2.nix { };

in buildPythonPackage rec {
  pname = "poetry";
  version = "0.12.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gxwcd65qjmzqzppf53x51sic1rbcd9py6cdzx3aprppipimslvf";
  };

  postPatch = ''
    substituteInPlace setup.py --replace \
      "requests-toolbelt>=0.8.0,<0.9.0" \
      "requests-toolbelt>=0.8.0,<0.10.0" \
      --replace 'pyrsistent>=0.14.2,<0.15.0' 'pyrsistent>=0.14.2,<0.16.0'
  '';

  format = "pyproject";

  propagatedBuildInputs = [
    cleo6
    requests
    cachy
    requests-toolbelt
    jsonschema3
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

  # No tests in Pypi tarball
  doCheck = false;
  checkInputs = [ pytest ];
  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    homepage = https://github.com/sdispater/poetry;
    description = "Python dependency management and packaging made easy";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
