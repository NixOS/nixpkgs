{ lib
, pkgs
# Conda installs its packages and environments under this directory
, installationPath ? "~/.conda"
}:

# How to use this package?
#
# First-time setup: this nixpkg downloads the conda installer and provides a FHS
# env in which it can run. On first use, the user will need to install conda to
# the installPath using the installer:
# $ nix-env -iA conda
# $ conda-shell
# $ conda-install
#
# Under normal usage, simply call `conda-shell` to activate the FHS env,
# and then use conda commands as normal:
# $ conda-shell
# $ conda install spyder
let
  minicondaInstaller = pkgs.stdenv.mkDerivation rec {
    name = "miniconda3-${version}";
    version = "4.3.31";
    src = pkgs.fetchurl {
      url = "https://repo.continuum.io/miniconda/Miniconda3-${version}-Linux-x86_64.sh";
      sha256 = "1rklq81s9v7xz1q0ha99w2sl6kyc5vhk6b21cza0jr3b8cgz0lam";
    };
    # Nothing to unpack.
    unpackPhase = "true";
    # Rename the file so it's easier to use. The file needs to have .sh ending
    # because the installation script does some checks based on that assumption.
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/miniconda3.sh
    '';
    # Add executable mode here after the fixup phase so that no patching will be
    # done by nix because we want to use this miniconda installer in the FHS
    # user env.
    fixupPhase = ''
      chmod +x $out/bin/miniconda3.sh
    '';
  };

  # Wrap miniconda installer so that it is non-interactive and installs into the
  # path specified by installationPath
  conda = pkgs.runCommand "conda-install"
    { buildInputs = [ pkgs.makeWrapper minicondaInstaller ]; }
    ''
      mkdir -p $out/bin
      makeWrapper                            \
        ${minicondaInstaller}/bin/miniconda3.sh      \
        $out/bin/conda-install               \
        --add-flags "-p ${installationPath}" \
        --add-flags "-b"
    '';
in
(
  pkgs.buildFHSUserEnv {
    name = "conda-shell";
    targetPkgs = pkgs: (
      with pkgs; [
        conda

        # Add here libraries that Conda packages require but aren't provided by
        # Conda because it assumes that the system has them.
        #
        # For instance, for IPython, these can be found using:
        # `LD_DEBUG=libs ipython --pylab`
        xorg.libSM
        xorg.libICE
        xorg.libXrender
        libselinux

        # Just in case one installs a package with pip instead of conda and pip
        # needs to compile some C sources
        gcc
      ]
    );
    profile = ''
      # Add conda to PATH
      export PATH=${installationPath}/bin:$PATH
      # Paths for gcc if compiling some C sources with pip
      export NIX_CFLAGS_COMPILE="-I${installationPath}/include"
      export NIX_CFLAGS_LINK="-L${installationPath}lib"
      # Some other required environment variables
      export FONTCONFIG_FILE=/etc/fonts/fonts.conf
      export QTCOMPOSE=${pkgs.xorg.libX11}/share/X11/locale
    '';

    meta = {
      description = "Conda is a package manager for Python";
      homepage = https://conda.io/;
      platforms = lib.platforms.linux;
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [ jluttine fridh bhipple ];
    };
  }
)
