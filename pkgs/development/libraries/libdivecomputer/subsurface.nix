{ stdenv, fetchgit, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libdivecomputer-${version}";
  version = "ssrf-0.5.0";

  src = fetchgit {
    url = "git://subsurface-divelog.org/libdc";
    rev = "534dd2f34b8271b2a1cac0e3151bfdc81da40e47";
    branchName = "Subsurface-branch";
    sha256 = "0iw9pczmwqlfjlgrik79b2pd4lmipxhjzj60ysk8qzl3axadjycp";
  };

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.libdivecomputer.org;
    description = "A cross-platform and open source library for communication with dive computers from various manufacturers";
    maintainers = [ maintainers.mguentner ];
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
