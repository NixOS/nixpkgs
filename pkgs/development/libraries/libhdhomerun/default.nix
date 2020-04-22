{ stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation {
  pname = "libhdhomerun";
  version = "20200303";

  src = fetchFromGitHub {
    owner = "Silicondust";
    repo = "libhdhomerun";
    # repo does not use tagged releases
    rev = "64aa1606b58e9654385333031c5d7bf02989bf49";
    sha256 = "0151n9f845k7l3ha2bwr67n4csj83qmygmlhy1zf8q9hvp6y8ia4";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  patches = [
    # https://github.com/Silicondust/libhdhomerun/pull/27
    (fetchpatch {
      url = "https://github.com/Silicondust/libhdhomerun/commit/2845a5d9a13d51f0028087abd0c745bad53a1390.patch";
      sha256 = "1jsy69447fsiwg3qmlx84zbxxh28pzknjz1h5wr54pmmwqlhcjp2";
    })
  ];

  installPhase = ''
    mkdir -p $out/{bin,lib,include/hdhomerun}
    install -Dm444 libhdhomerun${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib
    install -Dm555 hdhomerun_config $out/bin
    cp *.h $out/include/hdhomerun
  '';

  meta = with stdenv.lib; {
    description = "Implements the libhdhomerun protocol for use with Silicondust HDHomeRun TV tuners";
    homepage = "https://github.com/Silicondust/libhdhomerun";
    repositories.git = "https://github.com/Silicondust/libhdhomerun.git";
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ maintainers.titanous ];
  };
}
