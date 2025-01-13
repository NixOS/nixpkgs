{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  unzip,
  gdc,
  SDL,
  SDL_mixer,
  bulletml,
}:

let
  debianPatch =
    patchname: hash:
    fetchpatch {
      name = "${patchname}.patch";
      url = "https://sources.debian.org/data/main/t/tumiki-fighters/0.2.dfsg1-9/debian/patches/${patchname}.patch";
      sha256 = hash;
    };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "tumiki-fighters";
  version = "0.21";

  src = fetchurl {
    url = "http://abagames.sakura.ne.jp/windows/tf${
      lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }.zip";
    sha256 = "0djykfc1r8ysapklm621h89ana1c4qzc1m5nr9bqw4iccnmvwk3p";
  };

  patches = [
    (debianPatch "imports" "1l3kc67b43gdi139cpz5cka1nkn0pjp9mrgrrxlmr0liwx2aryhn")
    (debianPatch "fixes" "1iy1a5vii6yz9zdlk2bcj6gkj4y25hn9y2fczz15jpqd9r2zm603")
    (debianPatch "directories" "0kmv0s7jgr693fzrkjsmz4dnicc4w7njanxm2la3cf4vmgdyipmm")
    (debianPatch "windowed" "1wp74l0bi8wq85pcxnmkwrlfmlf09im95n27pxgz082lhwf2ksy1")
    (debianPatch "dotfile" "0d8x519bclh41j992qn6ijzfcrgacb79px6zjd1awypkwyc0j2p6")
    (debianPatch "makefile" "11xf2b31kjyps53jfryv82dv0g6q0smc9xgp8imrbr93mzi51vf0")
    (debianPatch "window-resizing" "1dm79d0yisa8zs5fr89y3wq2kzd3khcaxs0la8lhncvkqbd4smx8")
    (debianPatch "dlang_v2" "1isnvbl3bjnpyphji8k3fl0yd1z4869h0lai143vpwgj6518lpg4")
    (debianPatch "gdc-8" "1md0zwmv50jnak5g9d93bglv9v4z41blinjii6kv3vmgjnajapzj")
  ];

  postPatch = ''
    for f in \
      src/abagames/tf/barragemanager.d \
      src/abagames/util/sdl/sound.d \
      src/abagames/util/sdl/texture.d \
      src/abagames/tf/enemyspec.d \
      src/abagames/tf/field.d \
      src/abagames/tf/stagemanager.d \
      src/abagames/tf/tumikiset.d
    do
      substituteInPlace $f \
        --replace "/usr/" "$out/"
    done
  '';

  nativeBuildInputs = [
    unzip
    gdc
  ];

  buildInputs = [
    SDL
    SDL_mixer
    bulletml
  ];

  installPhase = ''
    install -Dm755 tumiki-fighters $out/bin/tumiki-fighters
    mkdir -p $out/share/games/tumiki-fighters
    cp -r barrage sounds enemy field stage tumiki $out/share/games/tumiki-fighters/
  '';

  meta = with lib; {
    homepage = "http://www.asahi-net.or.jp/~cs8k-cyu/windows/tf_e.html";
    description = "Sticky 2D shooter";
    mainProgram = "tumiki-fighters";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
})
