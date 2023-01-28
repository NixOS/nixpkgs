{ stdenv
, fetchFromGitHub
, imagemagick
}:

stdenv.mkDerivation {
  pname = "nixos-icons";
  version = "2021-02-24";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixos-artwork";
    rev = "488c22aad523c709c44169d3e88d34b4691c20dc";
    sha256 = "ZoanCzn4pqGB1fyMzMyGQVT0eIhNdL7ZHJSn1VZWVRs=";
  };

  nativeBuildInputs = [
    imagemagick
  ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "prefix="
  ];
}
