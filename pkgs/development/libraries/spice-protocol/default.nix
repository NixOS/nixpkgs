{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "spice-protocol-0.12.14";

  src = fetchurl {
    url = "https://www.spice-space.org/download/releases/${name}.tar.bz2";
    sha256 = "170ckpgazvqv7hxy209myg67pqnd6c0gvr4ysbqgsfch6320nd90";
  };

  postInstall = ''
    mkdir -p $out/lib
    ln -sv ../share/pkgconfig $out/lib/pkgconfig
  '';

  meta = with stdenv.lib; {
    description = "Protocol headers for the SPICE protocol";
    homepage = https://www.spice-space.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ bluescreen303 ];
    platforms = platforms.linux;
  };
}
