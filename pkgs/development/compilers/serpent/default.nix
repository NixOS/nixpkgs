{
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}:

stdenv.mkDerivation {
  pname = "serpent";

  # I can't find any version numbers, so we're just using the date
  # of the last commit.
  version = "2016-03-05";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "serpent";
    rev = "51ee60857fe53c871fa916ef66fc1b4255bb9433";
    sha256 = "1bns9wgn5i1ahj19qx7v1wwdy8ca3q3pigxwznm5nywsw7s7lqxs";
  };

  postPatch = ''
    substituteInPlace Makefile --replace 'g++' '${stdenv.cc.targetPrefix}c++'
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv serpent $out/bin
  '';

  meta = with lib; {
    description = "Compiler for the Serpent language for Ethereum";
    mainProgram = "serpent";
    longDescription = ''
      Serpent is one of the high-level programming languages used to
      write Ethereum contracts. The language, as suggested by its name,
      is designed to be very similar to Python; it is intended to be
      maximally clean and simple, combining many of the efficiency
      benefits of a low-level language with ease-of-use in programming
      style, and at the same time adding special domain-specific
      features for contract programming.
    '';
    homepage = "https://github.com/ethereum/wiki/wiki/Serpent";
    license = with licenses; [ wtfpl ];
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
