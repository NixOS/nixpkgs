{ lib, stdenv, fetchFromGitHub, librime }:

stdenv.mkDerivation {
  pname = "brise";
  version = "unstable-2017-09-16";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "brise";
    rev = "1cfb0fe1d3a4190ce5d034f141941156dd271e80";
    sha256 = "1l13j3cfwida0ycl874fizz2jwjvlxid589a1iciqa9y25k21ql7";
  };

  buildInputs = [ librime ];

  postPatch = ''
    patchShebangs scripts/*
  '';

  # we need to use fetchFromGitHub to fetch sub-packages before we 'make',
  # since nix won't allow networking during 'make'
  preBuild = import ./fetchPackages.nix fetchFromGitHub;

  makeFlags = [ "BRISE_BUILD_BINARIES=yes" "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Rime Schema Repository";
    longDescription = ''
      This software is a collection of data packages used by Rime
      to support various Chinese input methods, including those based on
      modern dialects or historical diasystems of the Chinese language.
    '';
    homepage = "https://rime.im";
    # Note that individual packages in this collection
    # may be released under different licenses
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.sifmelcara ];
  };
}
