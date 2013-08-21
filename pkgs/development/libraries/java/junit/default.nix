{stdenv, fetchurl, unzip} :

stdenv.mkDerivation {
  name = "junit-4.8.2";
  builder = ./builder.sh;

  src = fetchurl {
    url = https://github.com/downloads/junit-team/junit/junit4.8.2.zip;
    sha256 = "01simvc3pmgp27p7vzavmsx5rphm6hqzwrqfkwllhf3812dcqxy6";
  };

  inherit unzip;

  meta = {
    homepage = http://www.junit.org/;
  };
}
