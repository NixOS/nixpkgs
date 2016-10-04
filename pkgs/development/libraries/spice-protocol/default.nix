{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "spice-protocol-0.12.12";

  src = fetchurl {
    url = "http://www.spice-space.org/download/releases/${name}.tar.bz2";
    sha256 = "00wx81f2ml62g3maw63jq9w217zym921rdi38h7lpm5m8ckxraqp";
  };

  postInstall = ''
    mkdir -p $out/lib
    ln -sv ../share/pkgconfig $out/lib/pkgconfig
  '';

  meta = with stdenv.lib; {
    description = "Protocol headers for the SPICE protocol";
    homepage = http://www.spice-space.org;
    license = licenses.bsd3;
    maintainers = with maintainers; [ bluescreen303 ];
    platforms = platforms.linux;
  };
}
