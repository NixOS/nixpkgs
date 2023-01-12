{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, cmake
}:

stdenv.mkDerivation rec {
  version = "2.8.0";
  pname = "tinygltf";

  src = fetchFromGitHub {
    owner = "syoyo";
    repo = "tinygltf";
    rev = "v${version}";
    sha256 = "sha256-r9LzrXFFdSVAsNKNDObsr+hsVvvnGDo+x/mRWLFkVIU=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Header only C++11 tiny glTF 2.0 library";
    homepage = "https://github.com/syoyo/tinygltf";
    license = licenses.mit;
    maintainers = with maintainers; [ jansol ];
    platforms = platforms.all;
  };
}
