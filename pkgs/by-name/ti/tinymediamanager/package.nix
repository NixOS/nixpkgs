{
  alsa-lib,
  autoPatchelfHook,
  chromedriver,
  copyDesktopItems,
  deno,
  ffmpeg,
  fetchFromGitLab,
  fontconfig,
  glib,
  gtk3,
  imagemagick,
  lib,
  libmediainfo,
  libx11,
  libxext,
  libxi,
  libxrender,
  libxtst,
  libzen,
  makeDesktopItem,
  makeWrapper,
  maven,
  pipewire,
  yt-dlp,
  zenity,
  zlib,
  stdenv,
  xz,
}:

let
  sources = {
    "x86_64-linux" = {
      arch = "amd64";
      binaryname = "tinyMediaManager";
    };
    "aarch64-linux" = {
      arch = "arm64";
      binaryname = "tinyMediaManager-arm";
    };
  };

  sysSrc =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
maven.buildMavenPackage rec {
  pname = "tinyMediaManager";
  version = "5.3.2";

  mvnHash = "sha256-1JRA/5bXR/SpVpYBkqTT5RjQTNRzkhxgRoNSWr0O1fg=";

  src = fetchFromGitLab {
    owner = "tinyMediaManager";
    repo = "tinyMediaManager";
    tag = "tinyMediaManager-${version}";
    hash = "sha256-t6QcETlKFkahEzE4oY2InKZkvo7YToaV02ZUCvqT0Uw=";
  };

  # remove other builds from pom.xml to speed up build
  postPatch = ''
    substituteInPlace pom.xml \
      --replace-fail "<descriptor>src/assembly/windows-x64.xml</descriptor>" ""
  '';

  mvnDepsParameters = "-DskipTests -Pdist -DbuildNumber=${version} -Dmaven.buildNumber.skip=true";
  mvnParameters = "-DskipTests -Pdist -DbuildNumber=${version} -Dmaven.buildNumber.skip=true";

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
    imagemagick
    xz
  ];

  buildInputs = [
    alsa-lib
    glib
    gtk3
    libx11
    libxext
    libxi
    libxrender
    libxtst
    zlib
  ];

  strictDeps = true;
  __structuredAttrs = true;

  desktopItems = [
    (makeDesktopItem {
      name = "tinyMediaManager";
      exec = "tinyMediaManager";
      icon = "tinyMediaManager";
      comment = "A media management tool";
      desktopName = "tinyMediaManager";
      genericName = "Media Manager";
      categories = [
        "Video"
        "AudioVideo"
      ];
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall

    # Create destination directory
    mkdir -p $out/opt/tinyMediaManager $out/bin

    tar -xvf "dist/tinyMediaManager-${version}-GIT-linux-${sysSrc.arch}.tar.gz" -C $out/opt/tinyMediaManager --strip-components=1

    ${lib.optionalString (
      sysSrc.binaryname != "tinyMediaManager"
    ) "mv $out/opt/tinyMediaManager/${sysSrc.binaryname} $out/opt/tinyMediaManager/tinyMediaManager -n"}

    makeWrapper $out/opt/tinyMediaManager/tinyMediaManager $out/bin/tinyMediaManager \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          fontconfig
          libmediainfo
          libzen
          pipewire
        ]
      }" \
      --prefix PATH : "${
        lib.makeBinPath [
          chromedriver
          deno
          ffmpeg
          yt-dlp
          zenity
        ]
      }"

    mkdir -p $out/share/pixmaps
    ln -s $out/opt/tinyMediaManager/tmm.png $out/share/pixmaps/tinyMediaManager.png
    for size in 16 32 48 64 128; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick -background none $out/share/pixmaps/tinyMediaManager.png -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/tinyMediaManager.png
    done

    # change startup settings to disable auto updates and use tools from PATH instead the shipped binaries
    substituteInPlace $out/opt/tinyMediaManager/launcher.yml \
    --replace-fail 'jvmOpts:' "jvmOpts:
      - '-Dtmm.noupdate=true'
      - '-Dtmm.useexternaltools=false'"

    runHook postInstall
  '';

  meta = {
    description = "Media management tool";
    homepage = "https://www.tinymediamanager.org/";
    changelog = "https://gitlab.com/tinyMediaManager/tinyMediaManager/-/releases/tinyMediaManager-${version}#changelog";
    # the java code is open source but the binary which invokes the java code is unfree
    # maven downloads this unfree binary
    # the creator said that in the future it could be possible that building from source no longer works when he integrates stronger drm
    # redistributing isn't allowed https://gitlab.com/tinyMediaManager/tinyMediaManager/-/work_items/3333
    license =
      with lib.licenses;
      AND [
        asl20
        unfree
      ];
    maintainers = with lib.maintainers; [ gamebeaker ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "tinyMediaManager";
  };
}
