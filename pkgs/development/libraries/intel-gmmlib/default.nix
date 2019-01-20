{ stdenv, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  name = "intel-gmmlib-${version}";
  version = "18.4.1";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "gmmlib";
    rev    = name;
    sha256 = "1nxbz54a0md9hf0asdbyglvi6kiggksy24ffmk4wzvkai6vinm17";
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
