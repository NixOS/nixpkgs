{
  lib,
  stdenv,
  fetchurl,
  fetchDebianPatch,
  bzip2,
  enableNLS ? false,
  libnatspec,
}:

stdenv.mkDerivation rec {
  pname = "unzip";
  version = "6.0";

  src = fetchurl {
    url = "mirror://sourceforge/infozip/unzip${lib.replaceStrings [ "." ] [ "" ] version}.tar.gz";
    sha256 = "0dxx11knh3nk95p2gg2ak777dd11pr7jx5das2g49l262scrcv83";
  };

  hardeningDisable = [
    "format"
    "strictflexarrays3"
  ];

  patchFlags = [
    "-p1"
    "-F3"
  ];

  patches = [
    ./CVE-2014-8139.diff
    ./CVE-2014-8140.diff
    ./CVE-2014-8141.diff
    ./CVE-2014-9636.diff
    ./CVE-2015-7696.diff
    ./CVE-2015-7697.diff
    (fetchDebianPatch {
      inherit pname version;
      debianRevision = "31";
      patch = "cve-2014-9913-unzip-buffer-overflow.patch";
      hash = "sha256-UV0n33iLzTd7irfOZIm1GsHpIHj8OFQOyMRgpla0vy4=";
    })
    (fetchDebianPatch {
      inherit pname version;
      debianRevision = "31";
      patch = "cve-2016-9844-zipinfo-buffer-overflow.patch";
      hash = "sha256-9POOO+jJpa4yF2ovBN42UeGdRSoKLAXqQJeb6CR1wQQ=";
    })
    ./CVE-2018-18384.patch
    ./dont-hardcode-cc.patch
    (fetchDebianPatch {
      inherit pname version;
      debianRevision = "31";
      patch = "cve-2018-1000035-unzip-buffer-overflow.patch";
      hash = "sha256-d6kewEGQZXzKftFqN5MoqVhM6g1uTM5knzukcZCGY28=";
    })
    (fetchurl {
      url = "https://github.com/madler/unzip/commit/41beb477c5744bc396fa1162ee0c14218ec12213.patch";
      name = "CVE-2019-13232-1.patch";
      sha256 = "04jzd6chg9fw4l5zadkfsrfm5llrd7vhd1dgdjjd29nrvkrjyn14";
    })
    (fetchurl {
      url = "https://github.com/madler/unzip/commit/47b3ceae397d21bf822bc2ac73052a4b1daf8e1c.patch";
      name = "CVE-2019-13232-2.patch";
      sha256 = "0iy2wcjyvzwrjk02iszwcpg85fkjxs1bvb9isvdiywszav4yjs32";
    })
    (fetchurl {
      url = "https://github.com/madler/unzip/commit/6d351831be705cc26d897db44f878a978f4138fc.patch";
      name = "CVE-2019-13232-3.patch";
      sha256 = "1jvs7dkdqs97qnsqc6hk088alhv8j4c638k65dbib9chh40jd7pf";
    })
    (fetchDebianPatch {
      inherit pname version;
      debianRevision = "31";
      patch = "initialize-the-symlink-flag.patch";
      hash = "sha256-C+QiqxKRK9xehfDMCrMrZRJsI3ycF1jdv+vYTITUzNI=";
    })
    (fetchDebianPatch {
      inherit pname version;
      debianRevision = "31";
      patch = "cve-2022-0529-and-cve-2022-0530.patch";
      hash = "sha256-s9q/GDbaq6gkKFUwBoBShgQHp/N3I0LV0ePNtodKJd8=";
    })
    # Clang 16 makes implicit declarations an error by default for C99 and newer, causing the
    # configure script to fail to detect errno and the directory libraries on Darwin.
    ./implicit-declarations-fix.patch
    ./CVE-2021-4217.patch
    # The next two patches are prerequisites for can-2026-2034440.patch, but are
    # also useful in their own right.
    (fetchDebianPatch {
      # https://bugs.debian.org/689212
      inherit pname version;
      debianRevision = "31";
      patch = "fix-uid-gid-handling.patch";
      hash = "sha256-jMLUyZcEdGxiz/RmhJbHKaZgH6MNno2WHCAx14aRTDM=";
    })
    (fetchDebianPatch {
      # https://bugs.debian.org/842993
      inherit pname version;
      debianRevision = "31";
      patch = "restore-unix-timestamps-accurately.patch";
      hash = "sha256-nD3CZkz2+DoOIBCngyK5Aw1UHPfZwxIzMxA+ouAe6gE=";
    })
    # The three patches below patch this vulnerability:
    # https://www.debian.org/security/2026/dsa-6440
    (fetchDebianPatch {
      # https://bugs.debian.org/1142904
      inherit pname version;
      debianRevision = "31";
      patch = "can-2026-2034440.patch";
      hash = "sha256-PrJ5DhVFTIUDTEtF5UC+x2a847oM5SwYz6OdlG95fZw=";
    })
    (fetchDebianPatch {
      # https://bugs.debian.org/1142905
      inherit pname version;
      debianRevision = "31";
      patch = "can-2026-2034443.patch";
      hash = "sha256-lMrngOnBLGFJEzI0oTdYwWX+AMxL7d9951vpjQUpvLc=";
    })
    (fetchDebianPatch {
      # https://bugs.debian.org/1142906
      inherit pname version;
      debianRevision = "31";
      patch = "can-2026-2034442.patch";
      hash = "sha256-3rXixqyb0WmUnBIoejXa2J/xodxoe9B87ql6E6K8r3s=";
    })
  ]
  ++ lib.optional enableNLS (fetchurl {
    url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-arch/unzip/files/unzip-6.0-natspec.patch?id=56bd759df1d0c750a065b8c845e93d5dfa6b549d";
    name = "unzip-6.0-natspec.patch";
    sha256 = "67ab260ae6adf8e7c5eda2d1d7846929b43562943ec4aff629bd7018954058b1";
  });

  # gcc-15 uses c23 standard, which removed non-prototype function declarations.
  postPatch = ''
    sed -i '/localtime()/ d' unix/unxcfg.h
  '';

  nativeBuildInputs = [ bzip2 ];
  buildInputs = [ bzip2 ] ++ lib.optional enableNLS libnatspec;

  makefile = "unix/Makefile";

  env = {
    NIX_LDFLAGS = toString (
      [
        "-lbz2"
      ]
      ++ lib.optionals enableNLS [
        "-lnatspec"
      ]
    );
  };

  buildFlags = [
    "generic"
    "D_USE_BZ2=-DUSE_BZIP2"
    "L_BZ2=-lbz2"
  ]
  # `lchmod` is not available on Linux, so we remove it to fix "not supported" errors (when the zip file contains symlinks).
  # Alpine (musl) and Debian (glibc) also add this flag.
  ++ lib.optionals stdenv.hostPlatform.isLinux [ "LOCAL_UNZIP=-DNO_LCHMOD" ];

  preConfigure = ''
    sed -i -e 's@CF="-O3 -Wall -I. -DASM_CRC $(LOC)"@CF="-O3 -Wall -I. -DASM_CRC -DLARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 $(LOC)"@' unix/Makefile
  '';

  installFlags = [
    "prefix=${placeholder "out"}"
  ];

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "http://www.info-zip.org";
    description = "Extraction utility for archives compressed in .zip format";
    license = lib.licenses.info-zip;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    mainProgram = "unzip";
  };
}
