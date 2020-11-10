{ stdenv, fetchurl, guile, texinfo, pkgconfig }:

assert stdenv ? cc && stdenv.cc.isGNU;

let
  name = "guile-lib-${version}";
  version = "0.2.6.1";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://savannah/guile-lib/${name}.tar.gz";
    sha256 = "0aizxdif5dpch9cvs8zz5g8ds5s4xhfnwza2il5ji7fv2h7ks7bd";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ guile texinfo ];

  doCheck = true;

  preCheck = ''
    # Make `libgcc_s.so' visible for `pthread_cancel'.
    export LD_LIBRARY_PATH=\
    "$(dirname $(echo ${stdenv.cc.cc.lib}/lib*/libgcc_s.so))''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
  '';

  meta = with stdenv.lib; {
    description = "A collection of useful Guile Scheme modules";
    longDescription = ''
      guile-lib is intended as an accumulation place for pure-scheme Guile
      modules, allowing for people to cooperate integrating their generic Guile
      modules into a coherent library.  Think "a down-scaled, limited-scope CPAN
      for Guile".
    '';
    homepage = "https://www.nongnu.org/guile-lib/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.gnu ++ platforms.linux;
  };
}
