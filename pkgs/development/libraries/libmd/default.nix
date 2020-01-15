{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libmd";
  version = "1.0.1";

  src = fetchurl {
    url = "https://archive.hadrons.org/software/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0waclg2d5qin3r26gy5jvy4584ik60njc8pqbzwk0lzq3j9ynkp1";
  };

  nativeBuildInputs = [ autoreconfHook ];

  # Writing the version to a .dist-version file is required for the get-version
  # shell script because fetchgit removes the .git directory.
  prePatch = ''
    echo '${version}' > .dist-version;
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.hadrons.org/software/${pname}/";
    description = "Message Digest functions from BSD systems";
    license = with licenses; [ bsd3 bsd2 isc beerware publicDomain ];
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.linux;
  };
}
