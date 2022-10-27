{ lib
, stdenv
, fetchurl
, guile
, pkg-config
, texinfo
}:

assert stdenv ? cc && stdenv.cc.isGNU;

stdenv.mkDerivation rec {
  pname = "guile-lib";
  version = "0.2.7";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-5O87hF8SGILHwM8E+BocuP02DG9ktWuGjeVUYhT5BN4=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    guile
    texinfo
  ];

  doCheck = true;

  preCheck = ''
    # Make `libgcc_s.so' visible for `pthread_cancel'.
    export LD_LIBRARY_PATH=\
    "$(dirname $(echo ${stdenv.cc.cc.lib}/lib*/libgcc_s.so))''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
  '';

  meta = with lib; {
    homepage = "https://www.nongnu.org/guile-lib/";
    description = "A collection of useful Guile Scheme modules";
    longDescription = ''
      guile-lib is intended as an accumulation place for pure-scheme Guile
      modules, allowing for people to cooperate integrating their generic Guile
      modules into a coherent library.  Think "a down-scaled, limited-scope CPAN
      for Guile".
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.gnu ++ platforms.linux;
  };
}
