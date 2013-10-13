args @ {stdenv, clwrapper, baseName, version ? "latest", src, description, deps, 
  buildInputs ? [], meta ? {}, overrides?(x: {})}:
let 
  deployConfigScript = ''
    config_script="$out"/lib/common-lisp-settings/${args.baseName}-shell-config.sh
    mkdir -p "$(dirname "$config_script")"
    touch "$config_script"
    chmod a+x "$config_script"
    echo "export NIX_LISP_COMMAND='$NIX_LISP_COMMAND'" >> "$config_script"
    echo "export NIX_LISP_ASDF='$NIX_LISP_ASDF'" >> "$config_script"
    echo "export CL_SOURCE_REGISTRY="\$CL_SOURCE_REGISTRY\''${CL_SOURCE_REGISTRY:+:}"'$CL_SOURCE_REGISTRY:$out/lib/common-lisp/${args.baseName}/'" >> "$config_script"
  '';
  deployLaunchScript = ''
    launch_script="$out"/bin/${args.baseName}-lisp-launcher.sh
    mkdir -p "$(dirname "$launch_script")"
    touch "$launch_script"
    chmod a+x "$launch_script"
    echo "#! /bin/sh" >> "$launch_script"
    echo "source '$config_script'" >> "$launch_script"
    echo '"${clwrapper}/bin/common-lisp.sh" "$@"' >> "$launch_script" 
  '';
basePackage = {
  name = "lisp-${baseName}-${version}";
  inherit src;

  inherit deployConfigScript deployLaunchScript;
  installPhase = ''
    mkdir -p "$out"/share/doc/${args.baseName};
    mkdir -p "$out"/lib/common-lisp/${args.baseName};
    cp -r . "$out"/lib/common-lisp/${args.baseName};
    cp -rf doc/* LICENCE LICENSE COPYING README README.html README.md readme.html "$out"/share/doc/${args.baseName} || true

    ${deployConfigScript}
    ${deployLaunchScript}
  '';
  propagatedBuildInputs = args.deps ++ [clwrapper clwrapper.lisp];
  buildInputs = buildInputs;
  dontStrip=true;
  meta = {
    inherit description version;
  } // meta;
};
package = basePackage // (overrides basePackage);
in
stdenv.mkDerivation package
