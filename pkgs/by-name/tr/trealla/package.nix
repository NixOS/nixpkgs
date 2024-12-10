{
  lib,
  stdenv,
  fetchFromGitHub,
  libffi,
  openssl,
  readline,
  valgrind,
  xxd,
  gitUpdater,
  checkLeaks ? false,
  enableFFI ? true,
  enableSSL ? true,
  enableThreads ? true,
  lineEditingLibrary ? "isocline",
}:

assert lib.elem lineEditingLibrary [
  "isocline"
  "readline"
];
stdenv.mkDerivation (finalAttrs: {
  pname = "trealla";
  version = "2.34.0";

  src = fetchFromGitHub {
    owner = "trealla-prolog";
    repo = "trealla";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cqIiPeQO/M8MtpHRomN/fzxIq7TgUwZSvL3PFCVsEnY=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace '-I/usr/local/include' "" \
      --replace '-L/usr/local/lib' "" \
      --replace 'GIT_VERSION :=' 'GIT_VERSION ?='
  '';

  nativeBuildInputs = [
    xxd
  ];

  buildInputs =
    lib.optionals enableFFI [ libffi ]
    ++ lib.optionals enableSSL [ openssl ]
    ++ lib.optionals (lineEditingLibrary == "readline") [ readline ];

  nativeCheckInputs = lib.optionals finalAttrs.finalPackage.doCheck [ valgrind ];

  strictDeps = true;

  makeFlags =
    [
      "GIT_VERSION=\"v${finalAttrs.version}\""
    ]
    ++ lib.optionals (lineEditingLibrary == "isocline") [ "ISOCLINE=1" ]
    ++ lib.optionals (!enableFFI) [ "NOFFI=1" ]
    ++ lib.optionals (!enableSSL) [ "NOSSL=1" ]
    ++ lib.optionals enableThreads [ "THREADS=1" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin tpl
    runHook postInstall
  '';

  doCheck = !valgrind.meta.broken;

  checkFlags = [
    "test"
  ] ++ lib.optionals checkLeaks [ "leaks" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    homepage = "https://trealla-prolog.github.io/trealla/";
    description = "A compact, efficient Prolog interpreter written in ANSI C";
    longDescription = ''
      Trealla is a compact, efficient Prolog interpreter with ISO Prolog
      aspirations.
      Trealla is not WAM-based. It uses tree-walking, structure-sharing and
      deep-binding. Source is byte-code compiled to an AST that is interpreted
      at runtime. The intent and continued aim of Trealla is to be a small,
      easily ported, Prolog core.
      The name Trealla comes from the Liaden Universe books by Lee & Miller
      (where it doesn't seem to mean anything) and also a reference to the
      Trealla region of Western Australia.
    '';
    changelog = "https://github.com/trealla-prolog/trealla/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      siraben
      AndersonTorres
    ];
    mainProgram = "tpl";
    platforms = lib.platforms.all;
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
})
