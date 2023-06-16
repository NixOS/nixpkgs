{ glibc, perl }:

# Small wrapper which only exposes `mtrace(3)` from `glibc`. This can't be placed
# into `glibc` itself because it depends on Perl which would mean that the final
# `glibc` inside a stdenv bootstrap has a dependency `glibc -> perl -> bootstrap tools`,
# so this is now in its own package that isn't used for bootstrapping.
#
# `glibc` needs to be overridden here because it's still needed to `./configure` the source in order
# to have a build environment where we can call the needed make target.

glibc.overrideAttrs (oldAttrs: {
  pname = "glibc-mtrace";

  preBuild = (oldAttrs.preBuild or "") + ''
    mkdir malloc
  '';

  makeFlags = (oldAttrs.makeFlags or []) ++ [
    "-C" "../glibc-${glibc.minorRelease}/malloc"
    "objdir=$$NIX_BUILD_TOP/build"
    "$NIX_BUILD_TOP/build/malloc/mtrace"
  ];

  # deliberately do not run glibc's preInstall/postInstall, but run
  # any which might be appended by overlays
  preInstall = "";
  postInstall = "";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv malloc/mtrace $out/bin/
    runHook postInstall
  '';

  # Perl checked during configure
  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ perl ];
  # Perl shebang used for `mtrace`.
  buildInputs = oldAttrs.buildInputs ++ [ perl ];

  # Reset a few things declared by `pkgs.glibc`.
  outputs = [ "out" ];
  separateDebugInfo = false;

  meta = oldAttrs.meta // {
    description = "Perl script used to interpret and provide human readable output of the trace log contained in the file mtracedata, whose contents were produced by mtrace(3).";
  };
})
