{ stdenv
, lib
, buildPackages
, fetchurl
, pkgsCross
, substituteAll
, pkg-config
, gi-docgen
, gobject-introspection
, meson
, ninja
, vala
, gjs
, glib
, lua5_1
, python3
, spidermonkey_128
, gnome
}:

let
  luaEnv = lua5_1.withPackages (ps: with ps; [ lgi ]);
in
stdenv.mkDerivation rec {
  pname = "libpeas";
  version = "2.0.5";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-N28vc9cxtU4T3bqx2Rtjgs9qmAUk3vRN9irdFUid5t0=";
  };

  patches = [
    # Make PyGObject’s gi library available.
    (substituteAll {
      src = ./fix-paths.patch;
      pythonPaths = lib.concatMapStringsSep ", " (pkg: "'${pkg}/${python3.sitePackages}'") [
        python3.pkgs.pygobject3
      ];
    })
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    gi-docgen
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gjs
    glib
    luaEnv
    python3
    python3.pkgs.pygobject3
    spidermonkey_128
  ];

  propagatedBuildInputs = [
    # Required by libpeas-2.pc
    gobject-introspection
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dvapi=true"
  ];

  # required for locating lua dependencies at build time (when cross compiling):
  env.LUA_CPATH = "${luaEnv}/lib/lua/${luaEnv.luaversion}/?.so";
  env.LUA_PATH = "${luaEnv}/share/lua/${luaEnv.luaversion}/?.lua";

  strictDeps = true;

  postPatch = ''
    # Checks lua51 and lua5.1 executable but we have none of them.
    # Then it tries to invoke lua to check for LGI, which requires emulation for cross.
    substituteInPlace meson.build \
      --replace-fail \
        "find_program('lua51', required: false)" \
        "find_program('${lib.getExe' lua5_1 "lua"}', required: false)" \
      --replace-fail \
        "run_command(lua_prg, [" \
        "run_command('${stdenv.hostPlatform.emulator buildPackages}', [lua_prg, "
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "libpeas2";
      packageName = "libpeas";
      versionPolicy = "odd-unstable";
    };

    tests.cross = pkgsCross.aarch64-multiplatform.libpeas2;
  };

  meta = with lib; {
    description = "GObject-based plugins engine";
    homepage = "https://gitlab.gnome.org/GNOME/libpeas";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
