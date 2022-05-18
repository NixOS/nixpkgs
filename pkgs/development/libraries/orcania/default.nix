{ lib, stdenv, fetchFromGitHub, cmake, check, subunit }:
stdenv.mkDerivation rec {
  pname = "orcania";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "babelouest";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lrc4VEqmCp/P/h0+5/ix6tx4pjfkLy9BLBZtKYLlyGI=";
  };

  nativeBuildInputs = [ cmake ];

  checkInputs = [ check subunit ];

  cmakeFlags = [ "-DBUILD_ORCANIA_TESTING=on" ];

  doCheck = true;

  # https://github.com/babelouest/orcania/issues/27
  postPatch = ''
    substituteInPlace liborcania.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  preCheck = ''
    export LD_LIBRARY_PATH="$(pwd)''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
    export DYLD_FALLBACK_LIBRARY_PATH="$(pwd):$DYLD_FALLBACK_LIBRARY_PATH"
  '';

  meta = with lib; {
    description = "Potluck with different functions for different purposes that can be shared among C programs";
    homepage = "https://github.com/babelouest/orcania";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ johnazoidberg ];
  };
}
