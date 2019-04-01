{ stdenv, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  name = "intel-gmmlib-${version}";
  version = "19.1.1";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "gmmlib";
    rev    = name;
    sha256 = "01nxarr2ly7w0952abicdjvx0q7ahg04lmga9phiidkmgjzrnrvi";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = https://github.com/intel/gmmlib;
    license = licenses.mit;
    description = "Intel Graphics Memory Management Library";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jfrankenau ];
  };
}
