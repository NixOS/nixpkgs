{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "libutp";
  version = "unstable-2018-05-15";

  src = fetchFromGitHub {
    owner = "bittorrent";
    repo = pname;
    rev = "2b364cbb0650bdab64a5de2abb4518f9f228ec44";
    sha256 = "0yaiqksimnhwh14kmsq4kcyq6662b4ask36ni6p5n14dbyq1h2s6";
  };

  installPhase = ''
    mkdir -p $out/lib $out/include/libutp
    cp libutp.a libutp.so $out/lib/
    cp *.h $out/include/libutp/
  '';

  meta = with lib; {
    description = "uTorrent Transport Protocol library";
    homepage = "https://github.com/bittorrent/libutp";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.onny ];
  };
}
