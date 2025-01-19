{
  lib,
  python3Packages,
  fetchFromGitLab,
  vkbasalt,
}:

python3Packages.buildPythonApplication rec {
  pname = "vkbasalt-cli";
  version = "3.1.1";

  src = fetchFromGitLab {
    owner = "TheEvilSkeleton";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4MFqndnvwAsqyer9kMNuCZFP/Xdl7W//AyCe7n83328=";
  };

  postPatch = ''
    substituteInPlace vkbasalt/lib.py \
      --replace /usr ${vkbasalt}
  '';

  pythonImportsCheck = [ "vkbasalt.lib" ];

  meta = {
    description = "Command-line utility for vkBasalt";
    homepage = "https://gitlab.com/TheEvilSkeleton/vkbasalt-cli";
    license = with lib.licenses; [
      lgpl3Only
      gpl3Only
    ];
    maintainers = [ ];
    mainProgram = "vkbasalt";
  };
}
