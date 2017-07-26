{stdenv, lib, python, dbus, fetchgit, cmake, coreutils, jq, gobjectIntrospection, python27Packages, makeWrapper, gnome3, wrapGAppsHook}:

stdenv.mkDerivation rec {
name="chrome-gnome-shell";
  src = fetchgit {
    url = "git://git.gnome.org/chrome-gnome-shell";
    rev = "7d99523e90805cb65027cc2f5f1191a957dcf276";
    sha256 = "0qc34dbhsz5yf4z5bx6py08h561rcxw9928drgk9256g3vnygnbc";
  };
 
 buildInputs = [ gnome3.gnome_shell makeWrapper jq dbus gobjectIntrospection
 python python27Packages.requests python27Packages.pygobject3 wrapGAppsHook];

 preConfigure = ''
 mkdir build usr etc
 cd build
 ${cmake}/bin/cmake -DCMAKE_INSTALL_PREFIX=$out/usr -DBUILD_EXTENSION=OFF ../
 substituteInPlace cmake_install.cmake --replace "/etc" "$out/etc"  
 '';

 postInstall = ''
    rm $out/etc/opt/chrome/policies/managed/chrome-gnome-shell.json
    rm $out/etc/chromium/policies/managed/chrome-gnome-shell.json
    wrapProgram $out/usr/bin/chrome-gnome-shell \
      --prefix PATH '"${dbus}/bin/dbus:$PATH"' \
      --prefix PATH '"${gnome3.gnome_shell}:$PATH"' \
      --prefix PYTHONPATH : "$PYTHONPATH" 

  '';

}
