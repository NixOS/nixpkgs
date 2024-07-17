{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "magic-enum";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "Neargye";
    repo = "magic_enum";
    rev = "refs/tags/v${version}";
    hash = "sha256-Q82HdlEMXpiGISnqdjFd0rxiLgsobsoWiqqGLawu2pM=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = with lib; {
    description = "Static reflection for enums (to string, from string, iteration) for modern C++";
    homepage = "https://github.com/Neargye/magic_enum";
    changelog = "https://github.com/Neargye/magic_enum/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Alper-Celik ];
  };
}
