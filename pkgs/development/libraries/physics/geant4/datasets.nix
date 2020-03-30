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
      version = "4.6";
      sha256 = "022l2jjhi57frfdv9nk6s6q23gmr9zkix06fmni8gf0gmvr7qa4x";
      envvar = "NEUTRONHP";
    }

    {
      name = "G4EMLOW";
      version = "7.9.1";
      sha256 = "1jrw0izw732bywq1k1srs3x2z0m3y2h377kcvwbwcr0wa1p10342";
      envvar = "LE";
    }

    {
      name = "G4PhotonEvaporation";
      version = "5.5";
      sha256 = "1mvnbs7yvkii41blks6bkqr8qhxgnj3xxvv1i3vdg2y14shxv5ar";
      envvar = "LEVELGAMMA";
    }

    {
      name = "G4RadioactiveDecay";
      version = "5.4";
      sha256 = "0qaark6mqzxr3lqawv6ai8z5211qihlp5x2hn86vzx8kgpd7j1r4";
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
      version = "2.1";
      sha256 = "0h8ba8jk197npbd9lzq2qlfiklbjgqwk45m1cc6piy5vf8ri0k89";
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
      version = "2.2";
      sha256 = "19p0sq0rmyg48j9hddqy24dn99md7ddiyq09lyj381q7cbpjfznx";
      envvar = "ENSDFSTATE";
    }

    {
      name = "G4RealSurface";
      version = "2.1.1";
      sha256 = "0l3gs0nlp10cjlwiln3f72zfch0av2g1r8m2ny9afgvwgbwiyj4h";
      envvar = "REALSURFACE";
    }
  ])
