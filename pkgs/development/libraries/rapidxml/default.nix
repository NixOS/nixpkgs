{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "rapidxml";
  version = "1.13";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.zip";
    sha256 = "0w9mbdgshr6sh6a5jr10lkdycjyvapbj7wxwz8hbp0a96y3biw63";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/include/${pname}
    cp * $out/include/${pname}
  '';

  meta = with lib; {
    description = "Fast XML DOM-style parser in C++";
    homepage = "https://rapidxml.sourceforge.net/";
    license = licenses.boost;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cpages ];
  };
}
