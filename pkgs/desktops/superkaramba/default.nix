{ stdenv, fetchurl, kdebase, kdelibs, zlib, libjpeg, perl, qt3, python, libpng, freetype, expat
, libX11, libXext, libXt, libXaw, libXpm 
}:

with stdenv.lib;

stdenv.mkDerivation rec{
  name = "superkaramba-0.39";
  builder = ./builder.sh;

  xlibs = [ libX11 libXext libXt libXaw libXpm ];

  src = fetchurl {
    url = mirror://sourceforge/netdragon/superkaramba-0.39.tar.gz;
    sha256 = "5f3ab793a08d368f37c6abe4362ab929cbb3da3b1993e285a69180a44e0d8441";
  };
  
  /*
  There is an installation error in jpeg support. You seem to have only one
  of either the headers _or_ the libraries installed. You may need to either
  provide correct --with-extra-... options, or the development package of
  libjpeg6b. You can get a source package of libjpeg from http://www.ijg.org/
  Disabling JPEG support.

  Warning: you chose to install this package in /nix/store/85a3dz1xxk138yav67yds93pgqrpi21y-superkaramba-0.39,
  but KDE was found in /nix/store/zl3k1cxf9pfipi7kz1hf4y87w54hjd5b-kdelibs-3.5.6.
  For this to work, you will need to tell KDE about the new prefix, by ensuring
  that KDEDIRS contains it, e.g. export KDEDIRS=/nix/store/85a3dz1xxk138yav67yds93pgqrpi21y-superkaramba-0.39:/nix/store/zl3k1cxf9pfipi7kz1hf4y87w54hjd5b-kdelibs-3.5.6
  Then restart KDE.

  Comments:
  I see that its missing: hddtemp, sensors based on its output.
  Not all plugins work but some do.
  TODO: make this a dependecy of KDE3/4
 
  */

  configureFlags = "
  --without-arts 
  --with-pythondir=${python}
  ";

  #xlibs2 attrByPath (attrName: builtins.getAttr attrName xlibs) (builtins.attrNames xlibs);
  #x_libraries_env = concatStringsSep ":" (map (p: "${p}/lib") xlibs2);

  x_libraries_env = concatStringsSep ":" (map (p: "${p}/lib") xlibs);

  buildInputs = [ kdebase kdelibs zlib libjpeg perl qt3 python libpng freetype expat ] ++ xlibs;
  
}
