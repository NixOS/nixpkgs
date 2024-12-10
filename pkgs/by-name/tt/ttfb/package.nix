{
  darwin,
  fetchCrate,
  lib,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "ttfb";
  version = "1.13.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-G5RSnh+S7gbIWJxm778pHN36xghpptcCpfElada0Afo=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  cargoHash = "sha256-kgfET2hOw0OAbBcKS7BOvY3nrLNX6CcQ6fOzVJ9rMOU=";

  # The bin feature activates all dependencies of the binary. Otherwise,
  # only the library is build.
  buildFeatures = [ "bin" ];

  meta = {
    description = "CLI-Tool to measure the TTFB (time to first byte) of HTTP(S) requests";
    mainProgram = "ttfb";
    longDescription = ''
      ttfb measure the TTFB (time to first byte) of HTTP(S) requests. This includes data
      of intermediate steps, such as the relative and absolute timings of DNS lookup, TCP
      connect, and TLS handshake.
    '';
    homepage = "https://github.com/phip1611/ttfb";
    changelog = "https://github.com/phip1611/ttfb/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ phip1611 ];
  };
}
