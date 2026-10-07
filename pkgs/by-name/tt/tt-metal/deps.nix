{
  fetchFromGitHub,
  applyPatches,
  ttMetalSrc,
}:
{
  # third_party/CMakeLists.txt
  blake3 = applyPatches {
    src = fetchFromGitHub {
      owner = "BLAKE3-team";
      repo = "BLAKE3";
      tag = "1.8.4";
      hash = "sha256-Xz0LH0YpUjDishvXsW6VNK8msFlPXg08wFoSfbgws0g=";
    };
    patches = [
      "${ttMetalSrc}/third_party/blake3_install_dir.patch"
    ];
  };
  protobuf = applyPatches {
    src = fetchFromGitHub {
      owner = "protocolbuffers";
      repo = "protobuf";
      tag = "v21.12";
      hash = "sha256-VZQEFHq17UsTH5CZZOcJBKiScGV2xPJ/e6gkkVliRCU=";
    };
    patches = [
      "${ttMetalSrc}/third_party/protobuf_noreturn.patch"
    ];
  };
  yaml-cpp = fetchFromGitHub {
    owner = "jbeder";
    repo = "yaml-cpp";
    rev = "2f86d13775d119edbb69af52e5f566fd65c6953b";
    hash = "sha256-GtUTbEaRR3+GfVkt3t8EsqBHVffVKOl8urtQTaHozIo=";
  };
  gtest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    tag = "v1.13.0";
    hash = "sha256-LVLEn+e7c8013pwiLzJiiIObyrlbBHYaioO/SWbItPQ=";
  };
  reflect = fetchFromGitHub {
    owner = "boost-ext";
    repo = "reflect";
    tag = "v1.2.6";
    hash = "sha256-qjy5KyAm7/WeCyxMu/5QrBVjDSJPs0q/ZPyQwXp0WLA=";
  };
  enchantum = fetchFromGitHub {
    owner = "ZXShady";
    repo = "enchantum";
    rev = "8ca5b0eb7e7ebe0252e5bc6915083f1dd1b8294e";
    hash = "sha256-q2bbNAMpNJYedekEDtTQ2qI2+GPdkTsuxAHCBaAnuTA=";
  };
  fmt = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    tag = "11.1.4";
    hash = "sha256-sUbxlYi/Aupaox3JjWFqXIjcaQa0LFjclQAOleT+FRA=";
  };
  range-v3 = applyPatches {
    src = fetchFromGitHub {
      owner = "ericniebler";
      repo = "range-v3";
      tag = "0.12.0";
      hash = "sha256-bRSX91+ROqG1C3nB9HSQaKgLzOHEFy9mrD2WW3PRBWU=";
    };
    patches = [
      "${ttMetalSrc}/third_party/range-v3.patch"
    ];
  };
  nanobind = fetchFromGitHub {
    owner = "wjakob";
    repo = "nanobind";
    rev = "86e5626728fc282637a6c338597120913dded1bb";
    fetchSubmodules = true;
    hash = "sha256-jAg/CotM361gc+5Ymsz8jP0ddLBzrFTxCkssJKFe0NY=";
  };
  nlohmann_json = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    tag = "v3.11.3";
    hash = "sha256-7F0Jon+1oWL7uqet5i1IgHX0fUw/+z0QwEcA3zs5xHg=";
  };
  xtl = applyPatches {
    src = fetchFromGitHub {
      owner = "xtensor-stack";
      repo = "xtl";
      tag = "0.8.0";
      hash = "sha256-hhXM2fG3Yl4KeEJlOAcNPVLJjKy9vFlI63lhbmIAsT8=";
    };
    patches = [
      "${ttMetalSrc}/third_party/xtl.patch"
    ];
  };
  xtensor = applyPatches {
    src = fetchFromGitHub {
      owner = "xtensor-stack";
      repo = "xtensor";
      tag = "0.26.0";
      hash = "sha256-gAGLb5NPT4jiIpXONqY+kalxKCFKFXlNqbM79x1lTKE=";
    };
    patches = [
      "${ttMetalSrc}/third_party/xtensor.patch"
    ];
  };
  xtensor-blas = applyPatches {
    src = fetchFromGitHub {
      owner = "xtensor-stack";
      repo = "xtensor-blas";
      tag = "0.22.0";
      hash = "sha256-Lg6MjJbZUCMqv4eSiZQrLfJy/86RWQ9P85UfeIQJ6bk=";
    };
    patches = [
      "${ttMetalSrc}/third_party/xtensor-blas.patch"
    ];
  };
  benchmark = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    tag = "v1.9.1";
    hash = "sha256-5xDg1duixLoWIuy59WT0r5ZBAvTR6RPP7YrhBYkMxc8=";
  };
  taskflow = fetchFromGitHub {
    owner = "taskflow";
    repo = "taskflow";
    tag = "v3.7.0";
    hash = "sha256-q2IYhG84hPIZhuogWf6ojDG9S9ZyuJz9s14kQyIc6t0=";
  };
  flatbuffers = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    tag = "v24.3.25";
    hash = "sha256-uE9CQnhzVgOweYLhWPn2hvzXHyBbFiFVESJ1AEM3BmA=";
  };
  simd-everywhere = fetchFromGitHub {
    owner = "simd-everywhere";
    repo = "simde";
    tag = "v0.8.2";
    hash = "sha256-igjDHCpKXy6EbA9Mf6peL4OTVRPYTV0Y2jbgYQuWMT4=";
  };
  spdlog = fetchFromGitHub {
    owner = "gabime";
    repo = "spdlog";
    tag = "v1.15.2";
    hash = "sha256-9RhB4GdFjZbCIfMOWWriLAUf9DE/i/+FTXczr0pD0Vg=";
  };
  tt-logger = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-logger";
    tag = "v1.1.8";
    hash = "sha256-cAQLxxwxRkRh1hwDVyDPOr3wsiC2DStUP0UMSiY0vHg=";
  };
  cadical = applyPatches {
    src = fetchFromGitHub {
      owner = "arminbiere";
      repo = "cadical";
      tag = "rel-2.2.1";
      hash = "sha256-dYRaw9DI63Nqz0IJkfQYU4y00KSfq1Xv0xZuL1G15CY=";
    };
    patches = [
      "${ttMetalSrc}/third_party/cadical_vivify_include_tuple.patch"
    ];
  };
  capnproto = applyPatches {
    src = fetchFromGitHub {
      owner = "capnproto";
      repo = "capnproto";
      rev = "d135c9ca5e15219eaf131dfce1a41afdbaea9aab";
      hash = "sha256-aDcn4bLZGq8915/NPPQsN5Jv8FRWd8cAspkG3078psc=";
    };
    patches = [
      "${ttMetalSrc}/third_party/capnproto_capture_this.patch"
      "${ttMetalSrc}/third_party/capnproto_pthread.patch"
    ];
  };
  ttexalens = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-exalens";
    rev = "6f5720240b7254b25cb3d78aef81769fc12a30f9";
    hash = "sha256-QX9fh4KPJEj4AQjDViPQgVW1JxOADWJk0SlASLJTUCY=";
  };

  # tt-exalens: cmake/native_elf.cmake
  libdwarf = fetchFromGitHub {
    owner = "davea42";
    repo = "libdwarf-code";
    tag = "v2.3.1";
    hash = "sha256-azVCzQt9oA40YACa9PkdNt0D8vWRNHXXGoSFOYNJxgA=";
  };
  elfio = applyPatches {
    src = fetchFromGitHub {
      owner = "serge1";
      repo = "ELFIO";
      tag = "Release_3.12";
      hash = "sha256-tDRBscs2L/3gYgLQvb1+8nNxqkr8v1xBkeDXuOqShX4=";
    };
    patches = [
      ./elfio-cstdint.patch
    ];
  };

  # tt_metal/third_party/umd/third_party/CMakeLists.txt
  nanomsg = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nng";
    tag = "v1.8.0";
    hash = "sha256-E2uosZrmxO3fqwlLuu5e36P70iGj5xUlvhEb+1aSvOA=";
  };
  libuv = fetchFromGitHub {
    owner = "libuv";
    repo = "libuv";
    tag = "v1.51.0";
    hash = "sha256-ayTk3qkeeAjrGj5ab7wF7vpWI8XWS1EeKKUqzaD/LY0=";
  };
  cxxopts = fetchFromGitHub {
    owner = "jarro2783";
    repo = "cxxopts";
    rev = "dbf4c6a66816f6c3872b46cc6af119ad227e04e1";
    hash = "sha256-2Z8DT9ihlmbiqCi8gcNzW4C5AUh4xCrpCKrGbRYcreQ=";
  };
  umd_asio = fetchFromGitHub {
    owner = "chriskohlhoff";
    repo = "asio";
    tag = "asio-1-30-2";
    hash = "sha256-g+ZPKBUhBGlgvce8uTkuR983unD2kbQKgoddko7x+fk=";
  };
}
