{stdenv, fetchurl, cabextract}:

assert stdenv.system == "i686-cygwin";

stdenv.mkDerivation {
  # Derived from Visual C++ 2005 (= VC 8), followed by cl.exe's
  # internal version number.
  name = "visual-c++-8-14.00.50727.42";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://download.microsoft.com/download/0/5/A/05AA45B9-A4BE-4872-8D57-733DF5297284/Ixpvc.exe;
    md5 = "5b3b07cb048798822582a752f586bab9";
  };

  # The `filemap' maps the pretty much useless paths in the CAB file
  # to their intended destinations in the file system, as determined
  # from a normal Visual C++ Express installation.
  #
  # Recipe for reproducing:
  # $ find -type f /path/to/unpacked-cab -print0 | xargs -0 md5sum > m1
  # $ find -type f /path/to/visual-c++ -print0 | xargs -0 md5sum > m2
  # $ nixpkgs/maintainers/scripts/map-files.pl m1 m2 > filemap
  filemap = ./filemap;

  buildInputs = [cabextract];
}
