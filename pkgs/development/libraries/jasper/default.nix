{ stdenv, fetchFromGitHub, fetchpatch, libjpeg, cmake }:

stdenv.mkDerivation rec {
  name = "jasper-${version}";
  version = "2.0.13";

  src = fetchFromGitHub {
    repo = "jasper";
    owner = "mdadams";
    rev = "version-${version}";
    sha256 = "1kd2xiszg9bxfavs3fadi4gi27m876d9zjjy0ns6mmbcjk109c0a";
  };

  # newer reconf to recognize a multiout flag
  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ libjpeg ];

  configureFlags = "--enable-shared";

  outputs = [ "bin" "dev" "out" "man" ];

  enableParallelBuilding = true;

  postInstall = ''
    moveToOutput bin "$bin"
  '';

  meta = with stdenv.lib; {
    homepage = https://www.ece.uvic.ca/~frodo/jasper/;
    description = "JPEG2000 Library";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
  };
}
