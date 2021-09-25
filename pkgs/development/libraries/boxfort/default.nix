{ lib, stdenv, fetchFromGitHub, meson, ninja, python3Packages }:

stdenv.mkDerivation rec {
  version = "unstable-2019-10-09";
  pname = "boxfort";

  src = fetchFromGitHub {
    owner = "Snaipe";
    repo = "BoxFort";
    rev = "356f047db08b7344ea7980576b705e65b9fc8772";
    sha256 = "1p0llz7n0p5gzpvqszmra9p88vnr0j88sp5ixhgbfz89bswg62ss";
  };

  nativeBuildInputs = [ meson ninja ];

  preConfigure = ''
    patchShebangs ci/isdir.py
  '';

  checkInputs = with python3Packages; [ cram ];

  doCheck = true;

  outputs = [ "dev" "out" ];

  meta = with lib; {
    description = "Convenient & cross-platform sandboxing C library";
    homepage = "https://github.com/Snaipe/BoxFort";
    license = licenses.mit;
    maintainers = with maintainers; [ thesola10 Yumasi ];
    platforms = platforms.unix;
  };
}
