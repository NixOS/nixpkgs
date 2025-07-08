{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "theia";
  version = "1.63.2";

  src = fetchFromGitHub {
    owner = "eclipse-theia";
    repo = "theia";
    tag = "v${version}";
    hash = "sha256-XMI+QsxXdrNSU+zJe+lOfYGkTimYiUJszYVE/sKfVHk=";
  };

  meta = {
    description = "Eclipse Theia is a cloud & desktop IDE framework implemented in TypeScript";
    homepage = "https://github.com/eclipse-theia/theia";
    changelog = "https://github.com/eclipse-theia/theia/blob/${src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      gpl2Only
      epl20
    ];
    maintainers = with lib.maintainers; [ ];
    mainProgram = "theia";
    platforms = lib.platforms.all;
  };
}
