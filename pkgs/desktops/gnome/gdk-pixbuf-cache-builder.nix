{
  runCommand,
  gdk-pixbuf,
  lib,
  stdenv,
  buildPackages,
}:

{
  extraLoaders,
}:

let
  # Get packages to generate the cache for. We always include gdk-pixbuf.
  loaderPackages = [
    gdk-pixbuf
  ]
  ++ extraLoaders;
in

# Generate the cache file by running gdk-pixbuf-query-loaders for each
# package and concatenating the results.
runCommand "gdk-pixbuf-loaders.cache"
  {
    preferLocalBuild = true;
  }
  ''
    (
      for package in ${lib.escapeShellArgs loaderPackages}; do
        module_dir="$package/${gdk-pixbuf.moduleDir}"
        if [[ ! -d "$module_dir" ]]; then
          echo "Error: gdkPixbufCacheBuilder: Passed package “''${package}” does not contain GdkPixbuf loaders in “${gdk-pixbuf.moduleDir}”." 1>&2
          exit 1
        fi
        if [[ "${lib.boolToString stdenv.hostPlatform.isDarwin}" == true ]]; then
          # gdk-pixbuf's Darwin scanner only considers .so modules, while
          # some third-party loaders are shipped as .dylib. Query explicit
          # module paths so both suffixes work.
          loaders=()
          for loader in "$module_dir"/loaders/*.so "$module_dir"/loaders/*.dylib "$module_dir"/*.so "$module_dir"/*.dylib; do
            [[ -f "$loader" ]] && loaders+=("$loader")
          done
          DYLD_LIBRARY_PATH=${lib.makeLibraryPath loaderPackages} \
            ${stdenv.hostPlatform.emulator buildPackages} ${gdk-pixbuf.dev}/bin/gdk-pixbuf-query-loaders "''${loaders[@]}"
        else
          GDK_PIXBUF_MODULEDIR="$module_dir" \
            ${stdenv.hostPlatform.emulator buildPackages} ${gdk-pixbuf.dev}/bin/gdk-pixbuf-query-loaders
        fi
      done
    ) > "$out"
  ''
