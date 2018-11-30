{ stdenv, fetchzip, gnugrep }:

stdenv.mkDerivation rec {
  name = "bats-${version}";
  version = "1.1.0";

  src = fetchzip {
    url = "https://github.com/bats-core/bats-core/archive/v${version}.tar.gz";
    sha256 = "1kkh0j2alql3xiyhw9wsvcc3xclv52g0ivgyk8h85q9fn3qdqakz";
  };

  patchPhase = ''
    patchShebangs ./install.sh
    substituteInPlace ./libexec/bats-core/bats-format-tap-stream --replace grep ${gnugrep}/bin/grep
  '';

  installPhase = "./install.sh $out";

  meta = with stdenv.lib; {
    homepage = https://github.com/bats-core/bats-core;
    description = "Bash Automated Testing System";
    maintainers = [ maintainers.lnl7 ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
