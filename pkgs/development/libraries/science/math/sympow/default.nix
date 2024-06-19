{ lib, stdenv
, fetchFromGitLab
, fetchpatch
, makeWrapper
, which
, autoconf
, help2man
, file
, pari
}:

stdenv.mkDerivation rec {
  version = "2.023.6";
  pname = "sympow";

  src = fetchFromGitLab {
    group = "rezozer";
    owner = "forks";
    repo = "sympow";
    rev = "v${version}";
    sha256 = "132l0xv00ld1svvv9wh99wfra4zzjv2885h2sq0dsl98wiyvi5zl";
  };

  patches = [
    ./clean-extra-logfile-output-from-pari.patch
    (fetchpatch {
      name = "null-terminate-dupdirname.patch";
      url = "https://gitlab.com/rezozer/forks/sympow/-/merge_requests/5.diff";
      sha256 = "sha256-yKjio+qN9teL8L+mb7WOBN/iv545vRIxW20FJU37oO4=";
    })
  ];

  postUnpack = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    makeWrapper
    which
    autoconf
    help2man
    file
    pari
  ];

  configurePhase = ''
    runHook preConfigure
    export PREFIX="$out"
    export VARPREFIX="$out" # see comment on postInstall
    ./Configure # doesn't take any options
    runHook postConfigure
  '';

  # Usually, sympow has 3 levels of caching: statically distributed in /usr/,
  # shared in /var and per-user in ~/.sympow. The shared cache assumes trust in
  # other users and a shared /var is not compatible with nix's approach, so we
  # set VARPREFIX to the read-only $out. This effectively disables shared
  # caching. See https://trac.sagemath.org/ticket/3360#comment:36 and sympow's
  # README for more details on caching.
  # sympow will complain at runtime about the lack of write-permissions on the
  # shared cache. We pass the `-quiet` flag by default to disable this.
  postInstall = ''
    wrapProgram "$out/bin/sympow" --add-flags '-quiet'
  '';

  # Example from the README as a sanity check.
  doInstallCheck = true;
  installCheckPhase = ''
    export HOME="$TMP/home"
    mkdir -p "$HOME"
    "$out/bin/sympow" -sp 2p16 -curve "[1,2,3,4,5]" | grep '8.3705'
  '';

  meta = with lib; {
    description = "Compute special values of symmetric power elliptic curve L-functions";
    mainProgram = "sympow";
    license = {
      shortName = "sympow";
      fullName = "Custom, BSD-like. See COPYING file.";
      free = true;
    };
    maintainers = teams.sage.members;
    platforms = platforms.linux;
  };
}
