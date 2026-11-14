{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  perl,
  pkg-config,
  openssl,
  curl,
  libusb1,
  protobufc,
  enableUnsafe ? false,
}:

stdenv.mkDerivation {
  pname = "ttwatch";
  version = "2020-06-24";

  src = fetchFromGitHub {
    owner = "ryanbinns";
    repo = "ttwatch";
    rev = "260aff5869fd577d788d86b546399353d9ff72c1";
    hash = "sha256-GW1okq0PKZUcL8bI/MlhpRv1sHiX+x0q3+4N0JKGonk=";
  };

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
  ];
  buildInputs = [
    openssl
    curl
    libusb1
    protobufc
  ];

  cmakeFlags = lib.optionals enableUnsafe [ "-Dunsafe=on" ];

  preFixup = ''
    chmod +x $out/bin/ttbin2mysports
  '';

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    homepage = "https://github.com/ryanbinns/ttwatch";
    description = "Linux TomTom GPS Watch Utilities";
    maintainers = with lib.maintainers; [ dotlambda ];
    license = lib.licenses.mit;
    platforms = with lib.platforms; linux;
  };
}
