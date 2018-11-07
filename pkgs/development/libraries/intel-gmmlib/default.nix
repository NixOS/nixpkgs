{ stdenv, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  name = "intel-gmmlib-${version}";
  version = "18.3.0";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "gmmlib";
    rev    = name;
    sha256 = "1x1p4xvi870vjka2ag6rmmw897hl7zhav1sgwhnrzrggsx9jrw80";
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
