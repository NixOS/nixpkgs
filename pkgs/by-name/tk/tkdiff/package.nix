{ diffutils, fetchzip, lib, makeBinaryWrapper, stdenv, tk }:

stdenv.mkDerivation (finalAttrs: {
  pname = "tkdiff";
  version = "5.6";

  src = fetchzip {
    url = "mirror://sourceforge/tkdiff/tkdiff-${builtins.replaceStrings ["."] ["-"] finalAttrs.version}.zip";
    hash = "sha256-EpbIdjsejkkTaSpoZRM5AHz0r1Cio+YzRryK0BoghBk=";
  };

  # fix regression: allow /dev/null again. eg: "tkdiff /dev/null file"
  # svn diff --git -r188:189 https://svn.code.sf.net/p/tkdiff/code/trunk
  patches = [ ./189.patch ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin tkdiff
    wrapProgram $out/bin/tkdiff \
      --prefix PATH : ${lib.makeBinPath [ diffutils tk ]}

    runHook postInstall
  '';

  meta = {
    description = "A graphical front end to the diff program";
    homepage = "https://tkdiff.sourceforge.io/";
    license = lib.licenses.gpl2Plus;
    longDescription = ''
      TkDiff is a graphical front end to the diff program. It provides a
      side-by-side view of the differences between two text files, along
      with several innovative features such as diff bookmarks, a graphical
      map of differences for quick navigation, and a facility for slicing
      diff regions to achieve exactly the merge output desired.
    '';
    mainProgram = "tkdiff";
    maintainers = with lib.maintainers; [ robert-manchester ];
    platforms = tk.meta.platforms;
  };
})
