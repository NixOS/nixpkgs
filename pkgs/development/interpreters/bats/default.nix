{ resholvePackage
, lib
, fetchFromGitHub
, bash
, coreutils
, gnugrep
, ncurses
, doInstallCheck ? true
}:

resholvePackage rec {
  pname = "bats";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "bats-core";
    repo = "bats-core";
    rev = "v${version}";
    sha256 = "sha256-MEkMi2w8G9FZhE3JvzzbqObcErQ9WFXy5mtKwQOoxbk=";
  };

  patchPhase = ''
    patchShebangs .
  '';

  installPhase = ''
    ./install.sh $out
  '';

  solutions = {
    bats = {
      scripts = [ "bin/bats" ];
      interpreter = "${bash}/bin/bash";
      inputs = [ bash coreutils gnugrep ];
      fake = {
        external = [ "greadlink" ];
      };
      fix = {
        "$BATS_ROOT" = [ "${placeholder "out"}" ];
      };
      keep = {
        "${placeholder "out"}/libexec/bats-core/bats" = true;
      };
    };
  };

  inherit doInstallCheck;
  installCheckInputs = [ ncurses ];
  installCheckPhase = ''
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
