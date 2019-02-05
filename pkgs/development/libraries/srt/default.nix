{ stdenv, fetchFromGitHub, cmake, openssl
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "srt";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "Haivision";
    repo = "srt";
    rev = "v${version}";
    sha256 = "0cv73j9c8024p6pg16c4hiryiv4jpgrfj2xhfdaprsikmkdnygmz";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl ];

  cmakeFlags = [
    # TODO Remove this when https://github.com/Haivision/srt/issues/538 is fixed and available to nixpkgs
    # Workaround for the fact that srt incorrectly disables GNUInstallDirs when LIBDIR is specified,
    # see https://github.com/NixOS/nixpkgs/pull/54463#discussion_r249878330
    "-UCMAKE_INSTALL_LIBDIR"
  ];

  meta = {
    description = "Secure, Reliable, Transport";
    homepage    = https://www.srtalliance.org;
    license     = licenses.mpl20;
    maintainers = with maintainers; [ nh2 ];
    platforms   = platforms.all;
  };
}
