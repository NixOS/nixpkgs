{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xxhash";
  version = "0.8.4";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Cyan4973";
    repo = "xxHash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YbWK23lU2/DiKQFPWioMHLgEt8vBtDpjBakT9ds3XpI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeDir = "../build/cmake";

  # The CMake build only installs xxhsum, whereas upstream's Makefile also
  # installs the xxh32sum, xxh64sum, xxh128sum and xxh3sum aliases and their
  # man pages. xxhsum selects its algorithm from argv[0], so symlinks suffice.
  postInstall = ''
    for alias in xxh32sum xxh64sum xxh128sum xxh3sum; do
      ln -sf xxhsum${stdenv.hostPlatform.extensions.executable} \
        "$out/bin/$alias${stdenv.hostPlatform.extensions.executable}"
      ln -sf xxhsum.1 "$out/share/man/man1/$alias.1"
    done
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    echo xxhash > input
    for spec in 0:xxh32sum 1:xxh64sum 2:xxh128sum 3:xxh3sum; do
      algo=''${spec%%:*}
      alias=''${spec#*:}
      expected=$("$out/bin/xxhsum" -H"$algo" input)
      actual=$("$out/bin/$alias" input)
      if [ "$actual" != "$expected" ]; then
        echo "$alias: got '$actual', expected '$expected' (xxhsum -H$algo)"
        exit 1
      fi
      "$out/bin/$alias" input > "input.$alias"
      "$out/bin/$alias" --check "input.$alias"
    done

    runHook postInstallCheck
  '';

  meta = {
    description = "Extremely fast hash algorithm";
    longDescription = ''
      xxHash is an Extremely fast Hash algorithm, running at RAM speed limits.
      It successfully completes the SMHasher test suite which evaluates
      collision, dispersion and randomness qualities of hash functions. Code is
      highly portable, and hashes are identical on all platforms (little / big
      endian).
    '';
    homepage = "https://github.com/Cyan4973/xxHash";
    changelog = "https://github.com/Cyan4973/xxHash/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      bsd2
      gpl2Plus
    ];
    mainProgram = "xxhsum";
    maintainers = [ ];
    platforms = lib.platforms.all;
    pkgConfigModules = [
      "libxxhash"
    ];
  };
})
