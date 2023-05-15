{ lib, stdenv, fetchFromGitHub, cmake, curl }:

let version = "1.10.2"; in
stdenv.mkDerivation {
  pname = "libcpr";
  inherit version;

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "libcpr";
    repo = "cpr";
    rev = "1.10.2";
    hash = "sha256-F+ZIyFwWHn2AcVnKOaRlB7DjZzfmn8Iat/m3uknC8uA=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ curl ];

  cmakeFlags = [
    "-DCPR_USE_SYSTEM_CURL=ON"
  ];

  postPatch = ''
    # Linking with stdc++fs is no longer necessary.
    sed -i '/stdc++fs/d' include/CMakeLists.txt
  '';

  postInstall = ''
    substituteInPlace "$out/lib/cmake/cpr/cprTargets.cmake" \
      --replace "_IMPORT_PREFIX \"$out\"" \
                "_IMPORT_PREFIX \"$dev\""
  '';

  meta = with lib; {
    description = "C++ wrapper around libcurl";
    homepage = "https://docs.libcpr.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.all;
  };
}
