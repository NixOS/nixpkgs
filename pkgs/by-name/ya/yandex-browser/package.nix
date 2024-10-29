{
  stdenv,
  callPackage,
  edition ? "stable",
  ...
}@args:

let
  pname =
    {
      corporate = "yandex-browser-corporate";
      beta = "yandex-browser-beta";
      stable = "yandex-browser-stable";
    }
    .${edition};

  version =
    {
      corporate = "24.10.4.817-1";
      beta = "24.12.1.704-1";
      stable = "24.12.1.712-1";
    }
    .${edition};

  allArchives = {
    x86_64-linux = {
      url = "http://repo.yandex.ru/yandex-browser/deb/pool/main/y/${pname}/${pname}_${version}_amd64.deb";
      hash =
        {
          corporate = "sha256-xvlBMRQb9blx/fWk/Rmx4Z6HOV9q6CERKyhaa9QBdBo=";
          beta = "sha256-dK6uxD2D5QUhbTIWV2UPQfbr/2HwCiCYVecxa4P3O6M=";
          stable = "sha256-HVkyTw02xgCPQyo/RuAsJvO2kdzjm9R9Q35nJAuUbEc=";
        }
        .${edition};
    };
  };

  app =
    {
      corporate = "";
      beta = "-beta";
      stable = "";
    }
    .${edition};

  archive =
    if builtins.hasAttr stdenv.system allArchives then
      allArchives.${stdenv.system}
    else
      throw "Unsupported platform.";
in
callPackage ./make-yandex-browser.nix
  ({ edition = "stable"; } // (removeAttrs args [ "callPackage" ]))
  (
    archive
    // {
      inherit app pname version;
    }
  )
