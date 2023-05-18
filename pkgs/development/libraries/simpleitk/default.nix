{ lib, stdenv, fetchFromGitHub, cmake, swig4, lua, itk }:

stdenv.mkDerivation rec {
  pname = "simpleitk";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "SimpleITK";
    repo = "SimpleITK";
    rev = "refs/tags/v${version}";
    hash = "sha256-0YxmixUTXpjegZQv7DDCNTWFTH8QEWqQQszee7aQ5EI=";
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
