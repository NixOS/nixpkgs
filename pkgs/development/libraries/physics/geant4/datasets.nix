{ lib, stdenv, fetchurl, geant_version }:

let
  mkDataset = { name, version, sha256, envvar }:
    stdenv.mkDerivation {
      inherit name version;
      inherit geant_version;

      src = fetchurl {
        url = "https://cern.ch/geant4-data/datasets/${name}.${version}.tar.gz";
        inherit sha256;
      };

      preferLocalBuild = true;
      dontBuild = true;
      dontConfigure = true;

      datadir = "${placeholder "out"}/share/Geant4-${geant_version}/data/${name}${version}";
      installPhase = ''
        mkdir -p $datadir
        mv ./* $datadir
      '';

      inherit envvar;
      setupHook = ./datasets-hook.sh;

      meta = with lib; {
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
      version = "4.6";
      sha256 = "sha256-nSh88q4PuIeirc6AHudPub4hsNFm2rSby+6UCKUUVAg=";
      envvar = "NEUTRONHP";
    }

    {
      name = "G4EMLOW";
      version = "8.0";
      sha256 = "sha256-2Rmo5YOGiCV7kkimE5EOsqdjMFngMMi1DAosKtn9Kzs=";
      envvar = "LE";
    }

    {
      name = "G4PhotonEvaporation";
      version = "5.7";
      sha256 = "sha256-dh5C5W/93j2YOfn52BAmB8a0wDKRUe5Rggb07p535+U=";
      envvar = "LEVELGAMMA";
    }

    {
      name = "G4RadioactiveDecay";
      version = "5.6";
      sha256 = "sha256-OIYHfJyOWph4PmcY4cMlZ4me6y27M+QC1Edrwv5PDfE=";
      envvar = "RADIOACTIVE";
    }

    {
      name = "G4SAIDDATA";
      version = "2.0";
      sha256 = "sha256-HSao55uqceRNV1m59Vpn6Lft4xdRMWqekDfYAJDHLpE=";
      envvar = "SAIDXS";
    }

    {
      name = "G4PARTICLEXS";
      version = "4.0";
      sha256 = "sha256-k4EDlwPD8rD9NqtJmTYqLItP+QgMMi+QtOMZKBEzypU=";
      envvar = "PARTICLEXS";
    }

    {
      name = "G4ABLA";
      version = "3.1";
      sha256 = "sha256-dpiwUrWL8bmIa+rNvWr2B63B4Jn8cwq2shz38JDAJ+0=";
      envvar = "ABLA";
    }

    {
      name = "G4INCL";
      version = "1.0";
      sha256 = "sha256-cWFhghrp89BWX788LPNPTgLj5RnrQZqCI27vIsLENn0=";
      envvar = "INCL";
    }

    {
      name = "G4PII";
      version = "1.3";
      sha256 = "sha256-YiWtkCZ19DgcmMa6JfxaBs6HVJqpeWNNPQNJHWYW6SY=";
      envvar = "PII";
    }

    {
      name = "G4ENSDFSTATE";
      version = "2.3";
      sha256 = "sha256-lETF4IIHkavTzKrOEFsOR3kPrc4obhEUmDTnnEqOkgM=";
      envvar = "ENSDFSTATE";
    }

    {
      name = "G4RealSurface";
      version = "2.2";
      sha256 = "sha256-mVTe4AEvUzEmf3g2kOkS5y21v1Lqm6vs0S6iIoIXaCA=";
      envvar = "REALSURFACE";
    }

    {
      name = "G4TENDL";
      version = "1.4";
      sha256 = "sha256-S3J0AgzItO1Wm4ku8YwuCI7c22tm850lWFzO4l2XIeA=";
      envvar = "PARTICLEHP";
    }
  ])
