{ fetchurl
, mirror
}:

{
  gfx1030_36 = fetchurl {
    sha256 = "sha256-zEXDLkRWAHS15LDA5IRyqG5rO7HHPBiVgPlQ8JjSqNc=";
    url = "${mirror}/gfx1030_36.kdb";
  };

  gfx900_56 = fetchurl {
    sha256 = "sha256-ZTqUPhVKcQzjO6bxykvZMJk1VZh31dRVs+XqcxEtmeI=";
    url = "${mirror}/gfx900_56.kdb";
  };

  gfx900_64 = fetchurl {
    sha256 = "sha256-ZTqUPhVKcQzjO6bxykvZMJk1VZh31dRVs+XqcxEtmeI=";
    url = "${mirror}/gfx900_64.kdb";
  };

  gfx906_60 = fetchurl {
    sha256 = "sha256-U6pDo8ICfs6fVIEqRziWeE5/4Vzvu41JkcRVn3ou1e4=";
    url = "${mirror}/gfx906_60.kdb";
  };

  gfx906_64 = fetchurl {
    sha256 = "sha256-U6pDo8ICfs6fVIEqRziWeE5/4Vzvu41JkcRVn3ou1e4=";
    url = "${mirror}/gfx906_64.kdb";
  };

  gfx90878 = fetchurl {
    sha256 = "sha256-r7DRhNH+jHUXAu64b9vWsZzGD4w5oSHnxH0l2RN0qlQ=";
    url = "${mirror}/gfx90878.kdb";
  };

  gfx90a68 = fetchurl {
    sha256 = "sha256-NT//zIPTbzsPJyaVycxwU6BcMTzGc/d+Z4Ab9FImDko=";
    url = "${mirror}/gfx90a68.kdb";
  };

  gfx90a6e = fetchurl {
    sha256 = "sha256-ENZHbf+/MGYgSTpALKh2meuZPNhH5bG+WrW/jzvGpBs=";
    url = "${mirror}/gfx90a6e.kdb";
  };
}
