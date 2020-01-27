{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libversion";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "repology";
    repo = "libversion";
    rev = version;
    sha256 = "13x5djdpv6aryxsbw6a3b6vwzi9f4aa3gn9dqb7axzppggayawyk";
  };

  nativeBuildInputs = [ cmake ];

  preCheck = ''
    export LD_LIBRARY_PATH=/build/source/build/libversion/:$LD_LIBRARY_PATH
  '';
  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "Advanced version string comparison library";
    homepage = https://github.com/repology/libversion;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
