args @ {stdenv, clwrapper, baseName, testSystems ? [baseName], version ? "latest"
  , src, description, deps, buildInputs ? [], meta ? {}, overrides?(x: {})
  , propagatedBuildInputs ? []}:
let 
  deployConfigScript = ''
    config_script="$out"/lib/common-lisp-settings/${args.baseName}-shell-config.sh
    mkdir -p "$(dirname "$config_script")"
    touch "$config_script"
    chmod a+x "$config_script"
    echo "export NIX_CFLAGS_COMPILE='$NIX_CFLAGS_COMPILE'\"\''${NIX_CFLAGS_COMPILE:+ \$NIX_CFLAGS_COMPILE}\"" >> "$config_script"
    echo "export NIX_LISP_COMMAND='$NIX_LISP_COMMAND'" >> "$config_script"
    echo "export NIX_LISP_ASDF='$NIX_LISP_ASDF'" >> "$config_script"
    echo "export CL_SOURCE_REGISTRY="\$CL_SOURCE_REGISTRY\''${CL_SOURCE_REGISTRY:+:}"'$out/lib/common-lisp/${args.baseName}/:$CL_SOURCE_REGISTRY'" >> "$config_script"
    echo "export ASDF_OUTPUT_TRANSLATIONS="\$ASDF_OUTPUT_TRANSLATIONS\''${ASDF_OUTPUT_TRANSLATIONS:+:}"'$out/lib/common-lisp/${args.baseName}/:$out/lib/common-lisp-compiled/${args.baseName}:$ASDF_OUTPUT_TRANSLATIONS'" >> "$config_script"
    test -n "$LD_LIBRARY_PATH" &&
        echo "export LD_LIBRARY_PATH=\"\$LD_LIBRARY_PATH\''${LD_LIBRARY_PATH:+:}\"'$LD_LIBRARY_PATH'" >> "$config_script"
    test -n "$NIX_LISP_LD_LIBRARY_PATH" &&
        echo "export NIX_LISP_LD_LIBRARY_PATH=\"\$NIX_LISP_LD_LIBRARY_PATH\''${NIX_LISP_LD_LIBRARY_PATH:+:}\"'$NIX_LISP_LD_LIBRARY_PATH'" >> "$config_script"
  '';
  deployLaunchScript = ''
    launch_script="$out"/bin/${args.baseName}-lisp-launcher.sh
    mkdir -p "$(dirname "$launch_script")"
    touch "$launch_script"
    chmod a+x "$launch_script"
    echo "#! /bin/sh" >> "$launch_script"
    echo "source '$config_script'" >> "$launch_script"
    echo "export LD_LIBRARY_PATH=\"\$NIX_LISP_LD_LIBRARY_PATH\''${NIX_LISP_LD_LIBRARY_PATH:+:}\$LD_LIBRARY_PATH\"" >> "$launch_script"
    echo '"${clwrapper}/bin/common-lisp.sh" "$@"' >> "$launch_script" 
  '';
basePackage = {
  name = "lisp-${baseName}-${version}";
  inherit src;

  inherit deployConfigScript deployLaunchScript;
  installPhase = ''
    eval "$preInstall"

    mkdir -p "$out"/share/doc/${args.baseName};
    mkdir -p "$out"/lib/common-lisp/${args.baseName};
    cp -r . "$out"/lib/common-lisp/${args.baseName};
    cp -rf doc/* LICENCE LICENSE COPYING README README.html README.md readme.html "$out"/share/doc/${args.baseName} || true

    ${deployConfigScript}
    ${deployLaunchScript}

    ${stdenv.lib.concatMapStrings (testSystem: ''
       CL_SOURCE_REGISTRY= \
       NIX_LISP_PRELAUNCH_HOOK='nix_lisp_run_single_form "(progn
             (asdf:compile-system :${testSystem}) (asdf:load-system :${testSystem}))"' \
          "$out/bin/${args.baseName}-lisp-launcher.sh" ""
    '') testSystems}

    eval "$postInstall"
  '';
  propagatedBuildInputs = (args.deps or []) ++ [clwrapper clwrapper.lisp clwrapper.asdf] 
    ++ (args.propagatedBuildInputs or []);
  buildInputs = buildInputs;
  dontStrip=true;

  meta = {
    inherit description version;
  } // meta;
};
package = basePackage // (overrides basePackage);
in
stdenv.mkDerivation package
