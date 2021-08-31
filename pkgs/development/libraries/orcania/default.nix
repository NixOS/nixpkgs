{ lib, stdenv, fetchFromGitHub, cmake, check, subunit }:
stdenv.mkDerivation rec {
  pname = "orcania";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "babelouest";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6Libn+S5c7sCmKGq8KojiUhI18zO37rgiiVwQxP3p4o=";
  };

  nativeBuildInputs = [ cmake ];

  checkInputs = [ check subunit ];

  cmakeFlags = [ "-DBUILD_ORCANIA_TESTING=on" ];

  doCheck = true;

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
