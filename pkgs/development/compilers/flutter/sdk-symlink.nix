{ symlinkJoin }: flutter:

let
  self =
    symlinkJoin {
      name = "${flutter.name}-sdk-links";
      paths = [ flutter flutter.sdk ];

      # The final flutter binary is required to be a git repo.
      # https://github.com/flutter/flutter/blob/07042fa27cfb0f536776bc87e1f149c0fa3727fc/bin/internal/shared.sh#L224
      postBuild = ''
        ln -s ${flutter.sdk}/.git $out/.git
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
