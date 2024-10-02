{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  mkpasswd,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "userborn";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "nikstur";
    repo = "userborn";
    rev = version;
    hash = "sha256-LEKdgmw1inBOi0sriG8laCrtx0ycqR5ftdnmszadx3U=";
  };

  sourceRoot = "${src.name}/rust/userborn";

  cargoHash = "sha256-Pjzu6db2WomNsC+jNK1fr1u7koZwUvWPIY5JHMo1gkA=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildInputs = [ mkpasswd ];

  nativeCheckInputs = [ mkpasswd ];

  postInstall = ''
    wrapProgram $out/bin/userborn --prefix PATH : ${lib.makeBinPath [ mkpasswd ]}
  '';

  stripAllList = [ "bin" ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests)
        userborn
        userborn-mutable-users
        userborn-mutable-etc
        userborn-immutable-users
        userborn-immutable-etc
        ;
    };
  };

  meta = with lib; {
    homepage = "https://github.com/nikstur/userborn";
    description = "Declaratively bear (manage) Linux users and groups";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ nikstur ];
    mainProgram = "userborn";
  };
}
