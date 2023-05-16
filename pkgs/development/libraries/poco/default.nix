<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, zlib, pcre2, expat, sqlite, openssl, unixODBC, libmysqlclient }:
=======
{ lib, stdenv, fetchurl, fetchpatch, cmake, pkg-config, zlib, pcre, expat, sqlite, openssl, unixODBC, libmysqlclient }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "poco";

<<<<<<< HEAD
  version = "1.12.4";

  src = fetchFromGitHub {
    owner = "pocoproject";
    repo = "poco";
    sha256 = "sha256-gQ97fkoTGI6yuMPjEsITfapH9FSQieR8rcrPR1nExxc=";
    rev = "poco-${version}-release";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ unixODBC libmysqlclient ];
  propagatedBuildInputs = [ zlib pcre2 expat sqlite openssl ];
=======
  version = "1.11.1";

  src = fetchurl {
    url = "https://pocoproject.org/releases/${pname}-${version}/${pname}-${version}-all.tar.gz";
    sha256 = "sha256-MczOYCAEcnAAO/tbDafirUMohMI9PNUJyG9HzzpeXSo=";
  };

  patches = [
    # Use GNUInstallDirs (https://github.com/pocoproject/poco/pull/3503)
    (fetchpatch {
      name = "use-gnuinstalldirs.patch";
      url = "https://github.com/pocoproject/poco/commit/16a2a74f6c28c6e6baca2ba26b4964b51d8a1b74.patch";
      sha256 = "sha256-mkemG8UemJEUQxae1trKakhnJFJW0AufDYFAbmnINbY=";
      # Files not included in release tarball
      excludes = [
        "Encodings/Compiler/CMakeLists.txt"
        "PocoDoc/CMakeLists.txt"
        "NetSSL_Win/CMakeLists.txt"
        "PDF/CMakeLists.txt"
        "SevenZip/CMakeLists.txt"
        "ApacheConnector/CMakeLists.txt"
        "CppParser/CMakeLists.txt"
      ];
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ unixODBC libmysqlclient ];
  propagatedBuildInputs = [ zlib pcre expat sqlite openssl ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" "dev" ];

  MYSQL_DIR = libmysqlclient;
  MYSQL_INCLUDE_DIR = "${MYSQL_DIR}/include/mysql";

  cmakeFlags = [
    "-DPOCO_UNBUNDLED=ON"
  ];

<<<<<<< HEAD
  postFixup = ''
    grep -rlF INTERFACE_INCLUDE_DIRECTORIES "$dev/lib/cmake/Poco" | while read -r f; do
      substituteInPlace "$f" \
        --replace "$"'{_IMPORT_PREFIX}/include' ""
    done
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://pocoproject.org/";
    description = "Cross-platform C++ libraries with a network/internet focus";
    license = licenses.boost;
<<<<<<< HEAD
    maintainers = with maintainers; [ orivej tomodachi94 ];
=======
    maintainers = with maintainers; [ orivej ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.unix;
  };
}
