{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
}:

stdenv.mkDerivation rec {
  pname = "xits-math";
  version = "1.302";

  src = fetchFromGitHub {
    owner = "alif-type";
    repo = "xits";
    rev = "v${version}";
    sha256 = "1x3r505dylz9rz8dj98h5n9d0zixyxmvvhnjnms9qxdrz9bxy9g1";
  };

  nativeBuildInputs = (
    with python3Packages;
    [
      python
      fonttools
      fontforge
    ]
  );

  postPatch = ''
    rm *.otf
  '';

  installPhase = ''
    install -m444 -Dt $out/share/fonts/opentype *.otf
  '';

  meta = with lib; {
    homepage = "https://github.com/alif-type/xits";
    description = "OpenType implementation of STIX fonts with math support";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
