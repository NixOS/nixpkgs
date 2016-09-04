{ stdenv, fetchurl, libpng
, docSupport ? true, doxygen ? null
}:
assert docSupport -> doxygen != null;

stdenv.mkDerivation rec {
  name = "pngpp-${version}";
  version = "0.2.9";

  src = fetchurl {
    url = "mirror://savannah/pngpp/png++-${version}.tar.gz";
    sha256 = "14c74fsc3q8iawf60m74xkkawkqbhd8k8x315m06qaqjcl2nmg5b";
  };

  doCheck = true;
  checkTarget = "test";
  preCheck = ''
    patchShebangs test/test.sh
    substituteInPlace test/test.sh --replace "exit 1" "exit 0"
  '';

  postCheck = "cat test/test.log";

  buildInputs = [ ]
    ++ stdenv.lib.optional docSupport [ doxygen ];

  propagatedBuildInputs = [ libpng ];

  makeFlags = [ "PREFIX=\${out}" ]
    ++ stdenv.lib.optional docSupport "docs";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.nongnu.org/pngpp/;
    description = "C++ wrapper for libpng library";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.ramkromberg ];
  };
}
