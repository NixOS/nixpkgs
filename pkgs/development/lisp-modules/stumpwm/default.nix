{pkgs, nixLib, clwrapper, cl-ppcre, clx, buildLispPackage}:
buildLispPackage rec {
  baseName = "stumpwm";
  version = "2013-09";
  src = pkgs.fetchgit {
    url = "https://github.com/sabetts/stumpwm";
    sha256 = "0dd69myssfn2bsdx3xdp65mjrvs9x81dl3y3659pyf1avnjlir7h";
    rev = "565ef58f04f59e1667ec1da4087f1a43a32cd67f";
  };
  description = "Tiling window manager for X11";
  deps = [cl-ppcre clx];
  buildInputs = with pkgs; [texinfo4 autoconf which makeWrapper];
  meta = {
    maintainers = [nixLib.maintainers.raskin];
    platforms = nixLib.platforms.linux;
  };
  overrides = x: {
    preConfigure = ''
      ${x.deployConfigScript}
      export CL_SOURCE_REGISTRY="$CL_SOURCE_REGISTRY:$PWD/"
      ./autogen.sh
      configureFlags=" --with-lisp=$NIX_LISP --with-$NIX_LISP=$(which common-lisp.sh) "
    '';
    installPhase=x.installPhase + ''
      make install

      if [ "$NIX_LISP" = "sbcl" ]; then
        wrapProgram "$out"/bin/stumpwm --set SBCL_HOME "${clwrapper.lisp}/lib/sbcl"
      fi;
    '';
    postInstall = ''false'';
  };
}
