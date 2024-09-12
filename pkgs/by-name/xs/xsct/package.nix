{ stdenv
, lib
, fetchFromGitHub
, gitUpdater
, libX11
, libXrandr
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsct";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "faf0";
    repo = "sct";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-L93Gk7/jcRoUWogWhrOiBvWCCj+EbyGKxBR5oOVjPPU=";
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
    changelog = "https://github.com/faf0/sct/blob/${finalAttrs.version}/CHANGELOG";
    license = licenses.unlicense;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = with platforms; linux ++ freebsd ++ openbsd;
  };
})
