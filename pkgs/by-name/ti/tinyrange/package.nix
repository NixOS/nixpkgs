{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  qemu,
}:
buildGoModule (finalAttrs: {
  pname = "tinyrange";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "tinyrange";
    repo = "tinyrange";
    tag = "v${finalAttrs.version}";

    hash = "sha256-p3zJPammXWCJTsPZpK435inHA6W9CMk0394jXoXKK5g=";
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorHash = "sha256-K2aHB0t+lkO0DJoJ60OcPKa+v3WMeaD0LyxaZXX3U6M=";

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
