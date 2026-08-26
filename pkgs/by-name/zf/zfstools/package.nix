{
  lib,
  bundlerEnv,
  stdenv,
  fetchFromGitHub,
  zfs,
  freebsd,
  makeWrapper,
}:
let
  rubyEnv = bundlerEnv {
    name = "zfstools-gems";
    gemdir = ./.;
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "zfstools";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "bdrewery";
    repo = "zfstools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z8umKWn8vUb2lLattbtSn4BCHD0W92hRvuL2uvrgm5o=";
  };

  buildInputs = [ rubyEnv.wrappedRuby ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin/

    cp -R lib $out/

    for f in $out/bin/*; do
      wrapProgram $f \
        --set RUBYLIB $out/lib \
        --prefix PATH : ${if stdenv.hostPlatform.isFreeBSD then freebsd.zfs else zfs}/bin
    done
  '';

  meta = {
    description = "OpenSolaris-compatible auto-snapshotting script for ZFS";
    homepage = "https://github.com/bdrewery/zfstools";
    longDescription = ''
      zfstools is an OpenSolaris-like and compatible auto snapshotting script
      for ZFS, which also supports auto snapshotting mysql databases.
    '';
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})
