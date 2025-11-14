{
  lib,
  buildPythonPackage,
  buildNpmPackage,
  fetchFromGitHub,
  stdenv,
  fava,
  hatch-vcs,
  hatchling,
  numpy,
  protobuf,
  pytestCheckHook,
  scipy,
}:
let
  pname = "fava-portfolio-returns";
  version = "2.1.0";
  src = fetchFromGitHub {
    owner = "andreasgerstmayr";
    repo = "fava-portfolio-returns";
    rev = "v${version}";
    hash = "sha256-e2cOvSgya/8TE/6hIQ70jcXa8RR96/Prqf+yHjH/9to=";
  };

  frontend = buildNpmPackage (finalAttrs: {
    pname = "${pname}-frontend";
    inherit version;

    src = "${src}/frontend";

    npmDepsHash = "sha256-KG9mPzQdvRAS+xOn2q8Tq32P/PGcT2zOFo2JZ2Pr19M=";

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
    protobuf
    scipy
  ];

  preInstall = ''
    cp ${frontend}/FavaPortfolioReturns.js src/fava_portfolio_returns/
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fava_portfolio_returns" ];

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
