{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, cmake
}:

stdenv.mkDerivation rec {
  version = "2.8.13";
  pname = "tinygltf";

  src = fetchFromGitHub {
    owner = "syoyo";
    repo = "tinygltf";
    rev = "v${version}";
    hash = "sha256-eyCa52wlV4RLATp4RE3+5hLSdSNWxLgz7MjdgMqsais=";
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
