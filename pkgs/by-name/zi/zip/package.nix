{
  lib,
  stdenv,
  fetchurl,
  enableNLS ? false,
  libnatspec ? null,
  libiconv,
  fetchpatch,
}:

assert enableNLS -> libnatspec != null;

stdenv.mkDerivation rec {
  pname = "zip";
  version = "3.0";

  src = fetchurl {
    urls = [
      "ftp://ftp.info-zip.org/pub/infozip/src/zip${lib.replaceStrings [ "." ] [ "" ] version}.tgz"
      "https://src.fedoraproject.org/repo/pkgs/zip/zip30.tar.gz/7b74551e63f8ee6aab6fbc86676c0d37/zip30.tar.gz"
    ];
    sha256 = "0sb3h3067pzf3a7mlxn1hikpcjrsvycjcnj9hl9b1c3ykcgvps7h";
  };

  postPatch = ''
    substituteInPlace unix/Makefile --replace 'CC = cc' ""
    substituteInPlace unix/configure --replace-fail "O3" "O2"
  '';

  makefile = "unix/Makefile";
  buildFlags = if stdenv.hostPlatform.isCygwin then [ "cygwin" ] else [ "generic" ];
  installFlags = [
    "prefix=${placeholder "out"}"
    "INSTALL=cp"
  ];

  patches = [
    # Implicit declaration of `closedir` and `opendir` cause dirent detection to fail with clang 16.
    ./fix-implicit-declarations.patch
    # Fixes forward declaration errors with timezone.c
    ./fix-time.h-not-included.patch
    # Without this patch, we get a runtime failures with GCC 14 when building OpenJDK 8:
    #
    #     zip I/O error: No such file or directory
    #     zip error: Could not create output file (was replacing the original zip file)
    #     make[2]: *** [CreateJars.gmk:659: /build/source/build/linux-x86_64-normal-server-release/images/src.zip] Error 1
    #
    # Source: Debian
    ./12-fix-build-with-gcc-14.patch
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-arch/zip/files/zip-3.0-pic.patch?id=d37d095fc7a2a9e4a8e904a7bf0f597fe99df85a";
      hash = "sha256-OXgC9KqiOpH/o/bSabt3LqtoT/xifqfkvpLLPfPz+1c=";
    })
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-arch/zip/files/zip-3.0-no-crypt.patch?id=d37d095fc7a2a9e4a8e904a7bf0f597fe99df85a";
      hash = "sha256-9bwV+uKST828PcRVbICs8xwz9jcIPk26gxLBbiEeta4=";
    })
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-arch/zip/files/zip-3.0-format-security.patch?id=d37d095fc7a2a9e4a8e904a7bf0f597fe99df85a";
      hash = "sha256-YmGKivZ0iFCFmPjVYuOv9D8Y0xG2QnWOpas8gMgoQ3M=";
    })
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-arch/zip/files/zip-3.0-exec-stack.patch?id=d37d095fc7a2a9e4a8e904a7bf0f597fe99df85a";
      hash = "sha256-akJFY+zGijPWCwaAL/xxCN4wQpVFBHkLMo2HowrSn/M=";
    })
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-arch/zip/files/zip-3.0-build.patch?id=d37d095fc7a2a9e4a8e904a7bf0f597fe99df85a";
      hash = "sha256-MiupD7W+sxiRTsB5viKAiI4QeqtZC6VttfJktdt1ucI=";
    })
    # Buffer overflow on Unicode characters in path names
    # https://bugzilla.redhat.com/show_bug.cgi?id=2165653
    # (included among other changes below)
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-arch/zip/files/zip-3.0-zipnote-freeze.patch?id=d37d095fc7a2a9e4a8e904a7bf0f597fe99df85a";
      hash = "sha256-EVr7YS3IytnCRjAYUlkg05GA/kaAY9NRFG7uDt0QLAY=";
    })
  ]
  ++ lib.optionals (enableNLS && !stdenv.hostPlatform.isCygwin) [ ./natspec-gentoo.patch.bz2 ];

  buildInputs =
    lib.optional enableNLS libnatspec ++ lib.optional stdenv.hostPlatform.isCygwin libiconv;

  meta = with lib; {
    description = "Compressor/archiver for creating and modifying zipfiles";
    homepage = "http://www.info-zip.org";
    license = licenses.bsdOriginal;
    platforms = platforms.all;
    maintainers = with maintainers; [ RossComputerGuy ];
    mainProgram = "zip";
  };
}
