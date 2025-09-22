{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  poetry-core,
  pytestCheckHook,
  pkgs,
}:

let
  inherit (pkgs) quickjs srcOnly;
in

buildPythonPackage rec {
  pname = "quickjs";
  version = "1.19.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PetterS";
    repo = "quickjs";
    tag = version;
    hash = "sha256-nLloXJWOuaK/enZfwXJI94IcsAMYrkBtG4i3gmxuhfw=";
  };

  patches = [ ./0001-Update-for-QuickJS-2025-04-26-release.patch ];

  # Upstream uses Git submodules; let's de-vendor and use Nix, so that we gain security fixes like
  # https://github.com/NixOS/nixpkgs/pull/407469
  prePatch = ''
    rmdir upstream-quickjs
    ln -s ${srcOnly quickjs} upstream-quickjs
  '';

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail poetry>=1.5.0 poetry \
      --replace-fail poetry poetry-core \
      --replace-fail 'version = "0"' 'version = "${version}"'
  '';

  build-system = [
    poetry-core
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "quickjs" ];

  meta = {
    description = "Python wrapper around the quickjs C library";
    homepage = "https://github.com/PetterS/quickjs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
