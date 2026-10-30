{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "valijson";
  version = "1.1.3";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "tristanpenman";
    repo = "valijson";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1bZPc+oSaKy7OuHqXDbswbVhNPm6273IeCh/Q48STZI=";
  };

  # QtJsonAdapter's isInteger()/getInteger() use QJsonValue::toInt() (32-bit),
  # so integral values outside int32 range (e.g. a uint32 CRC) either fail
  # "type": "integer" schema checks or get silently truncated. Still present
  # upstream as of this release. TODO: Upstream.
  patches = [
    ./qtjson-adapter-int64.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Header-only C++ library for JSON Schema validation, with support for many popular parsers";
    homepage = "https://github.com/tristanpenman/valijson";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
