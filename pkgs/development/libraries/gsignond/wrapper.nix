{
  makeWrapper,
  symlinkJoin,
  gsignond,
  plugins,
}:

symlinkJoin {
  name = "gsignond-with-plugins-${gsignond.version}";

  paths = [ gsignond ] ++ plugins;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/gsignond \
      --set SSO_GPLUGINS_DIR "$out/lib/gsignond/gplugins"

    rm $out/share/dbus-1/services/com.google.code.AccountsSSO.gSingleSignOn.service
    rm $out/share/dbus-1/services/com.google.code.AccountsSSO.SingleSignOn.service

    substitute ${gsignond}/share/dbus-1/services/com.google.code.AccountsSSO.gSingleSignOn.service $out/share/dbus-1/services/com.google.code.AccountsSSO.gSingleSignOn.service \
      --replace ${gsignond} $out

    substitute ${gsignond}/share/dbus-1/services/com.google.code.AccountsSSO.SingleSignOn.service $out/share/dbus-1/services/com.google.code.AccountsSSO.SingleSignOn.service \
      --replace ${gsignond} $out
  '';

  inherit (gsignond) meta;
}
