{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  qemu,
}:
buildGoModule (finalAttrs: {
  pname = "tinyrange";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "tinyrange";
    repo = "tinyrange";
    tag = "v${finalAttrs.version}";

    hash = "sha256-JdcINhbSpBQOhdlqRluYjtg8rbsy5iPA8rWn3kuUhVo=";
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorHash = "sha256-WC2+HeuvBEyJVZaR2Eo98iQL8Nk4Q7e4+4jXljOQABg=";

  env.CGO_ENABLED = 0;

  # Remove the experimental directory; it messes with the build
  postPatch = ''
    rm -rf experimental
  '';

  subPackages = [
    "cmd/tinyrange_qemu"
    ""
  ];

  postFixup = ''
    wrapProgram $out/bin/tinyrange --prefix PATH : ${lib.makeBinPath [ qemu ]}
  '';

  meta = {
    description = "Light-weight scriptable orchestration system for building and running virtual machines";
    homepage = "https://github.com/tinyrange/tinyrange";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.theonlymrcat ];
    mainProgram = "tinyrange";
    platforms = lib.platforms.unix;
  };
})
