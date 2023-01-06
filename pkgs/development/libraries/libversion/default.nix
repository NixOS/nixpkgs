{ stdenv, fetchFromGitHub, cmake, lib }:

stdenv.mkDerivation rec {
  pname = "libversion";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "repology";
    repo = "libversion";
    rev = version;
    hash = "sha256-P/ykRy+LgcfWls4Zw8noel/K9mh/PnKy3smoQtuSi00=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # https://github.com/NixOS/nixpkgs/issues/144170
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  checkTarget = "test";
  doCheck = true;

  meta = with lib; {
    description = "Advanced version string comparison library";
    homepage = "https://github.com/repology/libversion";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
