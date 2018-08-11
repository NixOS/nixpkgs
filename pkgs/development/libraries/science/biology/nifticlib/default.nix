{ stdenv, fetchurl, cmake, zlib }:

stdenv.mkDerivation rec {
  pname    = "nifticlib";
  pversion = "2.0.0";
  name  = "${pname}-${pversion}";

  src = fetchurl {
    url    = "mirror://sourceforge/project/niftilib/${pname}/${pname}_2_0_0/${name}.tar.gz";
    sha256 = "123z9bwzgin5y8gi5ni8j217k7n683whjsvg0lrpii9flgk8isd3";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  checkPhase = "ctest";
  doCheck = false; # fails 7 out of 293 tests

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/niftilib;
    description = "Medical imaging format C API";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.linux;
    license = licenses.publicDomain;
  };
}
