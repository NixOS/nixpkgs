{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "transifex-cli";
  version = "1.6.17";

  src = fetchFromGitHub {
    owner = "transifex";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-jzAt/SalItGG0KI3GZb4/pT4T7oHwCji2bjNR1BTJXI=";
  };

  vendorHash = "sha256-3gi2ysIb5256CdmtX38oIfeDwNCQojK+YB9aEm8H01Q=";

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/transifex/cli/internal/txlib.Version=${finalAttrs.version}'"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/tx
  '';

  # Tests contain network calls
  doCheck = false;

  meta = {
    description = "Transifex command-line client";
    homepage = "https://github.com/transifex/cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thornycrackers ];
    mainProgram = "tx";
  };
})
