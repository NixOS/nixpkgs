{ stdenv, fetchFromGitHub, cmake, itk, python }:

stdenv.mkDerivation rec {
  _name    = "elastix";
  _version = "4.8";
  name  = "${_name}-${_version}";

  src = fetchFromGitHub {
    owner  = "SuperElastix";
    repo   = "elastix";
    rev    = "ef057ff89233822b26b04b31c3c043af57d5deff";
    sha256 = "0gm3a8dgqww50h6zld9ighjk92wlpybpimjwfz4s5h82vdjsvxrm";
  };

  nativeBuildInputs = [ cmake python ];
  buildInputs = [ itk ];

  cmakeFlags = [ "-DUSE_KNNGraphAlphaMutualInformationMetric=OFF" ];

  checkPhase = "ctest";

  meta = with stdenv.lib; {
    homepage = http://elastix.isi.uu.nl/;
    description = "Image registration toolkit based on ITK";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
