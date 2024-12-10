{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "august";
  version = "unstable-2023-08-13";

  src = fetchFromGitHub {
    owner = "yoav-lavi";
    repo = "august";
    rev = "42b8a1bf5ca079aca1769d92315f70b193a9cd4a";
    hash = "sha256-58DZMoRH9PBbM4sok/XbUcwSXBeqUAmFZpffdMKQ+dE=";
  };

  cargoHash = "sha256-/GvBbsSL0dZ0xTystIpb8sk1nNg5hmP4yceCHlh7EQE=";

  postInstall = ''
    mv $out/bin/{august-cli,ag}
  '';

  meta = with lib; {
    description = "An Emmet-like language that produces JSON, TOML, or YAML";
    homepage = "https://github.com/yoav-lavi/august";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "ag";
  };
}
