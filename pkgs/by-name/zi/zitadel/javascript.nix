{
  stdenv,

  buf,
  fetchPnpmDeps,
  nodejs,
  pnpm_10,
  pnpmConfigHook,

  protoImage,
  version,
  zitadelRepo,
}:

let
  pnpm = pnpm_10;

  # The workspace packages the console needs out of the repository-wide
  # pnpm-lock.yaml. Individual derivations narrow this down again via their own
  # `pnpmWorkspaces`.
  pnpmDeps = fetchPnpmDeps {
    pname = "zitadel";
    inherit version pnpm;
    src = zitadelRepo;
    fetcherVersion = 4;
    pnpmWorkspaces = [
      "@zitadel/client"
      "@zitadel/console"
      "@zitadel/proto"
    ];
    hash = "sha256-KxQwsQb+ycsx5b0rg15HBpy/nS0xAk1I/GIOvc4dsF0=";
  };

  # Upstream generates packages/zitadel-proto with `buf generate ../../proto`
  # (that package's `generate` script), using @bufbuild/protoc-gen-es from its
  # own npm dev dependencies. Here the generator runs against protoImage
  # instead of the proto tree, so it needs no network of its own.
  protoPackageGenerated = stdenv.mkDerivation {
    pname = "zitadel-proto-buf-generated";
    inherit version;

    src = zitadelRepo;

    inherit pnpmDeps;
    pnpmWorkspaces = [ "@zitadel/proto" ];

    nativeBuildInputs = [
      buf
      nodejs
      pnpm
      pnpmConfigHook
    ];

    buildPhase = ''
      runHook preBuild
      cd packages/zitadel-proto
      export PATH="$PWD/node_modules/.bin:$PATH"
      HOME=$TMPDIR buf generate ${protoImage}#format=binpb
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r es cjs types $out/
      runHook postInstall
    '';
  };
in
{
  inherit pnpm pnpmDeps protoPackageGenerated;
}
