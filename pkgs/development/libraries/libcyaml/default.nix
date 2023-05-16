{ stdenv, lib, fetchFromGitHub
, libyaml
}:

stdenv.mkDerivation rec {
  pname = "libcyaml";
<<<<<<< HEAD
  version = "1.4.1";
=======
  version = "1.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tlsa";
    repo = "libcyaml";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-iS1T8R0SW+qu0TlP5FVlDzUfQitiZMUkbJUigbxeW0Y=";
=======
    sha256 = "sha256-UENh8oxZm7uukCr448Nrf7devDK4SIT3DVhvXbwfjw8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ libyaml ];

  makeFlags = [ "VARIANT=release" "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/tlsa/libcyaml";
    description = "C library for reading and writing YAML";
    changelog = "https://github.com/tlsa/libcyaml/raw/v${version}/CHANGES.md";
    license = licenses.isc;
    platforms = platforms.unix;
  };
}
