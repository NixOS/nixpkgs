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
                --replace "echo > stamp.h;" "(echo '#define ___STAMP_VERSION \"${git-version}\"'; echo '#define ___STAMP_YMD ${toString stampYmd}'; echo '#define ___STAMP_HMS ${toString stampHms}';) > stamp.h;";
    '';
    modules = true;
    extraOptions = [];
  };

  unstable-params = stable-params // {
    stable = false;
    extraOptions = ["--enable-trust-c-tco"];
  };

  export-gambopt = params : "export GAMBOPT=${params.buildRuntimeOptions} ;";

  gambit-bootstrap = import ./bootstrap.nix ( pkgs );

  meta = {
    description = "Optimizing Scheme to C compiler";
    homepage    = "http://gambitscheme.org";
    license     = lib.licenses.lgpl21; # dual, also asl20
    # NB regarding platforms: continuously tested on Linux,
    # tested on macOS once in a while, *should* work everywhere.
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ thoughtpolice raskin fare ];
  };
}
