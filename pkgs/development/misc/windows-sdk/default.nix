{stdenv, fetchurl, cabextract}:

#assert stdenv.system == "i686-cygwin";

stdenv.mkDerivation {
  # Windows Server 2003 R2 Platform SDK - March 2006 Edition.
  name = "windows-sdk-2003-r2";
  builder = ./builder.sh;

  srcs = [
    (fetchurl {
      url = http://download.microsoft.com/download/1/e/a/1ea37493-825f-464e-a874-403c75facd5b/PSDK-FULL.1.cab;
      md5 = "9b07b16ff1ae4982a5d4bfbe550d383e";
    })
    (fetchurl {
      url = http://download.microsoft.com/download/1/e/a/1ea37493-825f-464e-a874-403c75facd5b/PSDK-FULL.2.cab;
      md5 = "b8ace0bdda22b267d88149ac3d49f889";
    })
    (fetchurl {
      url = http://download.microsoft.com/download/1/e/a/1ea37493-825f-464e-a874-403c75facd5b/PSDK-FULL.3.cab;
      md5 = "b7a0109df5a28a5489e84df7d7a61668";
    })
    (fetchurl {
      url = http://download.microsoft.com/download/1/e/a/1ea37493-825f-464e-a874-403c75facd5b/PSDK-FULL.4.cab;
      md5 = "f3aded09c1ea845785247c45574f27fd";
    })
    (fetchurl {
      url = http://download.microsoft.com/download/1/e/a/1ea37493-825f-464e-a874-403c75facd5b/PSDK-FULL.5.cab;
      md5 = "978b7124550895358196e3f7de303cf5";
    })
    (fetchurl {
      url = http://download.microsoft.com/download/1/e/a/1ea37493-825f-464e-a874-403c75facd5b/PSDK-FULL.6.cab;
      md5 = "cf390a0479860e1e74f8e8fcddaf307f";
    })
    (fetchurl {
      url = http://download.microsoft.com/download/1/e/a/1ea37493-825f-464e-a874-403c75facd5b/PSDK-FULL.7.cab;
      md5 = "c9d1c8790fc5becaff4619d778d192a9";
    })
    (fetchurl {
      url = http://download.microsoft.com/download/1/e/a/1ea37493-825f-464e-a874-403c75facd5b/PSDK-FULL.8.cab;
      md5 = "d94d61c444ba73702c54d93084b756e1";
    })
    (fetchurl {
      url = http://download.microsoft.com/download/1/e/a/1ea37493-825f-464e-a874-403c75facd5b/PSDK-FULL.9.cab;
      md5 = "1990b7598960d503b9cd9aa9b7eb9174";
    })
    (fetchurl {
      url = http://download.microsoft.com/download/1/e/a/1ea37493-825f-464e-a874-403c75facd5b/PSDK-FULL.10.cab;
      md5 = "6437fd9dc2c65017c7bb4e759b13f678";
    })
    (fetchurl {
      url = http://download.microsoft.com/download/1/e/a/1ea37493-825f-464e-a874-403c75facd5b/PSDK-FULL.11.cab;
      md5 = "98f46cb52a01fae4e56e62f5bfef0fde";
    })
    (fetchurl {
      url = http://download.microsoft.com/download/1/e/a/1ea37493-825f-464e-a874-403c75facd5b/PSDK-FULL.12.cab;
      md5 = "b5f21fde5965b0f1079fd9c9a3434da6";
    })
    (fetchurl {
      url = http://download.microsoft.com/download/1/e/a/1ea37493-825f-464e-a874-403c75facd5b/PSDK-FULL.13.cab;
      md5 = "708574a95c51307e40e6da48e909f288";
    })
    (fetchurl {
      url = http://download.microsoft.com/download/1/e/a/1ea37493-825f-464e-a874-403c75facd5b/PSDK-FULL.14.cab;
      md5 = "19e90769d3500f6448e5ce2e1290fdd5";
    })
    (fetchurl {
      url = http://download.microsoft.com/download/1/e/a/1ea37493-825f-464e-a874-403c75facd5b/PSDK-FULL.15.cab;
      md5 = "0ccb3484253b3578e60ff1abb89f2f68";
    })
    (fetchurl {
      url = http://download.microsoft.com/download/1/e/a/1ea37493-825f-464e-a874-403c75facd5b/PSDK-FULL.16.cab;
      md5 = "e94106bb4e217b3c86c529afbb8489eb";
    })
    (fetchurl {
      url = http://download.microsoft.com/download/1/e/a/1ea37493-825f-464e-a874-403c75facd5b/PSDK-FULL.17.cab;
      md5 = "87eaa56fbd625ec696f16dbf136a3904";
    })
  ];

  # The `filemap' maps the pretty much useless paths in the CAB file
  # to their intended destinations in the file system, as determined
  # from a normal SDK installation.
  #
  # Recipe for reproducing:
  # $ find -type f /path/to/unpacked-cabs -print0 | xargs -0 md5sum > m1
  # $ find -type f /path/to/visual-c++ -print0 | xargs -0 md5sum > m2
  # $ nixpkgs/maintainers/scripts/map-files.pl m1 m2 > filemap
  filemap = ./filemap;

  buildInputs = [cabextract];
}
