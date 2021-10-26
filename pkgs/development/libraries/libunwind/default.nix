{ stdenv, lib, fetchurl, fetchpatch, autoreconfHook, xz, coreutils }:

stdenv.mkDerivation rec {
  pname = "libunwind";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://savannah/libunwind/${pname}-${version}.tar.gz";
    sha256 = "0dc46flppifrv2z0mrdqi60165ghxm1wk0g47vcbyzjdplqwjnfz";
  };

  patches = [
    ./backtrace-only-with-glibc.patch

    (fetchpatch {
      # upstream build fix against -fno-common compilers like >=gcc-10
      url = "https://github.com/libunwind/libunwind/commit/29e17d8d2ccbca07c423e3089a6d5ae8a1c9cb6e.patch";
      sha256 = "1angwfq6h0jskg6zx8g6w9min38g5mgmrcbppcy5hqn59cgsxbw0";
    })
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace configure.ac --replace "-lgcc_s" "-lgcc_eh"
  '';

  nativeBuildInputs = [ autoreconfHook ];

  outputs = [ "out" "dev" "devman" ];

  # Without latex2man, no man pages are installed despite being
  # prebuilt in the source tarball.
  configureFlags = [ "LATEX2MAN=${coreutils}/bin/true" ];

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
    platforms = platforms.linux;
    badPlatforms = [ "riscv32-linux" "riscv64-linux" ];
    license = licenses.mit;
  };
}
