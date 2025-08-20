{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "tnat64";
  version = "0.06";

  src = fetchFromGitHub {
    owner = "andrewshadura";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "191j1fpr3bw6fk48npl99z7iq6m1g33f15xk5cay1gnk5f46i2j6";
  };

  configureFlags = [ "--libdir=$(out)/lib" ];
  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "IPv4 to IPv6 interceptor";
    homepage = "https://github.com/andrewshadura/tnat64";
    license = licenses.gpl2Plus;
    longDescription = ''
      TNAT64 is an interceptor which redirects outgoing TCPv4 connections
      through NAT64, thus enabling an application running on an IPv6-only host
      to communicate with the IPv4 world, even if that application does not
      support IPv6 at all.
    '';
    platforms = platforms.unix;
    badPlatforms = platforms.darwin;
    maintainers = [ maintainers.rnhmjoj ];
  };

}
