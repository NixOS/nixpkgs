{ lib, stdenv, fetchFromGitHub, cmake, swig, lua, itk }:

stdenv.mkDerivation rec {
  pname = "simpleitk";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "SimpleITK";
    repo = "SimpleITK";
    rev = "v${version}";
    sha256 = "1q51jmd6skrr31avxlrxx433lawc838ilzrj5vvv38a9f4gl45v8";
  };

  nativeBuildInputs = [ cmake swig ];
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
