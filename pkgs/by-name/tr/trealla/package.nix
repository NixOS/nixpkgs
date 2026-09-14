{
  lib,
  fetchFromGitHub,
  libffi,
  nix-update-script,
  openssl,
  readline,
  stdenv,
  testers,
  valgrind,
  xxd,
  # Boolean flags
  checkLeaks ? false,
  enableFFI ? true,
  enableSSL ? true,
  enableThreads ? true,
  # Configurable inputs
  lineEditingLibrary ? "isocline",
}:

assert lib.elem lineEditingLibrary [
  "isocline"
  "readline"
];
stdenv.mkDerivation (finalAttrs: {
  pname = "trealla";
  version = "3.9.39";

  src = fetchFromGitHub {
    owner = "trealla-prolog";
    repo = "trealla";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yfulQuwR3DgZk7ZUrVdqs09uZOcRmrTkZuU45Sw/f/o=";
  };

  postPatch = ''
    substituteInPlace GNUmakefile \
      --replace-fail '-I/usr/local/include' "" \
      --replace-fail '-I/usr/local/opt/libffi/include' "" \
      --replace-fail '-L/usr/local/lib' ""
  '';

  nativeBuildInputs = [ xxd ];

  buildInputs =
    lib.optionals enableFFI [ libffi ]
    ++ lib.optionals enableSSL [ openssl ]
    ++ lib.optionals (lineEditingLibrary == "readline") [ readline ];

  nativeCheckInputs = lib.optionals finalAttrs.finalPackage.doCheck [ valgrind ];

  strictDeps = true;

  env.LC_ALL = if stdenv.hostPlatform.isDarwin then "en_US.UTF-8" else "C.UTF-8";

  makeFlags = [
    "GIT_VERSION=\"v${finalAttrs.version}\""
    "PREFIX=$(out)"
  ]
  ++ lib.optionals (lineEditingLibrary == "isocline") [ "ISOCLINE=1" ]
  ++ lib.optionals (!enableFFI) [ "NOFFI=1" ]
  ++ lib.optionals (!enableSSL) [ "NOSSL=1" ]
  ++ lib.optionals (!enableThreads) [ "NOTHREADS=1" ];

  enableParallelBuilding = true;

  postInstall = ''
    find $out/share/trealla/library -type f \
      \( -name '*.c' -o -name '*.d' -o -name '*.o' \) -delete
  '';

  doCheck = !valgrind.meta.broken;

  checkFlags = [ "test" ] ++ lib.optionals checkLeaks [ "leaks" ];

  passthru = {
    updateScript = nix-update-script { };

    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        version = "v${finalAttrs.version}";
      };
    };
  };

  meta = {
    homepage = "https://trealla-prolog.github.io/trealla/";
    description = "Compact, efficient Prolog interpreter written in ANSI C";
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
    ];
    mainProgram = "tpl";
    platforms = lib.platforms.all;
  };
})
