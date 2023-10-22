{ symlinkJoin
, makeWrapper
}: flutter:

let
  self =
    symlinkJoin {
      name = "${flutter.name}-sdk-links";
      paths = [ flutter flutter.sdk ];

      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram "$out/bin/flutter" \
          --set-default FLUTTER_ROOT "$out"
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
