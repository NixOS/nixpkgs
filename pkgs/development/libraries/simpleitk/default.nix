{ stdenv, fetchFromGitHub, cmake, swig, lua, itk }:

stdenv.mkDerivation rec {
  pname = "simpleitk";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "SimpleITK";
    repo = "SimpleITK";
    rev = "v${version}";
    sha256 = "1nf3cl3ywqg04446xhkb97kcashrgibsihxn2sqrs81i9d0rw5kn";
  };

  nativeBuildInputs = [ cmake swig ];
  buildInputs = [ lua itk ];

  # 2.0.0: linker error building examples
  cmakeFlags = [ "-DBUILD_EXAMPLES=OFF" "-DBUILD_SHARED_LIBS=ON" ];

  meta = with stdenv.lib; {
    homepage = "https://www.simpleitk.org";
    description = "Simplified interface to ITK";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };
}
