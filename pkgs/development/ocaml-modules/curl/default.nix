{
  buildDunePackage,
  pkg-config,
  dune-configurator,
  fetchurl,
  lib,
  curl,
}:

buildDunePackage (finalAttrs: {
  pname = "curl";
  version = "0.10.1";
  minimalOCamlVersion = "4.11";
  src = fetchurl {
    url = "https://github.com/ygrek/ocurl/releases/download/${finalAttrs.version}/curl-${finalAttrs.version}.tbz";
    hash = "sha256-ZJmBtnR0tWHwqrRWabc7AMCfuJvELbgksVUMqi0R+BU=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    curl
  ];

  doCheck = true;

  meta = {
    description = "Bindings to libcurl";
    homepage = "https://ygrek.org/p/ocurl/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vog ];
  };
})
