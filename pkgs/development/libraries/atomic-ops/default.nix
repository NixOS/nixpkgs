{stdenv, fetchgit, autoconf, automake, libtool}:

stdenv.mkDerivation rec {
  baseName = "atomic-ops";
  version = "7.4.0";
  name="${baseName}-${version}";

  buildInputs = [ autoconf automake libtool ];

  preConfigure = ''
    ./autogen.sh
  '';

  src = fetchgit {
    url = "https://github.com/ivmai/libatomic_ops";
    rev = "a5df11ab031f7541442bac387e2ec5b6c88d8600";
    sha256 = "0ij9i0m9lq7ipx5mbp0qpr1y95zpgiv8cp11d46sss2fs1jkj1i3";
  };

  meta = {
    homepage = "https://github.com/ivmai/libatomic_ops";
    description = ''
        This package provides semi-portable access to hardware-provided
        atomic memory update operations on a number architectures.'';
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.ak ];
  };
}
