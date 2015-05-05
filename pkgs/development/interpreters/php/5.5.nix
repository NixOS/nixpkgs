{ callPackage, apacheHttpd  }:
callPackage ./generic.nix {
  phpVersion = "5.5.21";
  sha = "1zl3valcak5hb4fmivpfa66arwpvi19js1d5cxq5vjn4fncl5sb2";
  apacheHttpd = apacheHttpd;
}
