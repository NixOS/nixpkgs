{ pkgs, lib }:

rec {
  stable-params = {
    defaultRuntimeOptions = "f8,-8,t8";
    buildRuntimeOptions = "f8,-8,t8";
    fix-stamp = git-version : "";
  };

  unstable-params = {
    defaultRuntimeOptions = "iL,fL,-L,tL";
    buildRuntimeOptions = "i8,f8,-8,t8";
    fix-stamp = git-version : ''
      substituteInPlace configure \
        --replace "$(grep '^PACKAGE_VERSION=.*$' configure)" 'PACKAGE_VERSION="v${git-version}"' \
        --replace "$(grep '^PACKAGE_STRING=.*$' configure)" 'PACKAGE_STRING="Gambit v${git-version}"' ;
    '';
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
