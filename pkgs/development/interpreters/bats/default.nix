{ stdenv, lib, fetchzip, bash, makeWrapper, coreutils, gnugrep, doCheck ? true }:

stdenv.mkDerivation rec {
  pname = "bats";
  version = "1.4.1";

  src = fetchzip {
    url = "https://github.com/bats-core/bats-core/archive/v${version}.tar.gz";
    hash = "sha256-bGZXjq6zG9MJgDccpVYATsgYhhb1Zf7Deoa/DoSv8QE=";
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
    # TODO: cut if https://github.com/bats-core/bats-core/issues/418 allows
    sed -i '/test works even if PATH is reset/a skip' test/bats.bats

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
