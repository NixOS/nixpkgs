{ lib, stdenv, fetchFromGitHub, pkg-config, cimg, imagemagick }:

stdenv.mkDerivation rec {
  pname = "pHash";
  version = "0.9.6";

  buildInputs = [ cimg ];

  # CImg.h calls to external binary `convert` from the `imagemagick` package
  # at runtime
  propagatedBuildInputs = [ imagemagick ];

  nativeBuildInputs = [ pkg-config ];

  configureFlags = ["--enable-video-hash=no" "--enable-audio-hash=no"];
  postInstall = ''
    cp ${cimg}/include/CImg.h $out/include/
  '';

  src = fetchFromGitHub {
    owner = "clearscene";
    repo = "pHash";
    rev = version;
    sha256 = "sha256-frISiZ89ei7XfI5F2nJJehfQZsk0Mlb4n91q/AiZ2vA=";
  };

  meta = with lib; {
    description = "Compute the perceptual hash of an image";
    license = licenses.gpl3;
    maintainers = [maintainers.imalsogreg];
    platforms = platforms.all;
    homepage = "http://www.phash.org";
    downloadPage = "https://github.com/clearscene/pHash";
  };
}
