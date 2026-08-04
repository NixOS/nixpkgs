{
  lib,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "traggo";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "traggo";
    repo = "server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TMYTlcimcT1bg0frxCHDVbtrF3nbJKpqOiBfdrzjtNc=";
  };

  # The default `go mod vendor` step loads packages, which fails because
  # generated/gql* doesn't exist until gqlgen has run. proxyVendor only
  # reads go.mod/go.sum, so it doesn't have that problem.
  proxyVendor = true;
  vendorHash = "sha256-3R8GXr1AoaU7QE3/hQ+VLGoXEmfIs5CkraVqo9Numt0=";

  nativeBuildInputs = [ (callPackage ./gqlgen.nix { }) ];

  preBuild = ''
    mkdir -p ui/build
    cp -r ${finalAttrs.passthru.ui}/. ui/build/

    # gqlgen.yml has no trailing newline, and defaults to running
    # `go mod tidy`, which needs network access.
    printf '\nskip_mod_tidy: true\n' >> gqlgen.yml
    gqlgen generate
  '';

  # Development helper that seeds a database with random data.
  excludedPackages = [ "hack/datagen" ];

  tags = [
    "netgo"
    "osusergo"
    "sqlite_omit_load_extension"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.BuildMode=prod"
    "-X main.BuildVersion=${finalAttrs.version}"
  ];

  # The Go module is named `server`; upstream ships the binary as `traggo`.
  postInstall = ''
    mv $out/bin/server $out/bin/traggo
  '';

  passthru = {
    ui = callPackage ./ui.nix { inherit (finalAttrs) src version; };
    tests.traggo = nixosTests.traggo;
  };

  meta = {
    description = "Self-hosted, tag-based time tracking";
    homepage = "https://traggo.net";
    changelog = "https://github.com/traggo/server/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ elnudev ];
    mainProgram = "traggo";
    platforms = lib.platforms.linux;
  };
})
