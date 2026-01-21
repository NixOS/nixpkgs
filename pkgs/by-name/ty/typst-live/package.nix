{
  lib,
  rustPlatform,
  fetchCrate,
  makeWrapper,
  typst,
}:

rustPlatform.buildRustPackage rec {
  pname = "typst-live";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-bR4Rhhs6rAC6C1nfPFj/3rCtfEziuTGn5m33CR0qZkU=";
  };

  cargoHash = "sha256-C85hV7uCsuRsxH2/8arjz9Pqs5j23s5b9RHmFsRtZSw=";

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/typst-live \
      --suffix PATH : ${lib.makeBinPath [ typst ]}
  '';

  meta = {
    description = "Hot reloading for your typst files";
    homepage = "https://github.com/ItsEthra/typst-live";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    mainProgram = "typst-live";
  };
}
