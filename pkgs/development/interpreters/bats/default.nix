{ stdenv, lib, fetchzip, bash, makeWrapper, coreutils, gnugrep, doCheck ? true }:

stdenv.mkDerivation rec {
  pname = "bats";
  version = "1.2.1";

  src = fetchzip {
    url = "https://github.com/bats-core/bats-core/archive/v${version}.tar.gz";
    hash = "sha256-grB/rJaDU0fuw4Hm3/9nI2px8KZnSWqRjTJPd7Mmb7s=";
  };

  nativeBuildInputs = [ makeWrapper ];

  patchPhase = ''
    patchShebangs .
  '';

  installPhase = ''
    ./install.sh $out
    wrapProgram $out/bin/bats --suffix PATH : "${lib.makeBinPath [ bash coreutils gnugrep ]}"
  '';

  inherit doCheck;
  checkPhase = ''
    # test generates file with absolute shebang dynamically
    substituteInPlace test/install.bats --replace \
      "/usr/bin/env bash" "${bash}/bin/bash"
    bin/bats test
  '';

  meta = with lib; {
    homepage = "https://github.com/bats-core/bats-core";
    description = "Bash Automated Testing System";
    maintainers = with maintainers; [ abathur ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
