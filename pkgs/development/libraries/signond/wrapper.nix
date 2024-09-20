{
  makeWrapper,
  symlinkJoin,
  signond,
  plugins,
}:

symlinkJoin {
  name = "signond-with-plugins-${signond.version}";

  paths = [ signond ] ++ plugins;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/signond \
      --set SSO_PLUGINS_DIR "$out/lib/signond/" \
      --set SSO_EXTENSIONS_DIR "$out/lib/signond/extensions/"

    rm $out/share/dbus-1/services/com.google.code.AccountsSSO.SingleSignOn.service

    substitute ${signond}/share/dbus-1/services/com.google.code.AccountsSSO.SingleSignOn.service $out/share/dbus-1/services/com.google.code.AccountsSSO.SingleSignOn.service \
      --replace-fail ${signond} $out
  '';

  inherit (signond) meta;
}
