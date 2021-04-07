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
      sha256 = "022l2jjhi57frfdv9nk6s6q23gmr9zkix06fmni8gf0gmvr7qa4x";
      envvar = "NEUTRONHP";
    }

    {
      name = "G4EMLOW";
      version = "7.13";
      sha256 = "0scczd4ismvd4g3vfshbvwv92bzkdjz0ma7y21n6qxxy96v9cj1p";
      envvar = "LE";
    }

    {
      name = "G4PhotonEvaporation";
      version = "5.7";
      sha256 = "1rg7fygfxx06h98ywlci6b0b9ih74q8diygr76c3vppxdzjl47kn";
      envvar = "LEVELGAMMA";
    }

    {
      name = "G4RadioactiveDecay";
      version = "5.6";
      sha256 = "1w8d9zzc4ss7sh1f8cxv5pmrx2b74p1y26377rw9hnlfkiy0g1iq";
      envvar = "RADIOACTIVE";
    }

    {
      name = "G4SAIDDATA";
      version = "2.0";
      sha256 = "149fqy801n1pj2g6lcai2ziyvdz8cxdgbfarax6y8wdakgksh9hx";
      envvar = "SAIDXS";
    }

    {
      name = "G4PARTICLEXS";
      version = "3.1.1";
      sha256 = "1nmgy8w1s196php7inrkbsi0f690qa2dsyj9s1sp75mndkfpxhb6";
      envvar = "PARTICLEXS";
    }

    {
      name = "G4ABLA";
      version = "3.1";
      sha256 = "1v97q28g1xqwnav0lwzwk7hc3b87yrmbvkgadf4bkwcbnm9b163n";
      envvar = "ABLA";
    }

    {
      name = "G4INCL";
      version = "1.0";
      sha256 = "0z9nqk125vvf4f19lhgb37jy60jf9zrjqg5zbxbd1wz93a162qbi";
      envvar = "INCL";
    }

    {
      name = "G4PII";
      version = "1.3";
      sha256 = "09p92rk1sj837m6n6yd9k9a8gkh6bby2bfn6k0f3ix3m4s8as9b2";
      envvar = "PII";
    }

    {
      name = "G4ENSDFSTATE";
      version = "2.3";
      sha256 = "00wjir59rrrlk0a12vi8rsnhyya71rdi1kmark9sp487hbhcai4l";
      envvar = "ENSDFSTATE";
    }

    {
      name = "G4RealSurface";
      version = "2.2";
      sha256 = "08382y1258ifs7nap6zaaazvabg72blr0dkqgwk32lrg07hdwm4r";
      envvar = "REALSURFACE";
    }

    {
      name = "G4TENDL";
      version = "1.3.2";
      sha256 = "0jdqmz3rz5a7yrq1mli6dj3bnmn73igf4fdxwfbl3rxywg38fa9v";
      envvar = "PARTICLEHP";
    }
  ])
