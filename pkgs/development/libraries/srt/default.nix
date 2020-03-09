{ stdenv, fetchFromGitHub, cmake, openssl
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "srt";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "Haivision";
    repo = "srt";
    rev = "v${version}";
    sha256 = "01xaq44j95kbgqfl41pnybvqy0yq6wd4wdw88ckylzf0nzp977xz";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl ];

  cmakeFlags = [
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
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
