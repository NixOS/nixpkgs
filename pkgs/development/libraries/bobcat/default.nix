{ stdenv, fetchurl, gcc49, icmake, libmilter, libX11, openssl, readline
, utillinux, yodl }:

let version = "3.25.01"; in
stdenv.mkDerivation rec {
  name = "bobcat-${version}";

  src = fetchurl {
    sha256 = "07qc10hnjpmc2wq14kw01vfww5i049y0jmdvkiiafw33ffy0wdca";
    url = "mirror://sourceforge/bobcat/bobcat/${version}/bobcat_${version}.orig.tar.gz";
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
