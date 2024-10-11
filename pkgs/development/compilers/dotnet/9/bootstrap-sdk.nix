{ buildAspNetCore, buildNetRuntime, buildNetSdk, fetchNupkg }:

# v9.0 (go-live)

let
  commonPackages = [
    (fetchNupkg { pname = "Microsoft.AspNetCore.App.Ref"; version = "9.0.0-preview.7.24406.2"; hash = "sha256-nXyDJnmj+FbK0lKLdWuMWx0cOao1dPBjsnUMurlHiO4="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-dunJ5oMAES7sbGOgBTIzcfyRPCM/eCvWaGtDLuKeaVU="; })
    (fetchNupkg { pname = "Microsoft.NETCore.App.Ref"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-rYbxWdZoJyEe/BVbHf7hlpBodNK2bdH9MLCD1XT7v68="; })
    (fetchNupkg { pname = "Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-reb9N2kvknlTCMk/xhWXY+LaqGhlOw3j8rL6ExedNAQ="; })
    (fetchNupkg { pname = "Microsoft.NET.ILLink.Tasks"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-bN63ja7pcNbBc0Zs0EvI2itTdmnzwaXfetfyq5KiJtE="; })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-sojgmVrF8AoSXezqDvSXJ9zTjxLKHCaGqe+nLJ+ES9E="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-PKzsi1/nT/2Taj1IBmVR1NlpZeUHn4KZ0q6ewr9uTEY="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-EiEgsIaUT5dcUVtUyKGo+DBuJO/blQx8aA6Ar0xVMaQ="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-0gj0GNivUatxVYMTvj0kChqif6UPrNkqIiqLIOCkIZQ="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-Eude2kSbeQjqM6mkpZF03owmmNfEoavmDpS+Oao3xF0="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-YniLNH1/mDrn9nEoXbipW0UWT89UITykNbiS5NZ8F2o="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-iF2Iv4nrfnuOjClhh8C1UfX1kd67DBQZthDhDj3PqLc="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-kmsB6RYsUytkjiZqyUT/6lVelRYzw9DWfr2zoWRol5w="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-YETL82auvOBXN3HvvA+FXu5slvcUWtcC44wz0kAJ0zI="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-d41zVk+3b0XskHZ3cBAJK8NFpTJ+Ru95pnjIrQStTFw="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-Rxn4civ7GnjlO/op6+5T7xsOcSAIyF1MHGCOwq7/e54="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-CCRTWNVpmtOL4xQqOAOzMqtNZhCyvZkKJlDloof0HMY="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-5oaDm7xt9qkkURIeBY3elDfsNkWtJG33rXx0pIJRP2Y="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-AhQrn6dfKenZ8uykuV1DDdN8hggI9Nd/LCKeh83+2Ko="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-arm64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-j9co1m1izGysd9VljBm9lo7zW29/qBA2Qj0MYaYcI0c="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-GvlxGdc6f+jTLS60CF1dvhb5K6ES4aRygR4NvaK/vVA="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-HPJHlpeSsMlNaCcs4pN6hHROwLmaK5F5QbZ4lsKZtpY="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-NBylyIg6SFrKYcHchaTaujGb/nxOv+RIg+7Iwg5k3l8="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x86"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-1hqCBjD2xSl8mUF5V37Cmr4WpH9ryhALylDBLT+E/ZU="; })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "9.0.0-preview.7.24406.2"; hash = "sha256-3je0rdpHOW1l/iF3ecF2/ftCyitfxyBibyywLiusJ8s="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-hgv7CLltndroZv5k084+v1AR6xDZnvlF6Q7ku1vVias="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-I/t/MihCgrJW5peMDogIKoSNrx7bYqyrZSfLoXUtugg="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-o1abcKcVJBU57FXA/zea28b2cVhXqH/RHWTFdpU2SDs="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "9.0.0-preview.7.24406.2"; hash = "sha256-WZIgsr+3v1hdYCi+E+lHHntfof/o7QXwIa0H5gubTZk="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-hfur5LH1dDeZSse/xqjRWiQenN1Sfv6aPZNrXvydw0I="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-ZLj35nJcPS5yn33XMaLnz7yVBJjqApB3wS6quzzW+bw="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-gPd1AHhEoT/HNqQ90qNnjdrM/oUy8VcmGYWO5Zfpj2I="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "9.0.0-preview.7.24406.2"; hash = "sha256-KFCWI0mgi3hrYyzPYxb6D468twJyllZP5CW/a/K0gJ4="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-pNOydMIo6ZNpGtKiPcgi+LJy0DY45tcUWZCOx9r6jU4="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-9hSOIcpmB1Wz+q26WMxk/ZwDMXYBjkXCs/XXMTaec8A="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-dTIDcM0fAkQ3zRBI60nNuW/3qVhkWuXjquTAFagYGtM="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "9.0.0-preview.7.24406.2"; hash = "sha256-VFigL+0Ysg5aQWd/6Qk5XchxhPxJfQaaLo047LYdKEg="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-w7U30BMWSzdjDk1FJcltlZXnsWQsug4SchahuvyHNxo="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-P7c+nwja+URC7eZe848sz/QzpqN7Zhxjy2fnjnmeQjM="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-hlVdFrVWWx6ECL8hVIt+WeKPiI/0CNbiVYD/5U700rU="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-preview.7.24406.2"; hash = "sha256-OiMrdhGj32XWc0VKTDHwq58AD3eeiII8tthKip1yFPc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-spQ7sZKWMYPPlYUmKCGzFApJOWHFhCpeegZm04G9JWY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-hspM9qZ4sNRATz81xFIYj5dLlpCBkyxaKZVcOIPwqqI="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-1kzyTWsWaGU5qUYY0kzQDKl6RVZ9XDsm8MxFNU+HmGU="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "9.0.0-preview.7.24406.2"; hash = "sha256-Ma5XdeyoBQ4d62HBkHWjWACTUDp/S9MtBAsutCCihFc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-lk/JodZ+XomAohSgyKM2k8eRu0s73dgMp4mgTlh5fM8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-mw1QXmFUQHnQmCFtvRWltE2WSb6VPXVYUWg7vsLH2FY="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-81AvJlA7OSA0CHofH6r46OK1QtS5aVEyR/tPN6pixP4="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "9.0.0-preview.7.24406.2"; hash = "sha256-2zx5mJdep5fWIi0iZKOonEUILgDBNeR40lPRCStkPIY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-g3G3cK0S1iXroK9EASdots1loagbwGbBrtfb3xO5nyw="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-3VMYzG9L0pbjfQsQJDIiYDjAx79UsxPnuyZakWrM7Vc="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-2NUa4VTb/X1iLy4ydDOmIrGSmlIXE0w9AoPE64WE0N8="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "9.0.0-preview.7.24406.2"; hash = "sha256-FKGblSVPmqwSmUZ4uPOWv+9v1rJgqpYLS46SqaAsNoQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-CCsfmrfGEvIWP5qykjBcEhtTz1UiWHBhbNrG223g+8I="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-kwZA5tH0ZVig32AnK5QW8ELz49nvzWCoIjU56/mOrU4="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-N5BenFs+Ma0eXUyIwyqbY/RJq2xdeUjgV41vhpVbAqo="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "9.0.0-preview.7.24406.2"; hash = "sha256-kbFA50EsPoHnrSrZscBZzTZzogO84Pa3zhaTXDPuqa4="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-dYyGgqNsRMBwSW+xzlqd31Mbz1E5WM6/tiX9GQXvpis="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-+sNtiZOev4p81WVRTUPzX7xBuip14jNyDWB/xzJMov8="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-pW15+u6YxQS0+qV+SdZQqs+E12B/X+v11QdLTt9rc0Q="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "9.0.0-preview.7.24406.2"; hash = "sha256-N63cL3IfO9q36Wr4O10seCS/w9scr5FjHH6bCPhSdj8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-xU7RvUsBY55eEBy7d+H19lUg2hVPm77fGll8qmh57yo="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-fqQxVj5r39s/Lsky5yQDTGYwcDCRs7O0rPvMCVGcqLI="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-G9VZ4CImoeFnqQMW6K2Mx6Wt2AQaUpBv2wOhwWvbyqs="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "9.0.0-preview.7.24406.2"; hash = "sha256-08SVeyF0xfKxMaNg9Tk58ITv3j3WVeggkbISCe2RHuI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-6kiZFJjo8w+84y1jyibEOVHWa9o3kNiG+n89xQzA1GI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-H9q25USVrirBzQmaMHZ55AHeet1kArQkm5qVMnRvYgs="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; hash = "sha256-gHcP0Y3iDDIQRgB7e7pfUOG/NBFO4IIaWN6jzoJYQw0="; })
    ];
  };

in rec {
  release_9_0 = "9.0.0-preview.7";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.0-preview.7.24406.2";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5e16d860-eacd-48cb-9d3b-a29894cf74fc/f1e9a698798f7325b1e28588c7075cfb/aspnetcore-runtime-9.0.0-preview.7.24406.2-linux-arm.tar.gz";
        hash = "sha512-xaYPwkz9nMsnwCKTipNmijRPHz8b20HgH0dAu3mK0ENBtbMP1K7xKdk2yQmthHPPYHKnb5mexiYiHflpbHPcxQ==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/28370706-3338-4dd5-9992-6cd1d86ba666/354c9434538f587c3198fe57fa0d2e00/aspnetcore-runtime-9.0.0-preview.7.24406.2-linux-arm64.tar.gz";
        hash = "sha512-cGkl/eW7k7mONHVA/gmDzggZosolIO0tW/xFFctoUlh6MPKYUrUSUJtmDa+O52/zyLstL9eOR8auFW5vAM3pGA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/bdb8a419-432c-4f1c-b5ad-ae6e27617b5c/65b26a64e3dda62c456a7a45df73dc1e/aspnetcore-runtime-9.0.0-preview.7.24406.2-linux-x64.tar.gz";
        hash = "sha512-RPhsQHtQGnAKrq4s6Vz1RNhcCLQc3RLO4iv8/dA8T2oW5JXZ+DFfXlama35hh6T8OdiZ+WemX3OIPkAXI0MnXA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/058d32bd-03e3-4867-8c62-79e88b5b9b69/784891ca110016d0afa902cc4176e46f/aspnetcore-runtime-9.0.0-preview.7.24406.2-linux-musl-arm.tar.gz";
        hash = "sha512-CLZ8o0Ei8GM3DQ8kYGF0Am0+Z/h2esLkxDk8IU5gjUfYLa0XepfF5uKNCJQSQD91ASwAzaq7EJ5GHiZq1qYgxQ==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/94ac38de-a00b-45a1-a37a-c7b4d8a52ddf/135aa93213a5f87c7feaf267e305a3b3/aspnetcore-runtime-9.0.0-preview.7.24406.2-linux-musl-arm64.tar.gz";
        hash = "sha512-3xVgbijmgWJznWtfOjhSZky9jXj/jo6+0H4veMhpnQ3UvSo8O1yYtjv9rhEGcg/UBp00nQ1OMgN97qd6Tpfv7Q==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/60441f64-edc5-4c33-8022-107be30d728b/a3375f19b72b8e23d5394e3a1e2a1806/aspnetcore-runtime-9.0.0-preview.7.24406.2-linux-musl-x64.tar.gz";
        hash = "sha512-vdtmYj4m05HUWHtG9re+UoB4jrA1XFWARAFsGhIGIAXyYnvT/fUcsnH4XqqR+5IFMu8jXt12TkymOTFZXh+1Kw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b2836c76-8c1d-4030-b7f6-0cd5ec1b640b/ea922caf251b0245b96ba2afd7ebb2b4/aspnetcore-runtime-9.0.0-preview.7.24406.2-osx-arm64.tar.gz";
        hash = "sha512-ggCvVZx29b8S9eBJXChag32+KcesLWxWJUD3B3qmj6ZdwFIFtLIZ5y941Vwgp1pRT2zPP1PW7PNP0s6ggXp+3g==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d0813855-fdde-47df-8d71-119af034e409/40989f36db96de19bc682d62cbadd8e3/aspnetcore-runtime-9.0.0-preview.7.24406.2-osx-x64.tar.gz";
        hash = "sha512-DzCda4SczsjhOBLen/cPrFzHh4W3HzVvxj5QcCljBXZokqPf10uum0d17ERJM10D0EZJSkFjBPVuW6d0bzMWyg==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.0-preview.7.24405.7";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/074a9718-7e48-46ad-99c2-1de78504111f/23e4f1e407d3c7f019156e633a59f753/dotnet-runtime-9.0.0-preview.7.24405.7-linux-arm.tar.gz";
        hash = "sha512-a/QNToN/dPCsks5QTBh7M+4da6ZT3ugAa7r1pvkj7v+6LLnC+TggeFbIS7nkHVw/QtCgsd1iu9mZfohb6rajrw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/248e66b8-594d-4738-8b01-2aa045faf3fd/686e989ba0365848fb4f81f8d780812c/dotnet-runtime-9.0.0-preview.7.24405.7-linux-arm64.tar.gz";
        hash = "sha512-90QLZ5MVxtNbEtg5oc9SyWF4TVZST1Lpang0u9p79OW/1yYIEUjPcfsZsxB8ex85aBovrn6H8dn6BjS3Ckf0sg==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/41a47c9d-c08b-4abe-a2d1-920b51fe16b0/f6af3aa0615cc1625bfc77cd38e16d02/dotnet-runtime-9.0.0-preview.7.24405.7-linux-x64.tar.gz";
        hash = "sha512-nt5GvC5vh6n1kviIVipM3ab/oBypgi9tSuWGp8R40+T+bHB1ik6ey7qGRFl4xo+AXR1tb003/GU6K3UQMJ3V3A==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4c4efbb5-befb-41fd-aab2-7b1a0d0b4921/69e5daec0c5b967f7f27abbc49343c06/dotnet-runtime-9.0.0-preview.7.24405.7-linux-musl-arm.tar.gz";
        hash = "sha512-1idQfTbg7j6KYlPQSIuyyFRYuhJAFrMsikgew9YD9Dk7cA8c0IxWQKrRlxVGUmiY/7BJ6VkMvWVd2kN1t9d1fg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d680fd8e-6530-4da3-85d9-9c76c56cc737/c4d4b30f592e8a374f86c7f261886207/dotnet-runtime-9.0.0-preview.7.24405.7-linux-musl-arm64.tar.gz";
        hash = "sha512-V7sQnSvWbG4nO1TUu7SDalM3XxyxO+0ROca8lQ+F3ndAcAFP0Z3bi0NYj6MvbeYIEbQ8v/XSmx9TfLggZWH8XA==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0c5ee877-7142-41e4-bca9-244fa4fa129f/46a54128a24c0a2c75ca2d4e8aca5f28/dotnet-runtime-9.0.0-preview.7.24405.7-linux-musl-x64.tar.gz";
        hash = "sha512-ND2RGJT/O2HPbuVgtaXaFKi4Tp3/oiEVKdiF6BMUprDoi2AYs6EW8FsLzW6AsqHoy0VUfxk6SaOq/N85krWA5w==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a71e7742-36b6-4f68-a573-b3437fc53a77/571d8fff000e17abd5d820cafc600b63/dotnet-runtime-9.0.0-preview.7.24405.7-osx-arm64.tar.gz";
        hash = "sha512-redTA+OcM69tfqEDabuH1dRGYZ0v+mMNseg0KxV37+aDHY8yMW+w4FNuVuCtt5eMTht13e+aLRzahle4/EVzVg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/dc29a044-d48d-43cd-a56c-2b8cba456df2/888138574a36ee8c2fe1af2e33c1119d/dotnet-runtime-9.0.0-preview.7.24405.7-osx-x64.tar.gz";
        hash = "sha512-FzUnRtG3gCcnZsbqIL2wlh+ABLr8Uph3ZE+lNrwOdEHrSNZc0FxOuQFySWUTYcdz2JsewcFyC9T84P6WVhTUig==";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.100-preview.7.24407.12";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d684965c-26a1-4ad9-964e-eba707075cb2/a76775d98eb7565314c7061881ebda5e/dotnet-sdk-9.0.100-preview.7.24407.12-linux-arm.tar.gz";
        hash = "sha512-uXw1fPii4SmyInSOI7WTQ8QmS23J2+AMWgG/LT9Xwaa8YeXsBTt1zg0XQ0l34WFtPvt8RkKsoY2Ltf57bA+QbQ==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/9dce0bb1-16ab-4670-9af4-57b6bd1c0c21/ba6055b1ad714158742dd1b2373adaed/dotnet-sdk-9.0.100-preview.7.24407.12-linux-arm64.tar.gz";
        hash = "sha512-yK4IhYyczxbXtIebcgHqIr1Z6X8ZJNT/KyUHkWjJBtiKKGTmeWJEtn22EqNhcJaf7yEoeao7IjJBh5XH5+bVJg==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/84a39cad-2147-4a3e-b8fd-ec6fca0f80dd/d86fc06f750e758770f5a2237e01f5c5/dotnet-sdk-9.0.100-preview.7.24407.12-linux-x64.tar.gz";
        hash = "sha512-O8G924vrv6niVkh4ccOYTr4sm8d7ZE3SXkZg8Sx2BC9QCTETWggKl/JlvExVBEMxUL3go8oZw/etcSeDUHb8jg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ad7426e9-3acf-402b-a2d4-de7046d67137/8c596827e70ab0960dad22502e17d7fc/dotnet-sdk-9.0.100-preview.7.24407.12-linux-musl-arm.tar.gz";
        hash = "sha512-zSfP1WSDxR9I0SwgTj3gvUkLCB0q3Q09ufGukFzvdHBhNye+tSE8bmip2s0sRsyrjkvys361qOoZpdMER8QpGA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/dbf65449-bd68-4127-b39e-0a63b7807d01/107d0ef2ea0f771da9922f9bde0f04c4/dotnet-sdk-9.0.100-preview.7.24407.12-linux-musl-arm64.tar.gz";
        hash = "sha512-HMtritbi0y89J7I0eDzeAeJeXDGcqMX5AyDh6iz08qPMWIQanXgcOmPYoDtFg5HdRaFsltIKDE+A5XDW3s2A+Q==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0499097c-376a-4e66-b011-fe4996c96795/c3e842772e3edaedfd3410467b789519/dotnet-sdk-9.0.100-preview.7.24407.12-linux-musl-x64.tar.gz";
        hash = "sha512-9VjU0+iuQwzlRKgVcZf5CEhJmY+HiOJrmiD3QnYawasJwSQj4NHu0dO+16JXiLcX41JVhrEJd/m+xBSudqw1FQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/49e6076a-438d-44de-a34d-6ad47af02423/f20bca6b909e3bd42679c14c8288fd0f/dotnet-sdk-9.0.100-preview.7.24407.12-osx-arm64.tar.gz";
        hash = "sha512-Cvd//rJ+RLLmlcqr+oUlT5THeAe+bZb8ar3aHXG+JmhXMgxdwC1d+WjaiWOlLNKupLTK1t/GVArSa3tTK/g/2Q==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4a7fc24d-481e-4202-8654-06cf5fba0ebd/a4084481acd9aa803ad1ebf3cd668646/dotnet-sdk-9.0.100-preview.7.24407.12-osx-x64.tar.gz";
        hash = "sha512-tBCmXWn5kepVyB5ffqWMmM7vMJ1j3dIadomEikpFFs24mPjjZwKlVKUfwiQgz7/+emYqeFF1u8Hr4cM/z2/7+A==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk = sdk_9_0;


  sdk_9_0 = sdk_9_0_1xx;
}
