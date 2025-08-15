let
  allThumbnailers = [
    "aiff"
    "appimage"
    "epub"
    "gimp"
    "jxl"
    "mp3"
    "ora"
    "raw"
    "vorbiscomment"
  ];
in
{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsNoGuiHook,
  gobject-introspection,
  meson,
  ninja,
  gdk-pixbuf,
  xapp,

  dcraw,
  gimp,
  libjxl,
  squashfsTools,

  # Exclude "raw" for now because dcraw is vulnerable.
  thumbnailers ? [
    "aiff"
    "appimage"
    "epub"
    "gimp"
    "jxl"
    "mp3"
    "ora"
    "vorbiscomment"
  ],

  # passthru.updateScript
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "xapp-thumbnailers";
  version = "1.2.8";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xapp-thumbnailers";
    tag = version;
    hash = "sha256-MX2TvtuOmqi8cpA/K8pSEPScUOXEmz++t7Xb/eDdb9c=";
  };

  patches = [ ./meson.patch ];

  postPatch = ''
    # Delete files for thumbnailers that are not needed
    for format in ${lib.concatStringsSep " " (lib.subtractLists thumbnailers allThumbnailers)}; do
      rm files/usr/bin/xapp-$format-thumbnailer
      rm files/usr/share/thumbnailers/xapp-$format-thumbnailer.thumbnailer
    done

    # Make thumbnailer binaries executable (because not all of them are), use absolute paths in thumbnailer files
    for format in ${lib.concatStringsSep " " thumbnailers}; do
      chmod +x files/usr/bin/xapp-$format-thumbnailer
      substituteInPlace files/usr/share/thumbnailers/xapp-$format-thumbnailer.thumbnailer \
        --replace-fail "TryExec=xapp-$format-thumbnailer" "TryExec=${placeholder "out"}/bin/xapp-$format-thumbnailer" \
        --replace-fail "Exec=xapp-$format-thumbnailer" "Exec=${placeholder "out"}/bin/xapp-$format-thumbnailer"
    done
  '';

  nativeBuildInputs = [
    wrapGAppsNoGuiHook
    gobject-introspection
    meson
    ninja
  ];

  buildInputs = [
    gdk-pixbuf
    xapp
  ];

  dependencies =
    with python3Packages;
    [
      pillow
      pygobject3
    ]
    ++ lib.optional (builtins.elem "aiff" thumbnailers) mutagen
    ++ lib.optional (builtins.elem "appimage" thumbnailers) pyelftools
    ++ lib.optional (builtins.elem "mp3" thumbnailers) eyed3
    ++ lib.optional (builtins.elem "vorbiscomment" thumbnailers) mutagen;

  # Let the Python wrapper add `gappsWrapperArgs` to avoid two layers of wrapping.
  dontWrapGApps = true;

  preFixup =
    let
      runtimeBinPackages =
        lib.optional (builtins.elem "appimage" thumbnailers) squashfsTools
        ++ lib.optional (builtins.elem "gimp" thumbnailers) gimp
        ++ lib.optional (builtins.elem "jxl" thumbnailers) libjxl
        ++ lib.optional (builtins.elem "raw" thumbnailers) dcraw;
    in
    ''
      makeWrapperArgs+=(
        "''${gappsWrapperArgs[@]}" \
        --prefix PATH : '${lib.makeBinPath runtimeBinPackages}'
      )
    '';

  pythonImportsCheck = [ "XappThumbnailers" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Thumbnailers for GTK desktop environments";
    homepage = "https://github.com/linuxmint/xapp-thumbnailers";
    changelog = "https://github.com/linuxmint/xapp-thumbnailers/blob/${src.tag}/debian/changelog";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ thunze ];
    platforms = lib.platforms.linux;
  };
}
