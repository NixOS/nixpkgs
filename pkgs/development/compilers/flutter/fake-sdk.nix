{ flutter, symlinkJoin }:

symlinkJoin {
  name = "flutter-fake-${flutter.name}";
  paths = [ flutter flutter.unwrapped ];

  inherit (flutter) passthru;

  meta = flutter.meta // {
    longDescription = ''
      ${flutter.meta.longDescription}
      Modified binaries are linked into the original SDK directory for use with tools that use the whole SDK.
    '';
  };
}
