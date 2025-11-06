{
  lib,
  buildNpmPackage,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  accessible-pygments,
  beautifulsoup4,
  pygments,
  sphinx,
  sphinx-basic-ng,
}:

let
  pname = "furo";
  version = "2025.07.19";

  src = fetchFromGitHub {
    owner = "pradyunsg";
    repo = "furo";
    tag = version;
    hash = "sha256-pIF5zrh5YbkuSkrateEB/tDULSNbeVn2Qx+Fm3nOYGE=";
  };

  web = buildNpmPackage {
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

  meta = with lib; {
    description = "Clean customizable documentation theme for Sphinx";
    homepage = "https://github.com/pradyunsg/furo";
    changelog = "https://github.com/pradyunsg/furo/blob/${version}/docs/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
