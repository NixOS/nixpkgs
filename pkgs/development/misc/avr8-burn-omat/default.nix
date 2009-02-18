args:
args.stdenv.mkDerivation {
  name = "avr8-burn-omat-2.0.1";

  src = args.fetchurl {
    url = http://avr8-burn-o-mat.brischalle.de/AVR8_Burn-O-Mat_2_0_1.zip;
    sha256 = "0nqlrbsx7z5r3b9y9wb6b7wawa3yxwx07zn7l4g4s59scxah2skk";
  };

  buildInputs =(with args; [unzip]);

  phases = "unpackPhase installPhase";


  # move to nix-support to not create that many symlinks..
  # TODO burnomat tries to read /usr/local/etc/avrdude.conf (but you can edit it within the settings dialog)
  installPhase = ''
    ensureDir $out/{nix-support,bin}
    mv *.jar license_gpl-3.0.txt lib *.xml *.png $out/nix-support
    cat >> $out/bin/avr8-burn-omat << EOF
      #!/bin/sh
      cd $out/nix-support; exec java -jar AVR8_Burn_O_Mat.jar
    EOF
    chmod +x $out/bin/avr8-burn-omat
  '';

  meta = { 
      description = "gui tool for avrdude (nice to set fuse bits)";
      homepage = http://avr8-burn-o-mat.brischalle.de/avr8_burn_o_mat_avrdude_gui_en.html;
      license = "GPLv3";
  };
}
