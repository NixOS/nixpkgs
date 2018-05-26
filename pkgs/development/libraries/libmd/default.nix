{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "libmd";
  version = "1.0.0";

  src = fetchurl {
    url = "https://archive.hadrons.org/software/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1iv45npzv0gncjgcpx5m081861zdqxw667ysghqb8721yrlyl6pj";
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
