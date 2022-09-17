{ lib
, fetchFromGitHub
, buildDunePackage
, cmdliner_1_1
, menhir
}:

buildDunePackage rec {
  pname = "dedukti";
  version = "2.7";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "Deducteam";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SFxbgq2znO+OCEFzuekVquvtOEuCQanseKy+iZAeWbc=";
  };

  nativeBuildInputs = [ menhir ];
  buildInputs = [ cmdliner_1_1 ];

  doCheck = false;  # requires `tezt`

  meta = with lib; {
    homepage = "https://deducteam.github.io";
    description = "Logical framework based on the λΠ-calculus modulo rewriting";
    license = licenses.cecill-b;
    changelog = "https://github.com/Deducteam/Dedukti/raw/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ bcdarwin ];
  };
}
