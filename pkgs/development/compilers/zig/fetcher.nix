{
  lib,
  stdenv,
  zig,
}:
{
  pname,
  version,
  name ? "${pname}-${version}",
  src,
  hash ? lib.fakeHash,
  manuallyFetchLazyDeps ? false,
  ...
}@args:

assert if manuallyFetchLazyDeps then !(lib.versionAtLeast zig.version "0.15") else true;

let
  fetchCommand =
    if lib.versionAtLeast zig.version "0.15" then
      ''
        TERM=dumb zig build --fetch=all
      ''
    else if !manuallyFetchLazyDeps then
      ''
        TERM=dumb zig build --fetch
      ''
    else
      ''
        manuallyFetchLazyDeps .
      '';
in
stdenv.mkDerivation (
  {
    name = "${name}-zig-deps";
    inherit src;

    nativeBuildInputs = [ zig ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export ZIG_GLOBAL_CACHE_DIR=$(mktemp -d)

      package_dirs_checked=()

      # Manually try to recursively fetch all dependencies
      # by stripping the .lazy = true from build.zig.zon
      # manifests.
      #
      # This workaround fails if dependencies rely on diifferent
      # Zig versions.
      #
      # This should not be used for post-0.15, since the
      # --fetch=all flag exists.
      function manuallyFetchLazyDeps() {
        package="$1"

        if [[ "''${package_dirs_checked[*]}" =~ $package ]]; then
          return 0
        fi
        package_dirs_checked+=("$package")

        if [ -e "$package/build.zig.zon" ]; then
          sed -i '/^\s*\.lazy\s*=\s*true\s*,\s*$/d' "$package/build.zig.zon"

          cd "$package" || exit 1
          TERM=dumb zig build --fetch
          for dir in "$ZIG_GLOBAL_CACHE_DIR"/p/*; do
            manuallyFetchLazyDeps "$dir"
          done
        fi
      }

      ${fetchCommand}

      runHook postBuild
    '';

    dontFixup = true;

    installPhase = ''
      runHook preInstall
      mv $ZIG_GLOBAL_CACHE_DIR/p $out
      runHook postInstall
    '';

    outputHashAlgo = null;
    outputHashMode = "recursive";
    outputHash = hash;
  }
  // args
)
