{ buildEnv
, makeWrapper
, extraPackages ? []
, julia
}:

buildEnv {
    name = "julia-env";
    paths = extraPackages;

    nativeBuildInputs = [ makeWrapper ];

    pathsToLink = [ "/share/julia" ];

    # FONTCONFIG_FILE is needed to make Julia's fontconfig artifact
    # find the system fonts.
    #
    # On Wayland, without setting GDK_BACKEND to X11, we get
    # "Gdk-CRITICAL" messages.  We may remove it in the future. The
    # '*' means that if X11 is not available, it will try other
    # backends.
    postBuild = ''
      makeWrapper ${julia}/bin/julia $out/bin/julia \
        --set JULIA_LOAD_PATH "$JULIA_LOAD_PATH:$out/share/julia/upstream/packages:$out/share/julia/nixpkgs/packages" \
        --set JULIA_DEPOT_PATH "$JULIA_DEPOT_PATH:$out/share/julia/upstream:$out/share/julia/nixpkgs" \
        --set JULIA_PKG_OFFLINE true \
        --set FONTCONFIG_FILE "/etc/fonts/fonts.conf" \
        --set GDK_BACKEND "x11,*"
    '';

    passthru = { inherit julia; };
}
