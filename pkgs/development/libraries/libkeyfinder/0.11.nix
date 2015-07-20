{ stdenv, fetchFromGitHub, boost, fftw, qt5 }:

let version = "0.11"; in
stdenv.mkDerivation {
  name = "libkeyfinder-${version}";

  src = fetchFromGitHub {
    sha256 = "0674gykdi1nffvba5rv6fsp0zw02w1gkpn9grh8w983xf13ykbz9";
    rev = "v${version}";
    repo = "libKeyFinder";
    owner = "ibsh";
  };

  meta = with stdenv.lib; {
    inherit version;
    description = "Musical key detection for digital audio (C++ library)";
    homepage = http://www.ibrahimshaath.co.uk/keyfinder/;
    license = licenses.gpl3Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ fftw qt5.base ];
  propagatedBuildInputs = [ boost ];

  patchPhase = ''
    substituteInPlace LibKeyFinder.pro --replace "/usr/local" "$out"
  '';

  configurePhase = ''
    qmake
  '';

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/include/keyfinder
    cp *.h $out/include/keyfinder
  '';
}
