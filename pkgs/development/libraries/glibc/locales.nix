/*
  This function builds just the `lib/locale/locale-archive' file from
  Glibc and nothing else.  If `allLocales' is true, all supported
  locales are included; otherwise, just the locales listed in
  `locales'.  See localedata/SUPPORTED in the Glibc source tree for
  the list of all supported locales:
  https://sourceware.org/git/?p=glibc.git;a=blob;f=localedata/SUPPORTED
*/

{
  lib,
  stdenv,
  buildPackages,
  callPackage,
  writeText,
  glibc,
  allLocales ? true,
  locales ? [ "en_US.UTF-8/UTF-8" ],
}:

(callPackage ./common.nix { inherit stdenv; } {
  pname = "glibc-locales";
  extraNativeBuildInputs = [ glibc ];
}).overrideAttrs
  (
    finalAttrs: previousAttrs: {

      builder = ./locales-builder.sh;

      outputs = [ "out" ];

      LOCALEDEF_FLAGS = [
        (if stdenv.hostPlatform.isLittleEndian then "--little-endian" else "--big-endian")
      ];

      preBuild =
        (previousAttrs.preBuild or "")
        + ''
          # Awful hack: `localedef' doesn't allow the path to `locale-archive'
          # to be overriden, but you *can* specify a prefix, i.e. it will use
          # <prefix>/<path-to-glibc>/lib/locale/locale-archive.  So we use
          # $TMPDIR as a prefix, meaning that the locale-archive is placed in
          # $TMPDIR/nix/store/...-glibc-.../lib/locale/locale-archive.
          LOCALEDEF_FLAGS+=" --prefix=$TMPDIR"

          mkdir -p $TMPDIR/"${buildPackages.glibc.out}/lib/locale"

          echo 'C.UTF-8/UTF-8 \' >> ../glibc-2*/localedata/SUPPORTED

          # Hack to allow building of the locales (needed since glibc-2.12)
          sed -i -e 's,^$(rtld-prefix) $(common-objpfx)locale/localedef,localedef $(LOCALEDEF_FLAGS),' ../glibc-2*/localedata/Makefile
        ''
        + lib.optionalString (!allLocales) ''
          # Check that all locales to be built are supported
          echo -n '${lib.concatMapStrings (s: s + " \\\n") locales}' \
            | sort -u > locales-to-build.txt
          cat ../glibc-2*/localedata/SUPPORTED | grep ' \\' \
            | sort -u > locales-supported.txt
          comm -13 locales-supported.txt locales-to-build.txt \
            > locales-unsupported.txt
          if [[ $(wc -c locales-unsupported.txt) != "0 locales-unsupported.txt" ]]; then
            cat locales-supported.txt
            echo "Error: unsupported locales detected:"
            cat locales-unsupported.txt
            echo "You should choose from the list above the error."
            false
          fi

          echo SUPPORTED-LOCALES='${toString locales}' > ../glibc-2*/localedata/SUPPORTED
        '';

      # Current `nixpkgs` way of building locales is not compatible with
      # parallel install. `locale-archive` is updated in parallel with
      # multiple `localedef` processes and causes non-deterministic result:
      #   https://github.com/NixOS/nixpkgs/issues/245360
      enableParallelBuilding = false;

      makeFlags = (previousAttrs.makeFlags or [ ]) ++ [
        "localedata/install-locales"
        "localedir=${builtins.placeholder "out"}/lib/locale"
      ];

      installPhase = ''
        mkdir -p "$out/lib/locale" "$out/share/i18n"
        cp -v "$TMPDIR/$NIX_STORE/"*"/lib/locale/locale-archive" "$out/lib/locale"
        cp -v ../glibc-2*/localedata/SUPPORTED "$out/share/i18n/SUPPORTED"
      '';

      setupHook = writeText "locales-setup-hook.sh" ''
        export LOCALE_ARCHIVE=@out@/lib/locale/locale-archive
      '';

      meta.description = "Locale information for the GNU C Library";
    }
  )
