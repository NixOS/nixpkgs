{
  meta,
  src,
  version,

  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "veans";
  inherit src version;

  __structuredAttrs = true;

  modRoot = "veans";

  vendorHash = "sha256-cCRPfJDZXIlufMg3SkqtI7Hb5Dphu2Eofxuls3eSS+Q=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-X main.version=v${finalAttrs.version}"
  ];

  # needs a running vikunja instance
  doCheck = false;

  meta = meta // {
    description = "A beans-shaped CLI for Vikunja";
    homepage = "https://vikunja.io/docs/veans/";
    mainProgram = "veans";
  };
})
