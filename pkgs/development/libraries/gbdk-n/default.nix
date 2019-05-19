{ stdenv, fetchFromGitHub, automake, sdcc }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "gbdk-n";
  version = "unstable-2019-03-14";

  src = fetchFromGitHub {
    owner = "andreasjhkarlsson";
    repo = "gbdk-n";
    rev = "e7353c42ea6973ffdea1a10bbaadc3c516dd7d98";
    sha256 = "1dk8lg9ghvws904723gf8rgigf2w00v38vnq26l5ikg240v3r7vg";
  };

  nativeBuildInputs = [ automake ];
  buildInputs = [ sdcc ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,obj,include}
    cp bin/*.sh $out/bin
    cp lib/* $out/lib
    cp obj/* $out/obj
    cp -r include/* $out/include

    runHook postInstall
  '';

  doCheck = true;
  checkPhase = ''
    make examples
  '';
  
  meta = {
    description = "GBDK is an SDK for gameboy platform";
    longDescription = ''
      The Gameboy Development Kit (GBDK) is an SDK for developing applications/games for the gameboy platform.
    '';
    homepage = "https://github.com/andreasjhkarlsson/gbdk-n";
    license = "unknown";
    maintainers = with maintainers; [ genesis ];
    platforms = platforms.linux;
  };
}
