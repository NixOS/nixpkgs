{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uni-algo";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "uni-algo";
    repo = "uni-algo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IyQrL/DWDj87GplSGJC4iQJAzNURLh9TRko5l+EIfuU=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Unicode Algorithms Implementation for C/C++";
    homepage = "https://github.com/uni-algo/uni-algo";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ typedrat ];
  };
})
