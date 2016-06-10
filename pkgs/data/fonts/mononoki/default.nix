{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "mononoki-${version}";
  version = "1.2";

  src = fetchurl {
    url = "https://github.com/madmalik/mononoki/releases/download/${version}/mononoki.zip";
    sha256 = "0n66bnn2i776fbky14qjijwsbrja9yzc1xfsmvz99znvcdvflafg";
  };

  buildInputs = [ unzip ];
  phases = [ "unpackPhase" ];

  unpackPhase = ''
    mkdir -p $out/share/fonts/mononoki
    unzip $src -d $out/share/fonts/mononoki
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/madmalik/mononoki;
    description = "A font for programming and code review";
    license = licenses.ofl;
    maintainers = [ maintainers.hiberno ];
    platforms = platforms.all;
  };
}
