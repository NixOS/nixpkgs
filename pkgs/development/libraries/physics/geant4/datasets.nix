{ stdenv, fetchurl, geant_version }:

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
      version = "7.7";
      sha256 = "16dec6adda6477a97424d749688d73e9bd7d0b84d0137a67cf341f1960984663";
      envvar = "LE";
    }

    {
      name = "G4PhotonEvaporation";
      version = "5.3";
      sha256 = "d47ababc8cbe548065ef644e9bd88266869e75e2f9e577ebc36bc55bf7a92ec8";
      envvar = "LEVELGAMMA";
    }

    {
      name = "G4RadioactiveDecay";
      version = "5.3";
      sha256 = "5c8992ac57ae56e66b064d3f5cdfe7c2fee76567520ad34a625bfb187119f8c1";
      envvar = "RADIOACTIVE";
    }

    {
      name = "G4SAIDDATA";
      version = "2.0";
      sha256 = "1d26a8e79baa71e44d5759b9f55a67e8b7ede31751316a9e9037d80090c72e91";
      envvar = "SAIDXS";
    }

    {
      name = "G4PARTICLEXS";
      version = "1.1";
      sha256 = "100a11c9ed961152acfadcc9b583a9f649dda4e48ab314fcd4f333412ade9d62";
      envvar = "PARTICLEXS";
    }

    {
      name = "G4ABLA";
      version = "3.1";
      sha256 = "7698b052b58bf1b9886beacdbd6af607adc1e099fc730ab6b21cf7f090c027ed";
      envvar = "ABLA";
    }

    {
      name = "G4INCL";
      version = "1.0";
      sha256 = "716161821ae9f3d0565fbf3c2cf34f4e02e3e519eb419a82236eef22c2c4367d";
      envvar = "INCL";
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
