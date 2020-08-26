{ stdenv, fetchurl, xlibsWrapper, imlib2 }:

stdenv.mkDerivation rec {
  name = "giblib-1.2.4";

  src = fetchurl {
    url = "http://linuxbrit.co.uk/downloads/${name}.tar.gz";
    sha256 = "1b4bmbmj52glq0s898lppkpzxlprq9aav49r06j2wx4dv3212rhp";
  };

  outputs = [ "out" "dev" ];
  setOutputFlags = false;

  preConfigure = ''
    configureFlagsArray+=(
      --includedir=$dev/include
    )
  '';

  buildInputs = [ xlibsWrapper ];
  propagatedBuildInputs = [ imlib2 ];

  postFixup = ''
    moveToOutput bin/giblib-config "$dev"

    # Doesn't contain useful stuff
    rm -rf $out/share/doc
  '';

  meta = {
    homepage = "http://linuxbrit.co.uk/giblib/";
    description = "wrapper library for imlib2, and other stuff";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.mit;
  };
}
