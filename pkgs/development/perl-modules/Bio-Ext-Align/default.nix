{
  lib,
  buildPerlPackage,
  fetchFromGitHub,
}:

buildPerlPackage rec {
  pname = "BioExtAlign";
  version = "1.5.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "bioperl";
    repo = "bioperl-ext";
    rev = "bioperl-ext-release-${lib.replaceStrings [ "." ] [ "-" ] version}";
    sha256 = "sha256-+0tZ6q3PFem8DWa2vq+njOLmjDvMB0JhD0FGk00lVMA=";
  };

  patches = [ ./fprintf.patch ];

  # Do not install other Bio-ext packages
  preConfigure = ''
    cd Bio/Ext/Align
  '';

  # Disable tests as it requires Bio::Tools::Align which is in a different directory
  buildPhase = ''
    make
  '';

  meta = {
    homepage = "https://github.com/bioperl/bioperl-ext";
    description = "Write Perl Subroutines in Other Programming Languages";
    longDescription = ''
      Part of BioPerl Extensions (BioPerl-Ext) distribution, a collection of Bioperl C-compiled extensions.
    '';
    license = with lib.licenses; [ artistic1 ];
  };
}
