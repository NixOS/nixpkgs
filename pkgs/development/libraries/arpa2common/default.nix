{ lib
, stdenv
, fetchFromGitLab
, cmake

, arpa2cm
, doxygen
, e2fsprogs
, graphviz
, lmdb
, openssl
, pkg-config
, ragel
}:

stdenv.mkDerivation rec {
  pname = "arpa2common";
  version = "2.2.18";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UpAVyDXCe07ZwjD307t6G9f/Nny4QYXxGxft1KsiYYg=";
  };

  nativeBuildInputs = [
    cmake
    arpa2cm
    doxygen
    graphviz
    pkg-config
  ];

  propagatedBuildInputs = [
    e2fsprogs
    lmdb
    openssl
    ragel
  ];

  # the project uses single argument `printf` throughout the program
  hardeningDisable = [ "format" ];

  meta = {
    description =
      "ARPA2 ID and ACL libraries and other core data structures for ARPA2";
    longDescription = ''
      The ARPA2 Common Library package offers elementary services that can
      benefit many software packages.  They are designed to be easy to
      include, with a minimum of dependencies.  At the same time, they were
      designed with the InternetWide Architecture in mind, thus helping to
      liberate users.
    '';
    homepage = "https://gitlab.com/arpa2/arpa2common";
    license = with lib.licenses; [ bsd2 cc-by-sa-40 cc0 isc ];
    maintainers = with lib.maintainers; [ fufexan ];
    platforms = lib.platforms.linux;
  };
}
