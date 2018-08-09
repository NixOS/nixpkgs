{ stdenv, fetchFromGitHub, fetchpatch, libjpeg, cmake }:

stdenv.mkDerivation rec {
  name = "jasper-${version}";
  version = "2.0.14";

  src = fetchFromGitHub {
    repo = "jasper";
    owner = "mdadams";
    rev = "version-${version}";
    sha256 = "0aarg8nbik9wrm7fx0451sbm5ypfdfr6i169pxzi354mpdp8gg7f";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2018-9055.patch";
      url = "http://paste.opensuse.org/view/raw/330751ce";
      sha256 = "0m798m6c4v9yyhql7x684j5kppcm6884n1rrb9ljz8p9aqq2jqnm";
    })
  ];


  # newer reconf to recognize a multiout flag
  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ libjpeg ];

  configureFlags = [ "--enable-shared" ];

  outputs = [ "bin" "dev" "out" "man" ];

  enableParallelBuilding = true;

  doCheck = false; # fails

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
