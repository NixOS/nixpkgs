{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  withWayland ? true,
  cairo,
  libxkbcommon,
  wayland,
  withX ? true,
  libxi,
  libxinerama,
  libxft,
  libxfixes,
  libxtst,
  libx11,
  libxext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "warpd";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "warpd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5B3Ec+R1vF2iI0ennYcsRlnFXJkSns0jVbyAWJA4lTU=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [ git ];

  buildInputs =
    lib.optionals withWayland [
      cairo
      libxkbcommon
      wayland
    ]
    ++ lib.optionals withX [
      libxi
      libxinerama
      libxft
      libxfixes
      libxtst
      libx11
      libxext
    ];

  makeFlags = [
    "PREFIX=$(out)"
  ]
  ++ lib.optional (!withWayland) "DISABLE_WAYLAND=y"
  ++ lib.optional (!withX) "DISABLE_X=y";

  postPatch = ''
    substituteInPlace mk/linux.mk \
      --replace '-m644' '-Dm644' \
      --replace '-m755' '-Dm755' \
      --replace 'warpd.1.gz $(DESTDIR)' 'warpd.1.gz -t $(DESTDIR)' \
      --replace 'bin/warpd $(DESTDIR)' 'bin/warpd -t $(DESTDIR)'
  '';

  meta = {
    description = "Modal keyboard driven interface for mouse manipulation";
    homepage = "https://github.com/rvaiya/warpd";
    changelog = "https://github.com/rvaiya/warpd/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ hhydraa ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "warpd";
  };
})
