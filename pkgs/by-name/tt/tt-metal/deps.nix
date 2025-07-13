{ fetchFromGitHub }:
{
  yaml-cpp = fetchFromGitHub {
    owner = "jbeder";
    repo = "yaml-cpp";
    rev = "2f86d13775d119edbb69af52e5f566fd65c6953b";
    hash = "sha256-GtUTbEaRR3+GfVkt3t8EsqBHVffVKOl8urtQTaHozIo=";
  };
  googletest = fetchFromGitHub {
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
  magic_enum = fetchFromGitHub {
    owner = "Neargye";
    repo = "magic_enum";
    tag = "v0.9.7";
    hash = "sha256-P6fl/dcGOSE1lTJwZlimbvsTPelHwdQdZr18H4Zji20=";
  };
  fmt = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    tag = "11.1.4";
    hash = "sha256-sUbxlYi/Aupaox3JjWFqXIjcaQa0LFjclQAOleT+FRA=";
  };
  range-v3 = fetchFromGitHub {
    owner = "ericniebler";
    repo = "range-v3";
    tag = "0.12.0";
    hash = "sha256-bRSX91+ROqG1C3nB9HSQaKgLzOHEFy9mrD2WW3PRBWU=";
  };
  pybind11 = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11";
    tag = "v2.13.6";
    hash = "sha256-SNLdtrOjaC3lGHN9MAqTf51U9EzNKQLyTMNPe0GcdrU=";
  };
  nlohmann_json = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    tag = "v3.11.3";
    hash = "sha256-7F0Jon+1oWL7uqet5i1IgHX0fUw/+z0QwEcA3zs5xHg=";
  };
  xtl = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xtl";
    tag = "0.8.0";
    hash = "sha256-hhXM2fG3Yl4KeEJlOAcNPVLJjKy9vFlI63lhbmIAsT8=";
  };
  xtensor = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xtensor";
    tag = "0.26.0";
    hash = "sha256-gAGLb5NPT4jiIpXONqY+kalxKCFKFXlNqbM79x1lTKE=";
  };
  xtensor-blas = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xtensor-blas";
    tag = "0.22.0";
    hash = "sha256-Lg6MjJbZUCMqv4eSiZQrLfJy/86RWQ9P85UfeIQJ6bk=";
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
    tag = "v1.1.3";
    hash = "sha256-N7Rs6mrs800B7XONCOOxR8koVEMWakZ1f2pexRwnUh8=";
  };
  nanomsg = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nng";
    tag = "v1.8.0";
    hash = "sha256-E2uosZrmxO3fqwlLuu5e36P70iGj5xUlvhEb+1aSvOA=";
  };
  libuv = fetchFromGitHub {
    owner = "libuv";
    repo = "libuv";
    tag = "v1.48.0";
    hash = "sha256-U68BmIQNpmIy3prS7LkYl+wvDJQNikoeFiKh50yQFoA=";
  };
  cxxopts = fetchFromGitHub {
    owner = "jarro2783";
    repo = "cxxopts";
    rev = "dbf4c6a66816f6c3872b46cc6af119ad227e04e1";
    hash = "sha256-2Z8DT9ihlmbiqCi8gcNzW4C5AUh4xCrpCKrGbRYcreQ=";
  };
  nanobind = fetchFromGitHub {
    owner = "wjakob";
    repo = "nanobind";
    tag = "v2.7.0";
    fetchSubmodules = true;
    hash = "sha256-ex5svqDp9XJtiNCxu0249ORL6LbG679U6PvKQaWANmE=";
  };
}
