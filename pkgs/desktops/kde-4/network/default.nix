args: with args;

stdenv.mkDerivation {
  name = "kdenetwork-4.0.0";
  
  src = fetchurl {
    url = http://download.kde.org/stable/4.0.0/src/kdenetwork-4.0.0.tar.bz2;
    md5 = "f362bd34b589800845abfb99589d4cfc";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace sqlite libidn];
}
