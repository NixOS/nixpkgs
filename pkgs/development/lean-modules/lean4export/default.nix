{
  lib,
  fetchFromGitHub,
  buildLakePackage,
}:

buildLakePackage (finalAttrs: {
  version = "4.35.0";
  pname = "lean4export";

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean4export";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LysjGOikBaaOdZdwxA+RwzfnQweTaU3kpFuWc6LxmXc=";
  };

  # force Export.Parse target for lean4lean
  buildTargets = [
    "lean4export"
    "Export.Parse:c.o.export"
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    lake test

    runHook postCheck
  '';

  meta = with lib; {
    description = "Plain-text declaration export for Lean 4";
    homepage = "https://github.com/leanprover/lean4export";
    license = licenses.asl20;
    mainProgram = "lean4export";
    maintainers = with maintainers; [ stephen-huan ];
  };
})
