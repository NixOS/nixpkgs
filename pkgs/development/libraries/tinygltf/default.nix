{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, cmake
}:

stdenv.mkDerivation rec {
  version = "2.5.0";
  pname = "tinygltf";

  src = fetchFromGitHub {
    owner = "syoyo";
    repo = "tinygltf";
    rev = "v${version}";
    sha256 = "sha256-Pw4iNJs0bKALVPFBYUJe5/WjHxdffungCKfJFJEpDas=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "Header only C++11 tiny glTF 2.0 library";
    homepage = "https://github.com/syoyo/tinygltf";
    license = licenses.mit;
    maintainers = with maintainers; [ jansol ];
    platforms = platforms.all;
  };
}
