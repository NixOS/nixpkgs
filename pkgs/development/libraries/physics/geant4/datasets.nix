{ stdenv, fetchurl, }:

let
  mkDataset = { name, version, sha256, envvar}:
    stdenv.mkDerivation {
      inherit name version;

      src = fetchurl {
        url = "https://geant4-data.web.cern.ch/geant4-data/datasets/${name}.${version}.tar.gz";
        inherit sha256;
      };

      preferLocalBuild = true;
      dontBuild = true;
      dontConfigure = true;

      installPhase = ''
        mkdir -p $out/data
        mv ./* $out/data
      '';

      inherit envvar;
      setupHook = ./datasets-hook.sh;

      meta = with stdenv.lib; {
        description = "Data files for the Geant4 toolkit";
        homepage = "https://geant4.web.cern.ch/support/download";
        license = licenses.g4sl;
        platforms = platforms.all;
      };
    };
in
  builtins.listToAttrs (map (a: { inherit (a) name; value = mkDataset a; }) [
    {
      name = "G4NDL";
      version = "4.5";
      sha256 = "cba928a520a788f2bc8229c7ef57f83d0934bb0c6a18c31ef05ef4865edcdf8e";
      envvar = "NEUTRONHP";
    }

    {
      name = "G4EMLOW";
      version = "7.3";
      sha256 = "583aa7f34f67b09db7d566f904c54b21e95a9ac05b60e2bfb794efb569dba14e";
      envvar = "LE";
    }

    {
      name = "G4PhotonEvaporation";
      version = "5.2";
      sha256 = "83607f8d36827b2a7fca19c9c336caffbebf61a359d0ef7cee44a8bcf3fc2d1f";
      envvar = "LEVELGAMMA";
    }

    {
      name = "G4RadioactiveDecay";
      version = "5.2";
      sha256 = "99c038d89d70281316be15c3c98a66c5d0ca01ef575127b6a094063003e2af5d";
      envvar = "RADIOACTIVE";
    }

    {
      name = "G4SAIDDATA";
      version = "1.1";
      sha256 = "a38cd9a83db62311922850fe609ecd250d36adf264a88e88c82ba82b7da0ed7f";
      envvar = "SAIDXS";
    }

    {
      name = "G4NEUTRONXS";
      version = "1.4";
      sha256 = "57b38868d7eb060ddd65b26283402d4f161db76ed2169437c266105cca73a8fd";
      envvar = "NEUTRONXS";
    }

    {
      name = "G4ABLA";
      version = "3.1";
      sha256 = "7698b052b58bf1b9886beacdbd6af607adc1e099fc730ab6b21cf7f090c027ed";
      envvar = "ABLA";
    }

    {
      name = "G4PII";
      version = "1.3";
      sha256 = "6225ad902675f4381c98c6ba25fc5a06ce87549aa979634d3d03491d6616e926";
      envvar = "PII";
    }

    {
      name = "G4ENSDFSTATE";
      version = "2.2";
      sha256 = "dd7e27ef62070734a4a709601f5b3bada6641b111eb7069344e4f99a01d6e0a6";
      envvar = "ENSDFSTATE";
    }

    {
      name = "G4RealSurface";
      version = "2.1";
      sha256 = "2a287adbda1c0292571edeae2082a65b7f7bd6cf2bf088432d1d6f889426dcf3";
      envvar = "REALSURFACE";
    }
  ])
