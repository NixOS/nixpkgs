{
  stdenv,
  lib,
  nodejs,
  buildNpmPackage,
  buildPythonPackage,
  runCommand,
  fetchFromGitHub,
  fetchPypi,
  flit-core,
  accessible-pygments,
  beautifulsoup4,
  pygments,
  sphinx,
  sphinx-basic-ng,
  unzip,
}:

let
  pname = "furo";
  version = "2025.07.19";
  # version on pypi doesn't have month & day padded with 0
  pypiVersion =
    let
      versionComponents = lib.strings.splitString "." version;
      dropLeadingZero = lib.strings.removePrefix "0";
    in
    # year
    (lib.lists.elemAt versionComponents 0)
    + "."
    # month
    + (dropLeadingZero (lib.lists.elemAt versionComponents 1))
    + "."
    # day
    + (dropLeadingZero (lib.lists.elemAt versionComponents 2));

  src = fetchFromGitHub {
    owner = "pradyunsg";
    repo = "furo";
    tag = version;
    hash = "sha256-pIF5zrh5YbkuSkrateEB/tDULSNbeVn2Qx+Fm3nOYGE=";
  };

  web-bin =
    let
      web-bin-src = fetchPypi {
        inherit pname;
        version = pypiVersion;
        format = "wheel";
        dist = "py3";
        python = "py3";
        hash = "sha256-veqGmCLf0rSU6oTAlzk3410Vda8Ii2chopx/eHityeM=";
      };
    in
    runCommand "${pname}-web-bin"
      {
        nativeBuildInputs = [ unzip ];
      }
      ''
        mkdir $out
        unzip ${web-bin-src}
        cp -rv furo/theme/furo/static/{scripts,styles} $out/
      '';

  web-native = buildNpmPackage {
    pname = "${pname}-web";
    inherit version src;

    npmDepsHash = "sha256-dcdHoyqF9zC/eKtEqMho7TK2E1KIvoXo0iwSPTzj+Kw=";

    installPhase = ''
      pushd src/furo/theme/furo/static
      mkdir $out
      cp -rv scripts styles $out/
      popd
    '';
  };

  web = if (lib.meta.availableOn stdenv.buildPlatform nodejs) then web-native else web-bin;
in

buildPythonPackage rec {
  inherit pname version src;
  pyproject = true;

  postPatch = ''
    # build with boring backend that does not manage a node env
    substituteInPlace pyproject.toml \
      --replace-fail "sphinx-theme-builder >= 0.2.0a10" "flit-core" \
      --replace-fail "sphinx_theme_builder" "flit_core.buildapi"

    pushd src/furo/theme/furo/static
    cp -rv ${web}/{scripts,styles} .
    popd
  '';

  build-system = [ flit-core ];

  pythonRelaxDeps = [ "sphinx" ];

  dependencies = [
    accessible-pygments
    beautifulsoup4
    pygments
    sphinx
    sphinx-basic-ng
  ];

  pythonImportsCheck = [ "furo" ];

  passthru = {
    inherit web;
  };

  meta = {
    description = "Clean customizable documentation theme for Sphinx";
    homepage = "https://github.com/pradyunsg/furo";
    changelog = "https://github.com/pradyunsg/furo/blob/${version}/docs/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
