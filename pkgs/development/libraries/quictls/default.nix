{
  buildPackages
, cryptodev
, enableSSL2 ? false
, enableSSL3 ? false
, fetchFromGitHub
, lib
, makeWrapper
, perl
, removeReferencesTo
, static ? stdenv.hostPlatform.isStatic
, stdenv
, withCryptodev ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quictls";
  version = "3.1.5-quic1";

  src = fetchFromGitHub {
    owner = "quictls";
    repo = "openssl";
    rev = "cb6841b741544bfd8868c1641ce96a934985509e";
    hash = "sha256-oR46jefarUGmBYjjpEvtKFzIOgSXSy58cLdX+P5ocA8=";
  };

  patches = [
    ../openssl/3.0/nix-ssl-cert-file.patch

    # openssl will only compile in KTLS if the current kernel supports it.
    # This patch disables build-time detection.
    ../openssl/3.0/openssl-disable-kernel-detection.patch

    (if stdenv.hostPlatform.isDarwin
    then ../openssl/use-etc-ssl-certs-darwin.patch
    else ../openssl/use-etc-ssl-certs.patch)
  ];

  postPatch = ''
    patchShebangs Configure
  ''
  # config is a configure script which is not installed.
  + ''
    substituteInPlace config --replace '/usr/bin/env' '${buildPackages.coreutils}/bin/env'
  '' + lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace crypto/async/arch/async_posix.h \
      --replace '!defined(__ANDROID__) && !defined(__OpenBSD__)' \
                '!defined(__ANDROID__) && !defined(__OpenBSD__) && 0'
  '';

  nativeBuildInputs = [
    makeWrapper
    perl
    removeReferencesTo
  ];

  buildInputs = lib.optionals withCryptodev [
    cryptodev
  ];

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  setOutputFlags = false;

  separateDebugInfo =
    !stdenv.hostPlatform.isDarwin &&
    !(stdenv.hostPlatform.useLLVM or false) &&
    stdenv.cc.isGNU;

  # TODO(@Ericson2314): Improve with mass rebuild
  configurePlatforms = [ ];
  configureScript = {
    armv5tel-linux = "./Configure linux-armv4 -march=armv5te";
    armv6l-linux = "./Configure linux-armv4 -march=armv6";
    armv7l-linux = "./Configure linux-armv4 -march=armv7-a";
    x86_64-darwin = "./Configure darwin64-x86_64-cc";
    aarch64-darwin = "./Configure darwin64-arm64-cc";
    x86_64-linux = "./Configure linux-x86_64";
    x86_64-solaris = "./Configure solaris64-x86_64-gcc";
    riscv64-linux = "./Configure linux64-riscv64";
    mips64el-linux =
      if stdenv.hostPlatform.isMips64n64
      then "./Configure linux64-mips64"
      else if stdenv.hostPlatform.isMips64n32
      then "./Configure linux-mips64"
      else throw "unsupported ABI for ${stdenv.hostPlatform.system}";
  }.${stdenv.hostPlatform.system} or (
    if stdenv.hostPlatform == stdenv.buildPlatform
    then "./config"
    else if stdenv.hostPlatform.isBSD && stdenv.hostPlatform.isx86_64
    then "./Configure BSD-x86_64"
    else if stdenv.hostPlatform.isBSD && stdenv.hostPlatform.isx86_32
    then "./Configure BSD-x86" + lib.optionalString stdenv.hostPlatform.isElf "-elf"
    else if stdenv.hostPlatform.isBSD
    then "./Configure BSD-generic${toString stdenv.hostPlatform.parsed.cpu.bits}"
    else if stdenv.hostPlatform.isMinGW
    then "./Configure mingw${lib.optionalString
                                   (stdenv.hostPlatform.parsed.cpu.bits != 32)
                                   (toString stdenv.hostPlatform.parsed.cpu.bits)}"
    else if stdenv.hostPlatform.isLinux
    then "./Configure linux-generic${toString stdenv.hostPlatform.parsed.cpu.bits}"
    else if stdenv.hostPlatform.isiOS
    then "./Configure ios${toString stdenv.hostPlatform.parsed.cpu.bits}-cross"
    else
      throw "Not sure what configuration to use for ${stdenv.hostPlatform.config}"
  );

  # OpenSSL doesn't like the `--enable-static` / `--disable-shared` flags.
  dontAddStaticConfigureFlags = true;

  configureFlags = [
    "shared" # "shared" builds both shared and static libraries
    "--libdir=lib"
    "--openssldir=etc/ssl"
  ] ++ lib.optionals withCryptodev [
    "-DHAVE_CRYPTODEV"
    "-DUSE_CRYPTODEV_DIGESTS"
  ] ++ lib.optional enableSSL2 "enable-ssl2"
  ++ lib.optional enableSSL3 "enable-ssl3"
  # We select KTLS here instead of the configure-time detection (which we patch out).
  # KTLS should work on FreeBSD 13+ as well, so we could enable it if someone tests it.
  ++ lib.optional (stdenv.isLinux && lib.versionAtLeast finalAttrs.version "3.0.0") "enable-ktls"
  ++ lib.optional stdenv.hostPlatform.isAarch64 "no-afalgeng"
  # OpenSSL needs a specific `no-shared` configure flag.
  # See https://wiki.openssl.org/index.php/Compilation_and_Installation#Configure_Options
  # for a comprehensive list of configuration options.
  ++ lib.optional static "no-shared"
  # This introduces a reference to the CTLOG_FILE which is undesired when
  # trying to build binaries statically.
  ++ lib.optional static "no-ct";

  makeFlags = [
    "MANDIR=$(man)/share/man"
    # This avoids conflicts between man pages of openssl subcommands (for
    # example 'ts' and 'err') man pages and their equivalent top-level
    # command in other packages (respectively man-pages and moreutils).
    # This is done in ubuntu and archlinux, and possiibly many other distros.
    "MANSUFFIX=ssl"
  ];

  enableParallelBuilding = true;

  postInstall = (if static then ''
    # OPENSSLDIR has a reference to self
    ${removeReferencesTo}/bin/remove-references-to -t $out $out/lib/*.a
  '' else ''
    # If we're building dynamic libraries, then don't install static
    # libraries.
    if [ -n "$(echo $out/lib/*.so $out/lib/*.dylib $out/lib/*.dll)" ]; then
        rm "$out/lib/"*.a
    fi
  '') + ''
    mkdir -p $bin
    mv $out/bin $bin/bin

    # c_rehash is a legacy perl script with the same functionality
    # as `openssl rehash`
    # this wrapper script is created to maintain backwards compatibility without
    # depending on perl
    makeWrapper $bin/bin/openssl $bin/bin/c_rehash \
      --add-flags "rehash"

    mkdir $dev
    mv $out/include $dev/
    # remove dependency on Perl at runtime
    rm -r $out/etc/ssl/misc
    rmdir $out/etc/ssl/{certs,private}
  '';

  postFixup = lib.optionalString (!stdenv.hostPlatform.isWindows) ''
    # Check to make sure the main output doesn't depend on perl
    if grep -r '${buildPackages.perl}' $out; then
      echo "Found an erroneous dependency on perl ^^^" >&2
      exit 1
    fi
  '';

  meta = {
    changelog = "https://github.com/quictls/openssl/blob/${finalAttrs.src.rev}/CHANGES.md";
    description = "TLS/SSL and crypto library with QUIC APIs";
    homepage = "https://quictls.github.io";
    license = lib.licenses.openssl;
    maintainers = with lib.maintainers; [ izorkin ];
    platforms = lib.platforms.all;
  };
})
