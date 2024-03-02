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
