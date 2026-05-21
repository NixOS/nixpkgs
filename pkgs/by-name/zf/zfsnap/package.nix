{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.0.0-beta3";
  pname = "zfsnap";

  src = fetchFromGitHub {
    owner = "zfsnap";
    repo = "zfsnap";
    rev = "v${finalAttrs.version}";
    sha256 = "0670a5sghvqx32c9gfsird15mg9nqcvwxsrfcjrwc0sj7br9bd2g";
  };

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    # Use zfs binaries from PATH, because often the zfs package from nixpkgs is
    # not the one that should be used
    substituteInPlace share/zfsnap/core.sh \
      --replace "ZFS_CMD='/sbin/zfs'" "ZFS_CMD='zfs'" \
      --replace "ZPOOL_CMD='/sbin/zpool'" "ZPOOL_CMD='zpool'"

    substituteInPlace sbin/zfsnap.sh \
      --replace "/bin/ls" "${coreutils}/bin/ls"
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv sbin/zfsnap.sh $out/bin/zfsnap
    mv share $out
    installManPage man/*/*
    installShellCompletion completion/*.{bash,zsh}
  '';

  meta = {
    description = "Portable, performant script to make rolling ZFS snapshots easy";
    mainProgram = "zfsnap";
    homepage = "https://github.com/zfsnap/zfsnap";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ woffs ];
    platforms = lib.platforms.linux;
  };
})
