{ stdenv
, lib
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "atl";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "GTkorvo";
    repo = "atl";
    rev = "v${version}";
    sha256 = "kbFyO4nl8v4vW8pmbdfrXWHbw7ZYhaXj46svhGU8LYg=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"

    # Does not handle absolute paths
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  meta = with lib; {
    description = "Library for the creation and manipulation of lists of name/value pairs using an efficient binary representation";
    homepage = "https://github.com/GTkorvo/atl";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jtojnar ];
  };
}
