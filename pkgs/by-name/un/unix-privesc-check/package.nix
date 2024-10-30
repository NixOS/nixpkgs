{ lib
, resholve
, fetchurl
, gawk
, bash
, binutils
, coreutils
, file
, findutils
, glibc
, gnugrep
, gnused
, nettools
, openssh
, postgresql
, ps
, util-linux
, which
}:

# resholve does not yet support `finalAttrs` call pattern hence `rec`
# https://github.com/abathur/resholve/issues/107
resholve.mkDerivation rec {
  pname = "unix-privesc-check";
  version = "1.4";

  src = fetchurl {
    url = "https://pentestmonkey.net/tools/unix-privesc-check/unix-privesc-check-${version}.tar.gz";
    hash = "sha256-4fhef2n6ut0jdWo9dqDj2GSyHih2O2DOLmGBKQ0cGWk=";
  };

  patches = [
    ./unix-privesc-check.patch # https://github.com/NixOS/nixpkgs/pull/287629#issuecomment-1944428796
  ];

  solutions = {
    unix-privesc-check = {
      scripts = [ "bin/unix-privesc-check" ];
      interpreter = "${bash}/bin/bash";
      inputs = [
        gawk
        bash
        binutils # for strings command
        coreutils
        file
        findutils # for xargs command
        glibc  # for ldd command
        gnugrep
        gnused
        nettools
        openssh
        postgresql # for psql command
        ps
        util-linux # for swapon command
        which
      ];
      fake = {
        external = [
            "lanscan" # lanscan exists only for HP-UX OS
            "mount" # Getting same error described in https://github.com/abathur/resholve/issues/29
            "passwd" # Getting same error described in https://github.com/abathur/resholve/issues/29
        ];
      };
      execer = [
        "cannot:${glibc.bin}/bin/ldd"
        "cannot:${postgresql}/bin/psql"
        "cannot:${openssh}/bin/ssh-add"
        "cannot:${util-linux.bin}/bin/swapon"
      ];
    };
  };

  installPhase = ''
    runHook preInstall
    install -Dm 755 unix-privesc-check $out/bin/unix-privesc-check
    runHook postInstall
  '';

  meta = with lib; {
    description = "Find misconfigurations that could allow local unprivilged users to escalate privileges to other users or to access local apps";
    mainProgram = "unix-privesc-check";
    homepage = "https://pentestmonkey.net/tools/audit/unix-privesc-check";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
