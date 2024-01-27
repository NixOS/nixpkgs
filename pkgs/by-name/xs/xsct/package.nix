{ stdenv
, lib
, fetchFromGitHub
, gitUpdater
, libX11
, libXrandr
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsct";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "faf0";
    repo = "sct";
    rev = finalAttrs.version;
    hash = "sha256-VT92NRz4Te5+8NmpEm1PFXfsL2CoVT+b91/KD9sCg0Q=";
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
    homepage = "https://github.com/faf0/sct";
    license = licenses.unlicense;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = with platforms; linux ++ freebsd ++ openbsd;
  };
})
