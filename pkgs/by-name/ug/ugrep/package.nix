{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  brotli,
  bzip2,
  bzip3,
  lz4,
  makeWrapper,
  pcre2,
  testers,
  xz,
  zlib,
  zstd,
  # The `ugrep+` and `ug+` commands are the same as the
  # `ugrep` and `ug` commands, but also use filters to
  # search PDFs, documents, e-books, image metadata,
  # when these filter tools are present:
  poppler-utils, # Provides `pdftotext`.
  antiword,
  pandoc,
  exiftool,
  # Alleviates the need for users to pollute their
  # environment with these packages, but grows the
  # closure size massively; hence this is opt-in.
  wrapWithFilterUtils ? false,
  # `ugrep` has a compatibility mode for the `gnugrep`
  # variants. When `$0` is one of the variants, `ugrep`
  # behaves like it to be drop-in compatible. This can
  # be done simply through symlinks, just like is done
  # with `coreutils`. These will of course shadow the
  # `pkgs.gnugrep` binaries in `system-path`.
  createGrepReplacementLinks ? false,
  # All we need is its `meta.priority` to ensure `ugrep`
  # beats it.
  gnugrep,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ugrep";
  version = "7.5.0";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = "ugrep";
    rev = "v${finalAttrs.version}";
    hash = "sha256-y++cW+N6KPm+/g4pqvPeTfiuR6IRiSMONJ0tJ4+5ym0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    boost
    brotli
    bzip2
    bzip3
    lz4
    pcre2
    xz
    zlib
    zstd
  ];

  postFixup = ''
    # Needed because `ug+` and `ugrep+` are
    # just scripts that call `ug` or `ugrep`
    # with certain arguments. They must be
    # reachable.
    for i in ug+ ugrep+; do
      wrapProgram "$out/bin/$i" --prefix PATH : "${
        lib.makeBinPath (
          [ "$out" ]
          ++ (lib.optionals wrapWithFilterUtils [
            poppler-utils
            antiword
            pandoc
            exiftool
          ])
        )
      }"
    done
  ''
  + lib.optionalString createGrepReplacementLinks ''
    # These will be made relative by the
    # `_makeSymlinksRelativeInAllOutputs`
    # `postFixupHook`.
    for i in ${
      lib.concatStringsSep " " [
        "grep"
        "egrep"
        "fgrep"
        "zgrep"
        "zegrep"
        "zfgrep"
      ]
    }; do
      ln -s "$out/bin/ugrep" "$out/bin/$i"
    done
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta =
    with lib;
    {
      description = "Ultra fast grep with interactive query UI";
      homepage = "https://github.com/Genivia/ugrep";
      changelog = "https://github.com/Genivia/ugrep/releases/tag/v${finalAttrs.version}";
      maintainers = with maintainers; [
        numkem
        mikaelfangel
      ];
      license = licenses.bsd3;
      platforms = platforms.all;
      mainProgram = "ug";
    }
    # Needed to ensure that the grep replacements take precedence over
    # `gnugrep` when installed. Lower priority values win.
    // lib.optionalAttrs createGrepReplacementLinks {
      priority = (gnugrep.meta.priority or meta.defaultPriority) - 1;
    };
})
