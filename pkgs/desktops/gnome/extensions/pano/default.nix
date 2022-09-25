{ lib
, stdenv
, atk
, cogl
, fetchFromGitHub
, glib
, gnome
, gobject-introspection
, gsound
, gtk3
, libgda
, mkYarnModules
, nodePackages
, pango
, substituteAll
, yarn
}:

let
  version = "10";
  uuid = "pano@elhan.io";
  pname = "gnome-shell-extension-pano";

  girpathsPatch = (substituteAll {
    src = ./set-dirpaths.patch;
    gda_path = "${libgda}/lib/girepository-1.0";
    gsound_path = "${gsound}/lib/girepository-1.0";
  });
in
stdenv.mkDerivation rec {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "oae";
    repo = "gnome-shell-pano";
    rev = "v${version}";
    hash = "sha256-1vGiWSXlQ8xheqJsZm3uXCixuLl5NFM2OgPQrzCPhME=";
  };

  nativeBuildInputs = [
    gobject-introspection
    nodePackages.rollup
    nodePackages.yarn
  ];

  buildInputs = [
    atk
    cogl
    glib
    gnome.gnome-shell
    gnome.mutter
    gsound
    gtk3
    libgda
    pango
  ];

  nodeModules =
    mkYarnModules {
      inherit pname version;
      name = "${pname}-modules-${version}";
      packageJSON = "${src}/package.json";
      yarnLock = "${src}/yarn.lock";
      yarnNix = ./yarn.nix;
    };

  postPatch = ''
    substituteInPlace resources/metadata.json \
      --replace '"version": 999' '"version": ${version}'
  '';

  buildPhase =
    let
      dataDirPaths = lib.concatStringsSep ":" [
        "${gnome.gnome-shell}/share/gnome-shell"
        "${gnome.mutter}/lib/mutter-10"
      ];
    in
    ''
      runHook preBuild

      ln -sv "${nodeModules}/node_modules" node_modules
      export XDG_DATA_DIRS="${dataDirPaths}:$XDG_DATA_DIRS"
      yarn --offline build
      # To avoid additional dependencies, we are patching here a generated file
      # created by the previous command.
      patch -d dist -p1 < ${girpathsPatch}

      runHook postBuild
    '';

  passthru = {
    extensionUuid = uuid;
    extensionPortalSlug = "pano";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/gnome-shell/extensions/${uuid}"
    cp -r dist/* "$out/share/gnome-shell/extensions/${uuid}/"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Next-gen Clipboard Manager for Gnome Shell";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.michojel ];
    homepage = "https://github.com/oae/gnome-shell-pano";
  };
}
