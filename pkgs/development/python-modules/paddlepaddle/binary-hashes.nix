{ pythonVersion, system }:
let
  all = {
    x86_64-linux = {
      platform = "manylinux1_x86_64";
      hashes = {
        cp39 = "sha256-Yu/FWoMhYp+behAth/jH0FKlf2LJr8TyvL9MBwmuews=";
        cp310 = "sha256-O7d/5LY2dEMf5gW5WrN3xzIIEi2vT0RWoMeVOk5lATk=";
      };
    };
    x86_64-darwin = {
      platform = "macosx_10_9_x86_64";
      hashes = {
        cp39 = "sha256-5g9b2gC6uosMpoJiobpj8yToIS6ifAFRvLEqnc/o/QQ=";
        cp310 = "sha256-2c1hjwNCOOOx9tVfBk+Pyk/pF0m/2tAmRsBH91834eM=";
      };
    };
  };
  selected = all."${system}";
in
{
  hash = selected.hashes."${pythonVersion}";
  platform = selected.platform;
}
