{ stdenv, fetchFromGitHub, cmake
, libuuid, json_c
, doxygen, perl, python2, python2Packages
}:

stdenv.mkDerivation rec {
  pname = "opae";
  version = "1.0.0";

  # the tag has a silly name for some reason. drop this in the future if
  # possible
  tver    = "${version}-5";

  src = fetchFromGitHub {
    owner  = "opae";
    repo   = "opae-sdk";
    rev    = "refs/tags/${tver}";
    sha256 = "1dmkpnr9dqxwjhbdzx2r3fdfylvinda421yyg319am5gzlysxwi8";
  };

  doCheck = false;

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=format-truncation"
    "-Wno-error=address-of-packed-member"
  ];

  nativeBuildInputs = [ cmake doxygen perl python2Packages.sphinx ];
  buildInputs = [ libuuid json_c python2 ];

  # Set the Epoch to 1980; otherwise the Python wheel/zip code
  # gets very angry
  preConfigure = ''
    find . -type f | while read file; do
      touch -d @315532800 $file;
    done
  '';

  cmakeFlags = [ "-DBUILD_ASE=1" ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Open Programmable Acceleration Engine SDK";
    homepage    = https://01.org/opae;
    license     = licenses.bsd3;
    platforms   = [ "x86_64-linux" ];
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
