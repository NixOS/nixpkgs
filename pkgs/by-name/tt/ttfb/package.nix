{
  fetchCrate,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "ttfb";
  version = "1.15.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-OOVqCWeF5cHMweEGWYIiWWWsw1QlNDFgnia05Qxo7uo=";
  };

  cargoHash = "sha256-4Nsg5/66enMgAfPrUQHuhOTTwG2OWyyvKMHIhPnlHko=";

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
