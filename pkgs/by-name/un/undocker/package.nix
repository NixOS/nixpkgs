{
  lib,
  buildGoModule,
  fetchgit,
  gnumake,
}:
let
  version = "1.2.3";
  src = fetchgit {
    url = "https://git.jakstys.lt/motiejus/undocker.git";
    rev = "v${version}";
    hash = "sha256-hyP85pYtXxucAliilUt9Y2qnrfPeSjeGsYEFJndJWyA=";
  };
in
buildGoModule {
  pname = "undocker";
  inherit version src;

  nativeBuildInputs = [ gnumake ];

  buildPhase = "make VSN=v${version} VSNHASH=${src.rev} undocker";

  installPhase = "install -D undocker $out/bin/undocker";

  vendorHash = null;

  meta = {
    homepage = "https://git.jakstys.lt/motiejus/undocker";
    description = "CLI tool to convert a Docker image to a flattened rootfs tarball";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jordanisaacs
      motiejus
    ];
    mainProgram = "undocker";
  };
}
