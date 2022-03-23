{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, perl
, cracklib
, enablePAM ? stdenv.hostPlatform.isLinux
, pam
, enablePython ? false
, python
}:

# python binding generates a shared library which are unavailable with musl build
assert enablePython -> !stdenv.hostPlatform.isStatic;

stdenv.mkDerivation rec {
  pname = "libpwquality";
  version = "1.4.4";

  outputs = [ "out" "dev" "lib" "man" ] ++ lib.optionals enablePython [ "py" ];

  src = fetchFromGitHub {
    owner = "libpwquality";
    repo = "libpwquality";
    rev = "${pname}-${version}";
    sha256 = "sha256-7gAzrx5VP1fEBwAt6E5zGM8GyuPRR+JxYifYfirY+U8=";
  };

  patches = [
    # ensure python site-packages goes in $py output
    ./python-binding-prefix.patch
  ];

  nativeBuildInputs = [ autoreconfHook perl ] ++ lib.optionals enablePython [ python ];
  buildInputs = [ cracklib ] ++ lib.optionals enablePAM [ pam ];

  configureFlags = lib.optionals (!enablePython) [ "--disable-python-bindings" ];

  meta = with lib; {
    homepage = "https://github.com/libpwquality/libpwquality";
    description = "Password quality checking and random password generation library";
    longDescription = ''
      The libpwquality library purpose is to provide common functions for
      password quality checking and also scoring them based on their apparent
      randomness. The library also provides a function for generating random
      passwords with good pronounceability. The library supports reading and
      parsing of a configuration file.

      In the package there are also very simple utilities that use the library
      function and PAM module that can be used instead of pam_cracklib. The
      module supports all the options of pam_cracklib.
    '';
    license = with licenses; [ bsd3 /* or */ gpl2Plus ];
    maintainers = with maintainers; [ jk ];
    platforms = platforms.unix;
  };
}
