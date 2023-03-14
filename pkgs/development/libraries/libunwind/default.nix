{ stdenv, lib, fetchurl, fetchpatch, autoreconfHook, xz, buildPackages }:

stdenv.mkDerivation rec {
  pname = "libunwind";
  version = "1.6.2";

  src = fetchurl {
    url = "mirror://savannah/libunwind/${pname}-${version}.tar.gz";
    sha256 = "sha256-SmrsZmmR+0XQiJxErt6K1usQgHHDVU/N/2cfnJR5SXY=";
  };

  patches = [
    # Fix for aarch64 and non-4K pages. Remove once upgraded past 1.6.2.
    (fetchpatch {
      url = "https://github.com/libunwind/libunwind/commit/e85b65cec757ef589f28957d0c6c21c498a03bdf.patch";
      sha256 = "1lnlygvhqrdrjgw303pg2k2k4ms4gaghpjsgmhk47q83vy1yjwfg";
    })
  ];

  postPatch = if (stdenv.cc.isClang || stdenv.hostPlatform.isStatic) then ''
    substituteInPlace configure.ac --replace "-lgcc_s" ""
  '' else lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace configure.ac --replace "-lgcc_s" "-lgcc_eh"
  '';

  nativeBuildInputs = [ autoreconfHook ];

  outputs = [ "out" "dev" "devman" ];

  # Without latex2man, no man pages are installed despite being
  # prebuilt in the source tarball.
  configureFlags = [ "LATEX2MAN=${buildPackages.coreutils}/bin/true" ];

  propagatedBuildInputs = [ xz ];

  postInstall = ''
    find $out -name \*.la | while read file; do
      sed -i 's,-llzma,${xz.out}/lib/liblzma.la,' $file
    done
  '';

  doCheck = false; # fails

  meta = with lib; {
    homepage = "https://www.nongnu.org/libunwind";
    description = "A portable and efficient API to determine the call-chain of a program";
    maintainers = with maintainers; [ orivej ];
    # https://github.com/libunwind/libunwind#libunwind
    platforms = [ "aarch64-linux" "armv5tel-linux" "armv6l-linux" "armv7a-linux" "armv7l-linux" "i686-freebsd13" "i686-linux" "mips64el-linux" "mipsel-linux" "powerpc64-linux" "powerpc64le-linux" "riscv64-linux" "x86_64-freebsd13" "x86_64-linux" "x86_64-solaris" ];
    license = licenses.mit;
  };
}
