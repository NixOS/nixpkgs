{
  lib,
  buildPythonPackage,
  buildNpmPackage,
  fetchFromGitHub,
  fava,
  hatch-vcs,
  hatchling,
  numpy,
  pandas,
  protobuf,
  pytestCheckHook,
  scipy,
}:
let
  pname = "fava-portfolio-returns";
  version = "2.3.0";
  src = fetchFromGitHub {
    owner = "andreasgerstmayr";
    repo = "fava-portfolio-returns";
    rev = "v${version}";
    hash = "sha256-NM+0gcgSztcgzYj0nCe9DOK90lrzE0TOzH30WvTKsUA=";
  };

  frontend = buildNpmPackage (finalAttrs: {
    pname = "${pname}-frontend";
    inherit version;

    src = "${src}/frontend";

    npmDepsHash = "sha256-MDoZC5IAR9puWMLBhLb5HRoagBPyNiyJ+0879ljCNUo=";

    postPatch = ''
      substituteInPlace package.json \
        --replace-fail '"name": "fava-portfolio-returns",' '"name": "fava-portfolio-returns", "version": "${finalAttrs.version}",'
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp ../src/fava_portfolio_returns/FavaPortfolioReturns.js $out/

      runHook postInstall
    '';
  });
in
buildPythonPackage {
  inherit pname version src;
  pyproject = true;

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    fava
    numpy
    pandas
    protobuf
    scipy
  ];

  preInstall = ''
    cp ${frontend}/FavaPortfolioReturns.js src/fava_portfolio_returns/
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fava_portfolio_returns" ];

  # Use importlib import mode to avoid `PYTHONPATH` issues related to `pytestCheckHook` ([1])
  # [1]: https://github.com/NixOS/nixpkgs/issues/255262
  pytestFlags = [
    "--import-mode=importlib"
  ];

  passthru = {
    inherit frontend;
  };

  meta = {
    description = "Show portfolio returns in Fava";
    homepage = "https://github.com/andreasgerstmayr/fava-portfolio-returns";
    changelog = "https://github.com/andreasgerstmayr/fava-portfolio-returns/blob/main/CHANGELOG.md";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
