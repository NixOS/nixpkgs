{ stdenv, fetchFromGitHub, makeWrapper
, glibcLocales, gobject-introspection, gtk3, libsoup, libsecret
, buildPythonPackage, python
, pygobject3, freezegun, mock
}:

buildPythonPackage rec {
  pname = "gtimelog";
  version = "unstable-2020-05-16";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "80682ddbf9e0d68b8c67257289784f3b49b543d8";
    sha256 = "0qv2kv7vc3qqlzxsisgg31cmrkkqgnmxspbj10c5fhdmwzzwi0i9";
  };

  buildInputs = [
    makeWrapper
    glibcLocales gobject-introspection gtk3 libsoup libsecret
  ];

  propagatedBuildInputs = [
    pygobject3 freezegun mock
  ];

  checkPhase = ''
    substituteInPlace runtests --replace "/usr/bin/env python3" "${python.interpreter}"
    ./runtests
  '';

  pythonImportsCheck = [ "gtimelog" ];

  preFixup = ''
    wrapProgram $out/bin/gtimelog \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix LD_LIBRARY_PATH ":" "${gtk3.out}/lib" \
  '';

  meta = with stdenv.lib; {
    description = "A time tracking app";
    longDescription = ''
      GTimeLog is a small time tracking application for GNOME.
      It's main goal is to be as unintrusive as possible.

      To run gtimelog successfully on a system that does not have full GNOME 3
      installed, the following NixOS options should be set:
      - programs.dconf.enable = true;
      - services.gnome3.gnome-keyring.enable = true;

      In addition, the following packages should be added to the environment:
      - gnome3.adwaita-icon-theme
      - gnome3.dconf
    '';
    homepage = "https://gtimelog.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ocharles oxzi ];
    platforms = platforms.unix;
  };
}
