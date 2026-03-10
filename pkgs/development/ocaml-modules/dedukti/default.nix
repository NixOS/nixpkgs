{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  cmdliner,
  menhir,
}:

buildDunePackage (finalAttrs: {
  pname = "dedukti";
  version = "2.7";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "Deducteam";
    repo = "dedukti";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SFxbgq2znO+OCEFzuekVquvtOEuCQanseKy+iZAeWbc=";
  };

  nativeBuildInputs = [ menhir ];
  buildInputs = [ cmdliner ];

  doCheck = false; # requires `tezt`

  meta = {
    homepage = "https://deducteam.github.io";
    description = "Logical framework based on the λΠ-calculus modulo rewriting";
    license = lib.licenses.cecill-b;
    changelog = "https://github.com/Deducteam/Dedukti/raw/${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
