{ stdenv, fetchurl, gcc49, icmake, libmilter, libX11, openssl, readline
, utillinux, yodl }:

let version = "3.25.02"; in
stdenv.mkDerivation {
  name = "bobcat-${version}";

  src = fetchurl {
    sha256 = "0b1370li4q82fqj982vng9cwkf23k2c1df5jsdcgkrk01r53dxry";
    url = "mirror://debian/pool/main/b/bobcat/bobcat_${version}.orig.tar.gz";
  };

  meta = with stdenv.lib; {
    inherit version;
    description = "Brokken's Own Base Classes And Templates";
    downloadPage = http://sourceforge.net/projects/bobcat/files/;
    license = licenses.gpl3;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ gcc49 libmilter libX11 openssl readline utillinux ];
  nativeBuildInputs = [ icmake yodl ];

  postPatch = ''
    substituteInPlace INSTALL.im --replace /usr $out
    patchShebangs ./build
  '';

  buildPhase = ''
    ./build libraries all
    ./build man
  '';

  installPhase = ''
    ./build install
  '';
}
