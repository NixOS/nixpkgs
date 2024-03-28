{ lib
, stdenv
, fetchFromGitHub
, makeBinaryWrapper
, libpng
, libX11
, xclip

, opaqueMode ? true
, saveDir ? "Pictures"
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsnip";
  version = "0-unstable-2022-08-02";

  src = fetchFromGitHub {
    owner = "ws-kj";
    repo = "xsnip";
    rev = "d477de3ed788d0d4fce9c6a30ab079035e8e3767";
    hash = "sha256-d6CvAfG0cEVMzAzT/V91CACw4Yzp8PFuvChNnFZCEuI=";
  };

  buildInputs = [ libpng libX11 ];
  nativeBuildInputs = [ makeBinaryWrapper ];

  patches = [
    ./makefile.diff
    ./no-opaque.diff
  ];

  buildFlags = lib.optional opaqueMode "OPAQUE=1";
  installFlags = [ "DESTDIR=$(out)" ];

  postPatch = ''
    substituteInPlace config.h --replace-fail "Pictures" "${saveDir}"
  '';

  postInstall = ''
    wrapProgram $out/bin/xsnip \
      --prefix PATH : "${lib.makeBinPath [ xclip ]}"
  '';

  meta = with lib; {
    description = "Minimal screenshot utility for X";
    homepage = "https://github.com/ws-kj/xsnip/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    mainProgram = "xsnip";
    maintainers = with maintainers; [ jtbx ];
  };
})
