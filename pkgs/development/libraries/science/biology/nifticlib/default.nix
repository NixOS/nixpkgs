{ stdenv, fetchurl, cmake, zlib }:

stdenv.mkDerivation rec {
  pname    = "nifticlib";
  pversion = "2.0.0";
  name  = "${pname}-${pversion}";

  src = fetchurl {
    url    = "https://downloads.sourceforge.net/project/niftilib/${pname}/${pname}_2_0_0/${name}.tar.gz";
    sha256 = "a3e988e6a32ec57833056f6b09f940c69e79829028da121ff2c5c6f7f94a7f88";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  checkPhase = "ctest";

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/niftilib;
    description = "Medical imaging format C API";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.linux;
    license = licenses.publicDomain;
  };
}
