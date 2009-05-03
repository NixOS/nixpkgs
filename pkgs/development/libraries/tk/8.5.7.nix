args: with args;

stdenv.mkDerivation {
  name = "tk-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/tcl/tk${version}-src.tar.gz";
    sha256 = "0c5gsy3nlwl0wn9swz4k4v7phy7nzjl317gca1jykgf4jz9nwdnr";
  };
  postInstall = ''
    ln -s $out/bin/wish* $out/bin/wish
  '';
  configureFlags="--with-tcl=${tcl}/lib";
  preConfigure = "cd unix";

  buildInputs = [tcl x11];
  inherit tcl;
}
