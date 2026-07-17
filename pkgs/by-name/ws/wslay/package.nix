{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  cunit,
  sphinx,
  autoreconfHook,
  nettle,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wslay";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "tatsuhiro-t";
    repo = "wslay";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-xKQGZO5hNzMg+JYKeqOBsu73YO+ucBEOcNhG8iSNYvA=";
  };

  postPatch = ''
    substituteInPlace doc/sphinx/conf.py.in \
      --replace-fail "add_stylesheet" "add_css_file"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    sphinx
  ];

  buildInputs = [ nettle ];

  doCheck = true;

  checkInputs = [ cunit ];

  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export DYLD_LIBRARY_PATH=$(pwd)/lib/.libs
  '';

  meta = {
    homepage = "https://tatsuhiro-t.github.io/wslay/";
    description = "WebSocket library in C";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pingiun ];
    platforms = lib.platforms.unix;
  };
})
