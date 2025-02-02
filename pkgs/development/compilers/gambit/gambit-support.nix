{ pkgs, lib }:

rec {
  stable-params = {
    stable = true;
    defaultRuntimeOptions = "iL,fL,-L,tL";
    buildRuntimeOptions = "i8,f8,-8,t8";
    targets = "js"; # arm,java,js,php,python,riscv-32,riscv-64,ruby,x86,x86-64
    #fixStamp = _: _: _: "";
    fixStamp = git-version: stampYmd: stampHms: ''
      echo "Fixing timestamp recipe in Makefile"
      substituteInPlace configure \
        --replace "$(grep '^PACKAGE_VERSION=.*$' configure)" 'PACKAGE_VERSION="v${git-version}"' \
        --replace "$(grep '^PACKAGE_STRING=.*$' configure)" 'PACKAGE_STRING="Gambit v${git-version}"' ;
      substituteInPlace include/makefile.in \
        --replace "\$\$(\$(GIT) describe --tag --always | sed 's/-bootstrap\$\$//')" "v${git-version}" \
        --replace "echo > stamp.h;" "(echo '#define ___STAMP_VERSION \"v${git-version}\"'; echo '#define ___STAMP_YMD ${toString stampYmd}'; echo '#define ___STAMP_HMS ${toString stampHms}';) > stamp.h;";
      grep -i ' version=\|echo..#define ___STAMP_VERSION' include/makefile.in # XXX DEBUG -- REMOVE ME
    '';
    modules = true;
    extraOptions = [ "CFLAGS=-foptimize-sibling-calls" ];
  };

  unstable-params = stable-params // {
    stable = false;
    extraOptions = [ ]; # "CFLAGS=-foptimize-sibling-calls" not necessary in latest unstable
  };

  export-gambopt = params: "export GAMBOPT=${params.buildRuntimeOptions} ;";

  gambit-bootstrap = import ./bootstrap.nix (pkgs);

  meta = with lib; {
    description = "Optimizing Scheme to C compiler";
    homepage = "http://gambitscheme.org";
    license = licenses.lgpl21Only; # dual, also asl20
    # NB regarding platforms: continuously tested on Linux x86_64 and regularly tested on macOS x86_64.
    # *should* work everywhere.
    platforms = platforms.unix;
    maintainers = with maintainers; [
      thoughtpolice
      raskin
      fare
    ];
  };
}
