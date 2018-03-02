{stdenv, fetchurl, unzip, tnt}:

stdenv.mkDerivation rec {
  name = "jama-${version}";
  version = "1.2.5";
  
  src = fetchurl {
    url = https://math.nist.gov/tnt/jama125.zip;
    sha256 = "031ns526fvi2nv7jzzv02i7i5sjcyr0gj884i3an67qhsx8vyckl";
  };

  buildInputs = [ unzip ];
  propagatedBuildInputs = [ tnt ];

  unpackPhase = ''
      mkdir "${name}"
      unzip "$src"
  '';
  installPhase = ''
      mkdir -p $out/include
      cp *.h $out/include
  '';

  meta = {
    homepage = https://math.nist.gov/tnt/;
    description = "JAMA/C++ Linear Algebra Package: Java-like matrix C++ templates";
    platforms = stdenv.lib.platforms.unix;
  };
}
