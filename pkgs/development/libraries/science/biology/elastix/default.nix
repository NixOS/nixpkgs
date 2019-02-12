{ stdenv, fetchurl, cmake, itk, python }:

stdenv.mkDerivation rec {
  pname    = "elastix";
  pversion = "4.9.0";
  name  = "${pname}-${pversion}";

  src = fetchurl {
    url    = "https://github.com/SuperElastix/${pname}/archive/${pversion}.tar.gz";
    sha256 = "02pbln36nq98xxfyqwlxg7b6gmigdq4fgfqr9mym1qn58aj04shg";
  };

  nativeBuildInputs = [ cmake python ];
  buildInputs = [ itk ];

  meta = with stdenv.lib; {
    homepage = http://elastix.isi.uu.nl/;
    description = "Image registration toolkit based on ITK";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };
}
