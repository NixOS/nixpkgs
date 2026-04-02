{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  yt-dlp,
}:

buildPythonPackage rec {
  pname = "bgutil-ytdlp-pot-provider";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Brainicism";
    repo = "bgutil-ytdlp-pot-provider";
    tag = version;
    hash = "sha256-dhpataQ1HSCRPnm4k3K/NMaQPQdNrx8C4q855l7kbbQ=";
  };

  sourceRoot = "${src.name}/plugin";

  build-system = [ hatchling ];

  dependencies = [ yt-dlp ];

  doCheck = false; # no tests

  meta = {
    description = "Proof-of-origin token provider plugin for yt-dlp";
    homepage = "https://github.com/Brainicism/bgutil-ytdlp-pot-provider";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
