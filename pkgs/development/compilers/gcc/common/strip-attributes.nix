{
  lib,
  stdenv,
  langJit,
}:

{
  # Note [Cross-compiler stripping]
  # gcc requires delicate stripping as it installs ELF files for both
  # HOST and TARGET platforms. It requires according strip tool otherwise
  # strip could remove sections it's not aware of.
  # Example ARM breakage by x86_64 strip: https://bugs.gentoo.org/697428
  #
  # Let's recap the file layout for directories with object files for a
  # cross-compiler:
  #
  # $out (host != target)
  # `- bin: HOST
  #    lib/*.{a,o}: HOST
  #      `- gcc/<TARGET>/<VERSION>/*.{a,o}: TARGET
  #                               `- plugin/: HOST
  #  `- lib{,32,64,x32}: symlink to lib or identical layout
  #  `- libexec/: HOST
  #  `- <TARGET>/: TARGET
  #
  # $out (host == target) has identical directory layout.
  #
  # $lib (host != target):
  # `- <TARGET>/lib/*.{la,so}: TARGET
  #
  # $lib (host == target):
  # `- lib/*.{la,so}: HOST

  # The rest of stripDebugList{Host,Target} will be populated in
  # postInstall to disambiguate lib/ object files.
  stripDebugList = [
    "bin"
    "libexec"
  ];
  stripDebugListTarget = [ stdenv.targetPlatform.config ];

  preFixup = ''
    # Populate most delicated lib/ part of stripDebugList{,Target}
    updateDebugListPaths() {
      local oldOpts
      oldOpts="$(shopt -p nullglob)" || true
      shopt -s nullglob

      pushd $out
      local -ar outHostFiles=(
        lib{,32,64}/*.{a,o,so*}
        lib{,32,64}/gcc/${stdenv.targetPlatform.config}/*/plugin
      )
      local -ar outTargetFiles=(
        lib{,32,64}/gcc/${stdenv.targetPlatform.config}/*/*.{a,o,so*}
      )
      popd
  ''
  + lib.optionalString (!langJit) ''
    ${
      # keep indentation
      ""
    }
      pushd $lib
      local -ar libHostFiles=(
        lib{,32,64}/*.{a,o,so*}
      )
      local -ar libTargetFiles=(
        lib{,32,64}/${stdenv.targetPlatform.config}/*.{a,o,so*}
      )
      popd

  ''
  + ''
      eval "$oldOpts"

      stripDebugList="$stripDebugList ''${outHostFiles[*]} ''${libHostFiles[*]}"
      stripDebugListTarget="$stripDebugListTarget ''${outTargetFiles[*]} ''${libTargetFiles[*]}"
    }
    updateDebugListPaths
  '';
}
