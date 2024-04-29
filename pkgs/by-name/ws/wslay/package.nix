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

stdenv.mkDerivation rec {
  pname = "wslay";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "tatsuhiro-t";
    repo = "wslay";
    rev = "release-${version}";
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

  preCheck = lib.optionalString stdenv.isDarwin ''
    export DYLD_LIBRARY_PATH=$(pwd)/lib/.libs
  '';

  meta = with lib; {
    homepage = "https://tatsuhiro-t.github.io/wslay/";
    description = "The WebSocket library in C";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ pingiun ];
    platforms = platforms.unix;
  };
}
