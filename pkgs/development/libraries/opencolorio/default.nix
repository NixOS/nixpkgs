{ stdenv, lib, fetchurl, cmake, unzip, boost }:

stdenv.mkDerivation rec {
  name = "opencolorio-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/imageworks/OpenColorIO/archive/v1.0.9.zip";
    sha256 = "1vi5pcgj7gv8fp6cdnhszwfh7lh38rl2rk4c5yzsvmgcb7xf48bx";
  };

  outputs = [ "bin" "out" "dev" ];

  buildInputs = [ cmake unzip ] ++ lib.optional stdenv.isDarwin boost;

  cmakeFlags = lib.optional stdenv.isDarwin "-DOCIO_USE_BOOST_PTR=ON";

  postInstall = ''
    rm $out/lib/*.a
    mkdir -p $bin/bin; mv $out/bin $bin/
  '';

  meta = with stdenv.lib; {
    homepage = http://opencolorio.org;
    description = "A color management framework for visual effects and animation";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
