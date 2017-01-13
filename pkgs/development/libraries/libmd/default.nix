{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "libmd";
  version = "0.0.0";

  src = fetchurl {
    url = "https://archive.hadrons.org/software/${pname}/${pname}-${version}.tar.xz";
    sha256 = "121s73pgbqsnmy6xblbrkj9y44c5zzzpf2hcmh6zvcvg4dk26gzx";
  };

  buildInputs = [ autoreconfHook ];

  # Writing the version to a .dist-version file is required for the get-version
  # shell script because fetchgit removes the .git directory.
  prePatch = ''
    echo '${version}' > .dist-version;
  '';

  autoreconfPhase = "./autogen";

  meta = with stdenv.lib; {
    homepage = "https://www.hadrons.org/software/${pname}/";
    description = "Message Digest functions from BSD systems";
    license = with licenses; [ bsd3 bsd2 isc beerware publicDomain ];
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.linux;
  };
}
