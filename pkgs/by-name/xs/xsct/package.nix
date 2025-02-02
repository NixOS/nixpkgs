{ stdenv
, lib
, fetchFromGitHub
, gitUpdater
, libX11
, libXrandr
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsct";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "faf0";
    repo = "sct";
    rev = finalAttrs.version;
    hash = "sha256-PDkbZTtl14wYdfALv43SIU9MKhbfiYlRqkI1mFn1qa4=";
  };

  buildInputs = [
    libX11
    libXrandr
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Set color temperature of screen";
    mainProgram = "xsct";
    homepage = "https://github.com/faf0/sct";
    license = licenses.unlicense;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = with platforms; linux ++ freebsd ++ openbsd;
  };
})
