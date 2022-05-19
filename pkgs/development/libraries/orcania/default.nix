{ lib, stdenv, fetchpatch, fetchFromGitHub, cmake, check, subunit }:
stdenv.mkDerivation rec {
  pname = "orcania";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "babelouest";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lrc4VEqmCp/P/h0+5/ix6tx4pjfkLy9BLBZtKYLlyGI=";
  };

  # in master post 2.2.2, see https://github.com/babelouest/orcania/issues/27
  patches = [
    (fetchpatch {
      name = "fix-pkg-config.patch";
      url = "https://github.com/babelouest/orcania/commit/4eac7d5ff76bb3bec8250fef300b723c8891552a.patch";
      sha256 = "01bsxay1ca8d08ac3ddcqyvjwgz5mgs68jz5y3gzq4qnzl3q1i54";
    })
  ];

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
