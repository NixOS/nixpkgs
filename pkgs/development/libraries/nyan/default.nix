{ lib
, stdenv
, fetchFromGitHub
, clang_14
, cmake
, flex
}:

stdenv.mkDerivation {
  pname = "nyan";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "SFTtech";
    repo = "nyan";
    rev = "7b5517f8c3c17b1fb2483f6dec882ccb84b70bbb";
    sha256 = "sha256-9pTWXgbGNrvA6o90TDbouUJx9Q6xpSN+aGbnwXKm0V4=";
  };

  nativeBuildInputs = [
    clang_14 # Just clang doesn't work on MACOS
    cmake
  ];

  buildInputs = [
    flex
  ];

  meta = with lib; {
    description = "A data description language";
    longDescription = ''
      Nyan stores hierarchical objects with key-value pairs in a database with the key idea that changes in a parent affect all children. We created nyan because there existed no suitable language to properly represent the enormous complexity of storing the data for openage.
    '';
    homepage = "https://openage.sft.mx";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ Grubben ];
    platforms = platforms.unix;
  };
}

