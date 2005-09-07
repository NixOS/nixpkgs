{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "eclipse-jdt-sdk-3.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://sunsite.informatik.rwth-aachen.de/eclipse/downloads/drops/R-3.1-200506271435/eclipse-JDT-SDK-3.1.zip;
    md5 = "665b51beaa718b2fec6b0155ed369f76";
  };

  buildInputs = [unzip];
}
