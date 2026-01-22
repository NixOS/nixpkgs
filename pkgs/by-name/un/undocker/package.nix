{
  lib,
  buildGoModule,
  fetchFromGitea,
  gnumake,
}:
let
  version = "1.2.3";
  hash = "sha256-hyP85pYtXxucAliilUt9Y2qnrfPeSjeGsYEFJndJWyA=";
  src = fetchFromGitea {
    domain = "git.jakstys.lt";
    owner = "motiejus";
    repo = "undocker";
    rev = "v${version}";
    hash = hash;
  };
in
buildGoModule {
  pname = "undocker";
  inherit version src;

  nativeBuildInputs = [ gnumake ];

  buildPhase = "make VSN=v${version} VSNHASH=${hash} undocker";

  installPhase = "runHook preInstall; install -D undocker $out/bin/undocker; runHook postInstall";

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
