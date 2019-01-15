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

in buildPythonPackage rec {
  pname = "poetry";
  version = "0.12.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00npb0jlimnk4r01zkhfmns4843j1hfhd388s326da5pd8n0dq7l";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace "3.0a3" "3.0.0a3"
    substituteInPlace setup.py --replace "3.0a3" "3.0.0a3"
  '';

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
  ] ++ lib.optionals (isPy27 || isPy34) [ typing pathlib2 ]
    ++ lib.optionals isPy27 [ virtualenv functools32 ];

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
