{ lib, stdenv, fetchFromGitHub, pkg-config, cimg, imagemagick }:

stdenv.mkDerivation rec {
  pname = "pHash";
  version = "0.9.4";

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
    sha256 = "0y4gknfkns5sssfaj0snyx29752my20xmxajg6xggijx0myabbv0";
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
