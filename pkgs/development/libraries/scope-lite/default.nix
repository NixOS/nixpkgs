{
  stdenv,
  cmake,
  fetchFromGitHub,
  lib,
}:
let
  version = "0.2.0";
in
stdenv.mkDerivation {
  name = "scope-lite-${version}";

  src = fetchFromGitHub {
    owner = "martinmoene";
    repo = "scope-lite";
    rev = "v${version}";
    hash = "sha256-/Vu3blgyEOQRFqhQjuT/6ukV0iWA0TdPrLnt2Z/gd6E=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "A migration path to C++ library extensions scope_exit, scope_fail, scope_success, unique_resource";
    license = lib.licenses.boost;
    maintainers = [ lib.maintainers.shlevy ];
    homepage = "https://github.com/martinmoene/scope-lite";
    platforms = lib.platforms.all;
  };
}
