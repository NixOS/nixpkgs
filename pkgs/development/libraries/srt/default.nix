{ lib, stdenv, fetchFromGitHub, cmake, openssl
}:

stdenv.mkDerivation rec {
  pname = "srt";
<<<<<<< HEAD
  version = "1.5.2";
=======
  version = "1.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Haivision";
    repo = "srt";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-HW5l26k9w4F6IJrtiahU/8/CPY6M/cKn8AgESsntC6A=";
=======
    sha256 = "sha256-qVvoHtROtJjrUd+YpjN/0I6KmiH7c24+pQ4xYTUGPXk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  meta = with lib; {
    description = "Secure, Reliable, Transport";
    homepage    = "https://github.com/Haivision/srt";
    license     = licenses.mpl20;
    maintainers = with maintainers; [ nh2 ];
    platforms   = platforms.all;
  };
}
