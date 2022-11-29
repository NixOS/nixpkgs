{ lib, stdenv
, fetchgit
, cmake
, linux-pam
, enablePython ? false
, python ? null
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  pname = "libpam-wrapper";
  version = "1.1.3";

  src = fetchgit {
    url = "git://git.samba.org/pam_wrapper.git";
    rev = "pam_wrapper-${version}";
    sha256 = "00mqhsashx7njrvxz085d0b88nizhdy7m3x17ip5yhvwsl63km6p";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optionals enablePython [ python ];

  # We must use linux-pam, using openpam will result in broken fprintd.
  buildInputs = [ linux-pam ];

  meta = with lib; {
    description = "Wrapper for testing PAM modules";
    homepage = "https://cwrap.org/pam_wrapper.html";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
