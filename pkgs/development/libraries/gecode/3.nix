{ stdenv, fetchurl, bash, perl }:

stdenv.mkDerivation rec {
  name = "gecode-${version}";
  version = "3.7.3";

  src = fetchurl {
    url = "http://www.gecode.org/download/${name}.tar.gz";
    sha256 = "0k45jas6p3cyldgyir1314ja3174sayn2h2ly3z9b4dl3368pk77";
  };

  nativeBuildInputs = [ bash perl ];

  preConfigure = "patchShebangs configure";

  meta = with stdenv.lib; {
    license = licenses.mit;
    homepage = https://www.gecode.org;
    description = "Toolkit for developing constraint-based systems";
    platforms = platforms.all;
    maintainers = [ maintainers.manveru ];
  };
}
