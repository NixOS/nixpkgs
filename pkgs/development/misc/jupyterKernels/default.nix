{ lib, pkgs, stdenv}:

let

  defaultKernelDefinition = {
    python3 = let
      env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
              ipykernel
              pandas
              scikitlearn
            ]));
    in {
      displayName = "Python 3";
      argv = [
        "${env.interpreter}"
        "-m"
        "ipykernel_launcher"
        "-f"
        "{connection_file}"
      ];
      language = "python";
      logo32 = "${env.sitePackages}/ipykernel/resources/logo-32x32.png";
      logo64 = "${env.sitePackages}/ipykernel/resources/logo-64x64.png";
    };
  };

in
{
  defaultKernelDefinition = defaultKernelDefinition;
  create = { kernelDefinitions ?  defaultKernelDefinition }:
  with lib; stdenv.mkDerivation rec {
    name = "jupyter-kernels";

    src = "/dev/null";

    unpackCmd ="mkdir jupyter_kernels";

    installPhase =  ''
        mkdir kernels

        ${concatStringsSep "\n" (mapAttrsToList (kernelName: kernel:
          let
            config = builtins.toJSON {
              display_name = if (kernel.displayName != "")
                then kernel.displayName
                else kernelName;
              argv = kernel.argv;
              language = kernel.language;
            };
            logo32 =
              if (kernel.logo32 != null)
              then "ln -s ${kernel.logo32} 'kernels/${kernelName}/logo-32x32.png';"
              else "";
            logo64 =
              if (kernel.logo64 != null)
              then "ln -s ${kernel.logo64} 'kernels/${kernelName}/logo-64x64.png';"
              else "";
          in ''
            mkdir 'kernels/${kernelName}';
            echo '${config}' > 'kernels/${kernelName}/kernel.json';
            ${logo32}
            ${logo64}
          '') kernelDefinitions)}

        mkdir $out
        cp -r kernels $out
      '';

    meta = {
      description = "Wrapper to create jupyter notebook kernel definitions";
      homepage = http://jupyter.org/;
      # NIXOS license as this is a nixos meta package.
      maintainers = with maintainers; [ aborsu ];
    };
  };
}
