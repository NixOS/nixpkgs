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
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-9GhrWhT0mYU2OOeoHGd5XY7BKO/S7cKTnURXi9dF+IU=";
  };

  cargoHash = "sha256-KGwmTXkY2nv5oWwjs5ZLz6u3bJ7YWJQPqOqJJNxKDkM=";

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
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
