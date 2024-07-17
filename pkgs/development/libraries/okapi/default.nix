{
  lib,
  stdenv,
  rustPlatform,
  fetchurl,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "okapi";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/trinsic-id/okapi/releases/download/v${version}/okapi-vendor-${version}.tar.gz";
    sha256 = "sha256-wszpCzh1VhqBlox7ywWi6WKUmxQUTsf5N5IiJumlEbM=";
  };

  cargoVendorDir = "vendor";
  doCheck = false;

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    cp -r include $out
  '';

  meta = with lib; {
    description = "Okapi Library";
    longDescription = ''
      Collection of tools that support workflows for working
      with authentic data and identity management
    '';
    homepage = "https://github.com/trinsic-id/okapi";
    license = licenses.asl20;
    maintainers = with maintainers; [ tmarkovski ];
  };
}
