{ stdenv, symlinkJoin, makeWrapper, dbus, gnome3 }:

symlinkJoin {
  name = "dbus-wrapped";

  paths = [ dbus ];

  buildInputs = [ makeWrapper ];
  postBuild = ''
    for i in $out/bin/*
      do wrapProgram $i \
        --set PATH ${gnome3.gnome-session}/bin:$PATH
    done
  '';
}
