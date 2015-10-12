{ stdenv, fetchFromGitHub, fftw, qtbase }:

let version = "2.1"; in
stdenv.mkDerivation {
  name = "libkeyfinder-${version}";

  src = fetchFromGitHub {
    sha256 = "07kc0cl6kirgmpdgkgmp6r3yvyf7b1w569z01g8rfl1cig80qdc7";
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

  buildInputs = [ fftw qtbase ];

  postPatch = ''
    substituteInPlace LibKeyFinder.pro \
      --replace "/usr/local" "$out" \
      --replace "-stdlib=libc++" ""
  '';

  configurePhase = ''
    qmake
  '';

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/include/keyfinder
    install -m644 *.h $out/include/keyfinder
    mkdir -p $out/lib
    cp -a lib*.so* $out/lib
  '';
}
