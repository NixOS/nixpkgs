{ lib , stdenv , fetchFromGitHub , fetchurl
, alsa-lib , coreutils , file , freetype , gnugrep , libpulseaudio
, libtool , libuuid , openssl , pango , pkg-config , xorg,
}:
let
  owner = "OpenSmalltalk";
  repo = "opensmalltalk-vm";
  version = "202206021410";
in
{ platformDir, vmName, configureFlagsArray, configureFlags }:
stdenv.mkDerivation {
  pname =
    let vmNameNoDots = builtins.replaceStrings [ "." ] [ "-" ] vmName;
    in "opensmalltalk-vm-${platformDir}-${vmNameNoDots}";
  inherit version;

  src = fetchFromGitHub {
    inherit owner repo;
    rev = version;
    hash = "sha256-QqElPiJuqD5svFjWrLz1zL0Tf+pHxQ2fPvkVRn2lyBI=";
  };

  postPatch =
    let
      inherit (builtins) substring;
      url = "https://github.com/${owner}/${repo}.git";
      year = substring 0 4 version;
      month = substring 4 2 version;
      day = substring 6 2 version;
      hour = substring 8 2 version;
      minute = substring 10 2 version;
      date = "${year}-${month}-${day}T${hour}:${minute}+0000";
      commitHash = fetchurl {
        url = "https://api.github.com/repos/${owner}/${repo}/commits/${version}";
        curlOpts = "--header Accept:application/vnd.github.v3.sha";
        hash = "sha256-jhj+bngESaWC69T/fz9rMSFIvcqn7h001QMShMDrnkc=";
      };
      abbrevHash = substring 0 12 (builtins.readFile commitHash);
    in
    ''
      vmVersionDate=$(date -u '+%a %b %-d %T %Y %z' -d "${date}")
      vmVersionFiles=$(sed -n 's/^versionfiles="\(.*\)"/\1/p' ./scripts/updateSCCSVersions)
      for vmVersionFile in $vmVersionFiles; do
        substituteInPlace "$vmVersionFile" \
          --replace "\$Date\$" "\$Date: ''${vmVersionDate} \$" \
          --replace "\$URL\$" "\$URL: ${url} \$" \
          --replace "\$Rev\$" "\$Rev: ${version} \$" \
          --replace "\$CommitHash\$" "\$CommitHash: ${abbrevHash} \$"
      done
      patchShebangs --build ./building/${platformDir} scripts
      substituteInPlace ./platforms/unix/config/mkmf \
        --replace "/bin/rm" "rm"
      substituteInPlace ./platforms/unix/config/configure \
        --replace "/usr/bin/file" "file" \
        --replace "/usr/bin/pkg-config" "pkg-config" \
    '';

  preConfigure = ''
    cd building/${platformDir}/${vmName}/build
    ../../../../scripts/checkSCCSversion && exit 1
    cp ../plugins.int ../plugins.ext .
    configureFlagsArray=${configureFlagsArray}
  '';

  configureScript = "../../../../platforms/unix/config/configure";

  inherit configureFlags;

  buildFlags = "all";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    file
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    freetype
    libpulseaudio
    libtool
    libuuid
    openssl
    pango
    xorg.libX11
    xorg.libXrandr
  ];

  postInstall = ''
    rm "$out/squeak"
    cd "$out/bin"
    BIN="$(find ../lib -type f -name squeak)"
    for f in $(find . -type f); do
      rm "$f"
      ln -s "$BIN" "$f"
    done
  '';
}
