{stdenv, fetchurl, unzip}:

stdenv.mkDerivation ( rec {
  pname = "eclipse-JDT-SDK";
  version = "3.3.2";
  name = "${pname}-${version}";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://sunsite.informatik.rwth-aachen.de/eclipse/downloads/drops/R-3.3.2-200802211800/eclipse-JDT-SDK-3.3.2.zip;
    md5 = "f9e513b7e3b609feef28651c07807b17";
  };

  buildInputs = [unzip];
})
