{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  darwin,
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

  useFetchCargoVendor = true;
  cargoHash = "sha256-C85hV7uCsuRsxH2/8arjz9Pqs5j23s5b9RHmFsRtZSw=";

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  postInstall = ''
    wrapProgram $out/bin/typst-live \
      --suffix PATH : ${lib.makeBinPath [ typst ]}
  '';

  meta = with lib; {
    description = "Hot reloading for your typst files";
    homepage = "https://github.com/ItsEthra/typst-live";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "typst-live";
  };
}
