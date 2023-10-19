{ lib, stdenv, fetchFromGitHub, cmake, swig4, lua, itk }:

stdenv.mkDerivation rec {
  pname = "simpleitk";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "SimpleITK";
    repo = "SimpleITK";
    rev = "refs/tags/v${version}";
    hash = "sha256-SJSFJEFu1qKowX5/98MslN7GFDS8aF5+EKkQ2983Azg=";
  };

  nativeBuildInputs = [ cmake swig4 ];
  buildInputs = [ lua itk ];

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
