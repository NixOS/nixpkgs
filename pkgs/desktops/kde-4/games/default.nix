args: with args;

stdenv.mkDerivation {
  name = "kdegames-4.0.0";
  
  src = fetchurl {
    url = mirror://kde/stable/4.0/src/kdegames-4.0.0.tar.bz2;
    sha256 = "09ilgi6l5sq4gavskyhfrv8ra3n3r6xdn8cdc7fm2fi3zah4innn";
  };

  buildInputs = [kdelibs kdepimlibs];
}
