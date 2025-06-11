{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  cmake,
  ncurses6,
  runtimeShell,
}:

let
  savesDir = "~/.umoria";
in
stdenv.mkDerivation rec {
  pname = "umoria";
  version = "5.7.15";

  src = fetchFromGitHub {
    owner = "dungeons-of-moria";
    repo = "umoria";
    rev = "v${version}";
    sha256 = "sha256-1j4QkE33UcTzM06qAjk1/PyK5uNA7E/kyDe3bZcFKUM=";
  };

  patches = [
    # gcc-13 support: https://github.com/dungeons-of-moria/umoria/pull/58
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/dungeons-of-moria/umoria/commit/71dad4103b5c8f3e1f7723eb14d14425755e7ba5.patch";
      hash = "sha256-5Ka3NTe0sJk6kReG+1hwZPEuB3R+Nn+2zxUXuOG7hm0=";
    })
    # clang support: https://github.com/dungeons-of-moria/umoria/pull/72
    (fetchpatch {
      name = "clang.patch";
      url = "https://github.com/dungeons-of-moria/umoria/commit/f294e5880cd21d25c11eee820d629f4ff504ad10.patch";
      hash = "sha256-se8G4n8codXA9gznyIy337IFyznLnpCY7KA6UryZDls=";
    })
    (fetchpatch {
      name = "clang-p2.patch";
      url = "https://github.com/dungeons-of-moria/umoria/commit/bf513b05dc34405665a8dd1386292cd70307dce0.patch";
      hash = "sha256-FXj5Y4G0gnXheXC2bmRbIx3a1IixJ/aGfRMxl2S/vqM=";
    })
    # clang crash fix: https://github.com/dungeons-of-moria/umoria/pull/87
    (fetchpatch {
      name = "clang-crash.patch";
      url = "https://github.com/dungeons-of-moria/umoria/commit/d073e8f867c49bb04a02c1995dd3efb0c5cc07e7.patch";
      hash = "sha256-4uwO8fe4M5jt0IM0z6MjO8UaEezweMA5L+pusel4VUU=";
    })
  ];

  postPatch = ''
    # Do not apply blanket -Werror as it tends to fail on fresher
    # toolchains.
    substituteInPlace CMakeLists.txt --replace-fail '-Werror")' '-Wno-error")'
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ ncurses6 ];
  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/data $out/bin
    cp -r umoria/data/* $out/data
    cp umoria/umoria $out/.umoria-unwrapped

    mkdir -p $out/bin
    cat <<EOF >$out/bin/umoria
    #! ${runtimeShell} -e

    RUNDIR=\$(mktemp -d)

    # Print the directory, so users have access to dumps, and let the system
    # take care of cleaning up temp files.
    echo "Running umoria in \$RUNDIR"

    cd \$RUNDIR
    ln -sn $out/data \$RUNDIR/data

    mkdir -p ${savesDir}
    [[ ! -f ${savesDir}/scores.dat ]] && touch ${savesDir}/scores.dat
    ln -s ${savesDir}/scores.dat scores.dat

    if [ \$# -eq 0 ]; then
       $out/.umoria-unwrapped ${savesDir}/game.sav
    else
       $out/.umoria-unwrapped "\$@"
    fi
    EOF

    chmod +x $out/bin/umoria

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://umoria.org/";
    description = "Dungeons of Moria - the original roguelike";
    mainProgram = "umoria";
    longDescription = ''
      The Dungeons of Moria is a single player dungeon simulation originally written
      by Robert Alan Koeneke, with its first public release in 1983.
      The game was originally developed using VMS Pascal before being ported to the C
      language by James E. Wilson in 1988, and released a Umoria.
    '';
    platforms = platforms.unix;
    badPlatforms = [ "aarch64-darwin" ];
    maintainers = with maintainers; [
      aciceri
      kenran
    ];
    license = licenses.gpl3Plus;
  };
}
