{ stdenv, fetchzip, coreutils, gnugrep }:

stdenv.mkDerivation rec {
  pname = "bats";
  version = "1.2.0";

  src = fetchzip {
    url = "https://github.com/bats-core/bats-core/archive/v${version}.tar.gz";
    sha256 = "0f59zh4d4pa1a7ybs5zl6h0csbqqv11lbnq0jl1dgwm1s6p49bsq";
  };

  patchPhase = ''
    patchShebangs ./install.sh

    substituteInPlace ./libexec/bats-core/bats \
        --replace 'type -p greadlink readlink' 'type -p ${coreutils}/bin/readlink'
    substituteInPlace ./libexec/bats-core/bats-format-tap-stream \
        --replace grep ${gnugrep}/bin/grep
  '';

  installPhase = "./install.sh $out";

  meta = with stdenv.lib; {
    homepage = "https://github.com/bats-core/bats-core";
    description = "Bash Automated Testing System";
    maintainers = [ maintainers.lnl7 ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
