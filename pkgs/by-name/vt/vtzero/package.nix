{ lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  protozero,
  ctestCheckHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vtzero";
  version = "1.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "vtzero";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-lT9H2dlFPT12CcSj9DzZLKvqX4tu8DsZxLEhms0c3g8=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ protozero ];

  doCheck = true;
  nativeCheckInputs = [ ctestCheckHook ];

  meta = {
    homepage = "https://github.com/mapbox/vtzero";
    changelog = "https://github.com/mapbox/vtzero/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.erictapen ];
  };
})
