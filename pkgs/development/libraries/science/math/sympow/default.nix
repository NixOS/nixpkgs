{ stdenv
, fetchFromGitLab
, makeWrapper
, which
, autoconf
, help2man
, file
, pari
}:

stdenv.mkDerivation rec {
  version = "2.023.5";
  pname = "sympow";

  src = fetchFromGitLab {
    group = "rezozer";
    owner = "forks";
    repo = "sympow";
    rev = "v${version}";
    sha256 = "1c5a2pizgqsf3pjkf7rfj20022ym4ixhrddp8ivs2nbzxwz6qvv9";
  };

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

  meta = with stdenv.lib; {
    description = "Compute special values of symmetric power elliptic curve L-functions";
    license = {
      shortName = "sympow";
      fullName = "Custom, BSD-like. See COPYING file.";
      free = true;
    };
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.linux;
  };
}
