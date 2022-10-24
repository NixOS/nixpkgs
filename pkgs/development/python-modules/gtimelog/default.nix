{ lib
, fetchFromGitHub
, makeWrapper
, python
, buildPythonPackage
, atk
, gdk-pixbuf
, glibcLocales
, glib-networking
, gobject-introspection
, gtk3
, harfbuzz
, libsecret
, libsoup
, pango
}:
buildPythonPackage rec {
  pname = "gtimelog";
  version = "unstable-2022-10-28";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "73d2228cea7e500858075a139fd321b1ccbae0d1";
    sha256 = "sha256-g6gU95uvBhBbB4b1McE2LuVPDCjdmmhBX3lVyCY96zA=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    glibcLocales
    gobject-introspection
    gtk3
    libsoup
    libsecret
  ];

  propagatedBuildInputs = with python.pkgs; [
    pygobject3
    freezegun
    mock
  ];

  checkPhase = ''
    substituteInPlace runtests --replace "/usr/bin/env python3" "${python.interpreter}"
    ./runtests
  '';

  pythonImportsCheck = [ "gtimelog" ];

  # found this fix at Matrix
  # see https://matrix.to/#/!KqkRjyTEzAGRiZFBYT:nixos.org/$reRwjXiP3c4q9-z3wnnnBF9Q5KYGi9w3DxeQLhEJhnI?via=nixos.org&via=matrix.org&via=tchncs.de
  # resolves runtime error: Typelib files for Gtk-3.0 are not available.
  makeWrapperArgs = [
    "--set GI_TYPELIB_PATH ${lib.makeSearchPathOutput "lib"
      "lib/girepository-1.0" ([
        gtk3
        libsoup
        libsecret
        pango
        harfbuzz
        gdk-pixbuf
        atk
      ])}"
    "--set GIO_MODULE_DIR ${lib.makeSearchPathOutput "out"
      "lib/gio/modules" ([
        glib-networking
      ])}"
  ];

  preFixup = ''
    wrapProgram $out/bin/gtimelog \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix LD_LIBRARY_PATH ":" "${gtk3.out}/lib" \
  '';

  meta = with lib; {
    description = "A time tracking app";
    longDescription = ''
      GTimeLog is a small time tracking application for GNOME.
      It's main goal is to be as unintrusive as possible.
      To run gtimelog successfully on a system that does not have full GNOME 3
      installed, the following NixOS options should be set:
      - programs.dconf.enable = true;
      - services.gnome.gnome-keyring.enable = true;
      In addition, the following packages should be added to the environment:
      - gnome.adwaita-icon-theme
      - gnome.dconf
    '';
    homepage = "https://gtimelog.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ oxzi nazarewk ];
  };
}
