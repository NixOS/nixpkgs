# broken binary but libraries & pkg-config needed for system-settings
# pkg-config files have pre-expanded paths
# this whole thing is one huge mess, desperately need
{ stdenv, fetchFromGitHub
, autoconf, automake, libtool, perl, intltool, vala, pkg-config, getopt, python3, wrapGAppsHook
, glib, json-glib, libgee, gobject-introspection, systemd
}:

let
  version = "2020-05-17";
  src = fetchFromGitHub {
    owner = "ubports";
    repo = "click";
    rev = "06912463aa63b407fcaf895bce6c9cd537bf6914";
    sha256 = "0kgrskami9rjk0qkrnzm3kd209nxzf5hmw3cdqkhp5rfd548csry";
  };
  click-c = stdenv.mkDerivation {
    pname = "click-c-unstable";
    inherit version src;

    outputs = [ "out" "click_package" ];

    postPatch = ''
      substituteInPlace click_package/tests/Makefile.am \
        --replace "PKG_CONFIG_PATH=" 'PKG_CONFIG_PATH=$(PKG_CONFIG_PATH):'
      substituteInPlace Makefile.am \
        --replace "debhelper" ""
      sed -i -e '1!d' Makefile.am
    '';

    nativeBuildInputs = [
      autoconf automake libtool perl intltool vala pkg-config getopt
    ];

    buildInputs = [ glib json-glib libgee gobject-introspection systemd ];

    propagatedBuildInputs = [ json-glib libgee gobject-introspection ];

    configureFlags = [
      "--disable-packagekit"
      "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
      "--with-systemduserunitdir=${placeholder "out"}/lib/systemd/user"
    ];

    preConfigure = ''
      ./autogen.sh
    '';

    postInstall = ''
      mkdir $click_package
      cp -a setup.py click_package/ $click_package
    '';
  };
in
  python3.pkgs.buildPythonApplication {
    pname = "click-unstable";
    inherit version src;

    nativeBuildInputs = [ perl wrapGAppsHook ];

    propagatedBuildInputs = [ click-c ] ++ (with python3.pkgs; [ chardet pygobject3 ]);

    configurePhase = ''
      cp -r ${click-c.click_package}/* ./
    '';

    doCheck = false; # requires dpkg
    dontWrapGApps = true;

    preFixup = ''
      makeWrapperArgs+=(
        "''${gappsWrapperArgs[@]}"
      )
    '';
  }
