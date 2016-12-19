{ stdenv, fetchurl, cmake, unzip }:

stdenv.mkDerivation rec {
  name = "opencolorio-${version}";
  version = "1.0.9";

  src = fetchurl {
    url = "https://github.com/imageworks/OpenColorIO/archive/v1.0.9.zip";
    sha256 = "14j80dgbb6f09z63aqh2874vhzpga6zksz8jmqnj1zh87x15pqnr";
  };

  outputs = [ "bin" "out" "dev" ];

  buildInputs = [ cmake unzip ];

  postInstall = ''
    rm $out/lib/*.a
    mkdir -p $bin/bin; mv $out/bin $bin/
  '';

  meta = with stdenv.lib; {
    homepage = http://opencolorio.org;
    description = "A color management framework for visual effects and animation";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
