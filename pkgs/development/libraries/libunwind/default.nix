{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  buildPackages,
  xz,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libunwind";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "libunwind";
    repo = "libunwind";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MsUReXFHlj15SgEZHOYhdSfAbSeVVl8LCi4NnUwvhpw=";
  };

  postPatch =
    if (stdenv.cc.isClang || stdenv.hostPlatform.isStatic) then
      ''
        substituteInPlace configure.ac --replace "-lgcc_s" ""
      ''
    else
      lib.optionalString stdenv.hostPlatform.isMusl ''
        substituteInPlace configure.ac --replace "-lgcc_s" "-lgcc_eh"
      '';

  nativeBuildInputs = [ autoreconfHook ];

  outputs = [
    "out"
    "dev"
    "devman"
  ];

  configureFlags = [
    # Starting from 1.8.1 libunwind installs testsuite by default.
    # As we don't run the tests we disable it (this also fixes circular
    # reference install failure).
    "--disable-tests"
    # Without latex2man, no man pages are installed despite being
    # prebuilt in the source tarball.
    "LATEX2MAN=${buildPackages.coreutils}/bin/true"
  ];

  propagatedBuildInputs = [ xz ];

  enableParallelBuilding = true;

  postInstall = ''
    find $out -name \*.la | while read file; do
      sed -i 's,-llzma,${xz.out}/lib/liblzma.la,' $file
    done
  '';

  doCheck = false; # fails

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
    versionCheck = true;
  };

  meta = with lib; {
    homepage = "https://www.nongnu.org/libunwind";
    description = "Portable and efficient API to determine the call-chain of a program";
    maintainers = with maintainers; [ orivej ];
    pkgConfigModules = [
      "libunwind"
      "libunwind-coredump"
      "libunwind-generic"
      "libunwind-ptrace"
      "libunwind-setjmp"
    ];
    # https://github.com/libunwind/libunwind#libunwind
    platforms = [
      "aarch64-linux"
      "armv5tel-linux"
      "armv6l-linux"
      "armv7a-linux"
      "armv7l-linux"
      "i686-freebsd"
      "i686-linux"
      "loongarch64-linux"
      "mips64el-linux"
      "mipsel-linux"
      "powerpc-linux"
      "powerpc64-linux"
      "powerpc64le-linux"
      "riscv64-linux"
      "s390x-linux"
      "x86_64-freebsd"
      "x86_64-linux"
      "x86_64-solaris"
    ];
    license = licenses.mit;
  };
})
