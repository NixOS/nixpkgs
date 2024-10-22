{ symlinkJoin
, makeWrapper
}: flutter:

let
  self =
    symlinkJoin {
      name = "${flutter.name}-sdk-links";
      paths = [ flutter flutter.cacheDir flutter.sdk ];

      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram "$out/bin/flutter" \
          --set-default FLUTTER_ROOT "$out"

        # symlinkJoin seems to be missing the .git directory for some reason.
        if [ -d '${flutter.sdk}/.git' ]; then
          ln -s '${flutter.sdk}/.git' "$out"
        fi

        # For iOS/macOS builds, *.xcframework/'s from the pre-built
        # artifacts are copied into each built app. However, the symlinkJoin
        # means that the *.xcframework's contain symlinks into the nix store,
        # which causes issues when actually running the apps.
        #
        # We'll fix this by only linking to an outer *.xcframework dir instead
        # of trying to symlinkJoin the files inside the *.xcframework.
        artifactsDir="$out/bin/cache/artifacts/engine"
        shopt -s globstar
        for file in "$artifactsDir"/**/*.xcframework/Info.plist; do
          # Get the unwrapped path from the Info.plist inside each .xcframework
          origFile="$(readlink -f "$file")"
          origFrameworkDir="$(dirname "$origFile")"

          # Remove the symlinkJoin .xcframework dir and replace it with a symlink
          # to the unwrapped .xcframework dir.
          frameworkDir="$(dirname "$file")"
          rm -r "$frameworkDir"
          ln -s "$origFrameworkDir" "$frameworkDir"
        done
        shopt -u globstar
      '';

      passthru = flutter.passthru // {
        # Update the SDK attribute.
        # This allows any modified SDK files to be included
        # in future invocations.
        sdk = self;
      };

      meta = flutter.meta // {
        longDescription = ''
          ${flutter.meta.longDescription}
          Modified binaries are linked into the original SDK directory for use with tools that use the whole SDK.
        '';
      };
    };
in
self
