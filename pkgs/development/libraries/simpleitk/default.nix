{ lib, stdenv, fetchFromGitHub, cmake, swig4, lua, itk_5_2 }:

stdenv.mkDerivation rec {
  pname = "simpleitk";
  version = "2.1.1.2";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "SimpleITK";
    repo = "SimpleITK";
    rev = "v${version}";
    sha256 = "sha256-sokJXOz6p+0eTeps5Tt24pjB3u+L1s6mDlaWN7K9m3g=";
  };

  nativeBuildInputs = [ cmake swig4 ];
  buildInputs = [ lua itk_5_2 ];

  # 2.0.0: linker error building examples
  cmakeFlags = [ "-DBUILD_EXAMPLES=OFF" "-DBUILD_SHARED_LIBS=ON" ];

  meta = with lib; {
    homepage = "https://www.simpleitk.org";
    description = "Simplified interface to ITK";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };
}
