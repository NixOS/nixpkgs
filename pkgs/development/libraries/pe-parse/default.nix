{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "pe-parse";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "pe-parse";
    rev = "v${version}";
    sha256 = "1jvfjaiwddczjlx4xdhpbgwvvpycab7ix35lwp3wfy44hs6qpjqv";
  };

  nativeBuildInputs = [ cmake ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/dump-pe ../test/assets/example.exe
  '';

  meta = with lib; {
    description = "A principled, lightweight parser for Windows portable executable files";
    homepage = "https://github.com/trailofbits/pe-parse";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ arturcygan ];
  };
}
