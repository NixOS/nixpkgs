{ stdenv, fetchFromGitHub, cmake, itk, python3 }:

stdenv.mkDerivation rec {
  pname    = "elastix";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner  = "SuperElastix";
    repo   = pname;
    rev    = version;
    sha256 = "1zrl7rz4lwsx88b2shnl985f3a97lmp4ksbd437h9y0hfjq8l0lj";
  };

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = [ itk ];

  doCheck = true;

  preCheck = "
    export LD_LIBRARY_PATH=$(pwd)/bin
  ";

  meta = with stdenv.lib; {
    homepage = "http://elastix.isi.uu.nl/";
    description = "Image registration toolkit based on ITK";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };
}
