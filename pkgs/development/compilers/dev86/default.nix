{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "dev86-0.16.17";
  src = fetchurl {
    url = http://homepage.ntlworld.com/robert.debath/dev86/Dev86src-0.16.17.tar.gz;
    md5 = "e7bbfdbe61c2fb964994a087e29b0087";
  };

  patches = [ ./dev86-0.16.17-noelks-1.patch ];
  
  preBuild = "
    makeFlags=\"PREFIX=$out\"
  ";

  meta = {
    description = "Linux 8086 development environment";
    homepage = http://www.debath.co.uk/;
  };
}
