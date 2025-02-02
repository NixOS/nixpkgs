{
  darwin,
  fetchCrate,
  lib,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "ttfb";
  version = "1.14.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-TElRWWPTwigyLikda7FdDh0tSC67XdPDg/Gu5aVQlAw=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  cargoHash = "sha256-lB1AgigYsPwaIvD0HmgOnKK28pIpn1iIDKsvCpKvlfM=";

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
