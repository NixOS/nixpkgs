{ pkgs, lib }:

rec {
  stable-params = {
    stable = true;
    defaultRuntimeOptions = "f8,-8,t8";
    buildRuntimeOptions = "f8,-8,t8";
    fixStamp = _:_:_: "";
    targets = "js"; # arm,java,js,php,python,riscv-32,riscv-64,ruby,x86,x86-64
    modules = false;
    extraOptions = [];
  };

  unstable-params = {
    stable = false;
    defaultRuntimeOptions = "iL,fL,-L,tL";
    buildRuntimeOptions = "i8,f8,-8,t8";
    fixStamp = git-version: stampYmd: stampHms: ''
      substituteInPlace configure \
        --replace "$(grep '^PACKAGE_VERSION=.*$' configure)" 'PACKAGE_VERSION="v${git-version}"' \
        --replace "$(grep '^PACKAGE_STRING=.*$' configure)" 'PACKAGE_STRING="Gambit v${git-version}"' ;
      substituteInPlace include/makefile.in \
        --replace "echo > stamp.h;" "(echo '#define ___STAMP_VERSION \"${git-version}\"'; echo '#define ___STAMP_YMD ${toString stampYmd}'; echo '#define ___STAMP_HMS ${toString stampHms}';) > stamp.h;";
    '';
    targets = "js"; # arm,java,js,php,python,riscv-32,riscv-64,ruby,x86,x86-64
    modules = true;
    extraOptions = ["--enable-c-opt-rts=-O2"];
  };

  export-gambopt = params : "export GAMBOPT=${params.buildRuntimeOptions} ;";

  gambit-bootstrap = import ./bootstrap.nix ( pkgs );

  meta = with lib; {
    description = "Optimizing Scheme to C compiler";
    homepage    = "http://gambitscheme.org";
    license     = licenses.lgpl21Only; # dual, also asl20
    # NB regarding platforms: continuously tested on Linux x86_64 and regularly tested on macOS x86_64.
    # *should* work everywhere.
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice raskin fare ];
  };
}
