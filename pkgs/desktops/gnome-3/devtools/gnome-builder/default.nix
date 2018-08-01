{ stdenv
, appstream-glib
, autoconf
, clang
, clang-tools
, cmake
, ctags
, defaultIconTheme
, desktop-file-utils
, devhelp
, docbook_xsl
, fetchurl
, gettext
, gjs
, glib
, gnome3
, gnumake
, gspell
, gtk-doc
, gtk3
, gtksourceview
, indent
, json-glib
, jsonrpc-glib
, libdazzle
, libgit2-glib
, libpeas
, libxml2
, llvmPackages
, meson
, ninja
, packagekit
, pcre
, pkgconfig
, python3
, substituteAll
, sysprof
, template-glib
, unzip
, vala
, vte
, webkitgtk
, which
, wrapGAppsHook
}:

let
  version = "3.28.3";
  pname = "gnome-builder";
  python = python3.withPackages (pkgs: with pkgs; [ jedi pygobject3 sphinx sphinx_rtd_theme ]);
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  nativeBuildInputs = [ gettext meson ninja pkgconfig wrapGAppsHook appstream-glib desktop-file-utils gtk-doc docbook_xsl ];
  buildInputs = [
    ctags defaultIconTheme devhelp gspell gtk3 gtksourceview json-glib
    jsonrpc-glib libdazzle libgit2-glib libpeas libxml2 python
    llvmPackages.clang llvmPackages.llvm pcre sysprof template-glib vala
    vte webkitgtk
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0vvj1fipip572h23kd780mfiq7hymbxdqkl2k5l0q27hxgpp4ax6";
  };

  mesonFlags = [
    "-Dwith_flatpak=false"
    "-Dwith_clang=false" # Compiler /nix/store/xxx-gcc-wrapper-7.3.0/bin/c++ can not compile programs.
    "-Dwith_docs=true"
  ];

  patches = [
    # ./fix-libide.patch
    # (substituteAll {
    #   src = ./fix-clang-plugin.patch;
    #   clangCc = clang.cc;
    # })
    (substituteAll {
      src = ./fix-paths.patch;
      glibDev = glib.dev;
      sitePackages = python3.sitePackages;
      inherit autoconf clang clang-tools cmake gjs gnumake indent meson packagekit pkgconfig unzip which;
    })
  ];

  postPatch = ''
    patchShebangs build-aux/meson/post_install.py
  '';


  preFixup =
    let
      pythonPath = with python3.pkgs; makePythonPath [ pygobject3 ];
    in ''
      gappsWrapperArgs+=(
        --set PYTHONPATH "${pythonPath}" # for libpeas plugin loader
      )
    '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "An IDE for writing GNOME-based software";
    homepage = https://wiki.gnome.org/Apps/Builder;
    license = licenses.gpl3;
    maintainers = [ maintainers.andir ];
    platforms = platforms.linux;
  };
}
