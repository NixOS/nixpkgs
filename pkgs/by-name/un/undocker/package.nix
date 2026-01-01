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

  installPhase = "install -D undocker $out/bin/undocker";

  vendorHash = null;

<<<<<<< HEAD
  meta = {
    homepage = "https://git.jakstys.lt/motiejus/undocker";
    description = "CLI tool to convert a Docker image to a flattened rootfs tarball";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    homepage = "https://git.jakstys.lt/motiejus/undocker";
    description = "CLI tool to convert a Docker image to a flattened rootfs tarball";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      jordanisaacs
      motiejus
    ];
    mainProgram = "undocker";
  };
}
