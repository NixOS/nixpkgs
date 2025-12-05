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

  meta = with lib; {
    description = "Unicode Algorithms Implementation for C/C++";
    homepage = "https://github.com/uni-algo/uni-algo";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ typedrat ];
  };
})
