{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.26";
      hash = "sha512-RIgTsRnCZZSH69C/uXfzPtzvdAohdstS6F5h2z5PIsFATsSjsYXQ0Nl1JLO+1LIxDiayEOsqZ6yKz8BGVApf6Q==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.26";
        hash = "sha512-uaNmF2d/+QstnCMuD94VL0+MvM68o8gPGLAaIHzAiDqP6TZqdfMZ30BiNOXmSXbhZh556dL3JSYa5rA3LQLtBg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.26";
        hash = "sha512-iCzZRr2JImT6u9HQ7cwEFY7dUxPjv/mcp+Rje9bWKa8vZ4o/wfleWLquaKvoGyKVDido1UhP6YqridJyBGVbOA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.26";
        hash = "sha512-C44+jO847tR78uttPy7GlT/bxQEVg4WWjU4NLdvfiarM7nH1gqDOMk1tI0mrCu6f0j0QlVKiiS41VH9hAMpPeg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.26";
        hash = "sha512-L0THs2RNazoQ3b49ubo8B5cAX9urGlfia0+qKDdaUGSR+VpNWLQk+cIU3GMY7D//Tji47H6CbWHi1J1nqcnW8Q==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.26";
        hash = "sha512-9FSKXZUv6R/JlCBxyxzKwlOaaStXfOEDvLXbflu/DquGxPAjVwEJkBYzWkIftg7uFgBxSGry/a3BKbdKQdgegw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.26";
        hash = "sha512-Ebxq2Q4fAYC8ilICA88Fll0qT0nBpJgA5jtk9zb0wRrfbnxXus8AzIK8iqNdtweNu2pXz0twvDj4F9USNw/fkw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.26";
        hash = "sha512-ENcMrkBwvVf7FA9BxvZ6xYPgpQkHPBQDz2exfiq5AqCHYBqDFDARV5eYDADHVqSGXkhhpB7kI95YPoZxQFu/CA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.26";
        hash = "sha512-oKU8ONnBahbPcoKpmY9BMgmO+XcgAvhMuUuwzhtYpsnwRl8xBgst07yngSznNIQicD60JcoBkwuluRFWBYk46Q==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.26";
        hash = "sha512-wrxqpEM6yBhMG3AjsrrFIfQMUCT03+LaENxcvQErmcbLeXLGKIyiSUFY/WZJDVTt2+y5+h4iOFrxQ3ueTLIJbA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.26";
        hash = "sha512-yoR1Box8QktWwo15Ww1npYaSDmQRo05drX2PLIACiX8le+P8gLjP8L2X5/lVV5RauDY3AWooy2tSHYpRfu9XnQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.26";
        hash = "sha512-7LivwV9qDKyvdM+aw2JdVQ5ZT8RaKRRLsrBjWRX85IiHE9NUUjFQ+6Ycgbu/SbX20t3qpJaNE57S4rTq0ccSHg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.26";
        hash = "sha512-GBWEaWyG9Dt6ccFBCWMrRM9GNkK+MRaMjQrNslLKGLOXzW/FqvB4+/vQuBK9CGUTvpQaCsjSf/McJX5qiGE/qw==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.26";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.26";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.26/aspnetcore-runtime-8.0.26-linux-arm64.tar.gz";
        hash = "sha512-k5afgMS/+idqVTilEz4g6or9Wbf4P5Ms0HSf83My+Fyj4+npD7ReyOL9GoFN83O2F1ZYCIIxE+KRH1tV0BjRnA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.26/aspnetcore-runtime-8.0.26-linux-x64.tar.gz";
        hash = "sha512-Kl05v9stc0/XZfgGv0vmE4vI2bRPL4ruMlDO1W6q1MDkvwYUHexu8sakao+vPY/9YLc2G2h/99i0UXnfNbsBSQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.26/aspnetcore-runtime-8.0.26-osx-arm64.tar.gz";
        hash = "sha512-OncrRQfwX9dMocq00h8ljh/fdFLhz3DKjVEcNq/pYSjHA3BzVCCe4f5be0lEG60aFf4dYaQQePqE86oBryOomQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.26/aspnetcore-runtime-8.0.26-osx-x64.tar.gz";
        hash = "sha512-6CZo5zau48dvh6TByDMzEeTeKLr2OVRS3co+cmFiaSkGjZ1eA9DAdQCwEcN1qrFKARUaVYVp/oxGl3dREF0lQg==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.26";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.26/dotnet-runtime-8.0.26-linux-arm64.tar.gz";
        hash = "sha512-iltpWqXf21oaqB/syNkC/7lCFrXNaQk+wPT8mK2kboCQuEGiJJkgorOtJViUYFzICk3Mge/zQK4HRSGQy8yB3g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.26/dotnet-runtime-8.0.26-linux-x64.tar.gz";
        hash = "sha512-rwrDrqUBYq/2JhKIOrXsujwN/nzAxQ+6cDQv4HbByrJCCBz4TR0TCkYT6otIZxOaMjRDP0Kmax2G5NTBdO8HUQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.26/dotnet-runtime-8.0.26-osx-arm64.tar.gz";
        hash = "sha512-P1sXpxA7Rn+5k+nossZHx+XesCQTii+yvmQiWRpmMZaKJYTVvo2JuFZgT+YAGeHggOddcGPgiyeeR/aMpaz2ZA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.26/dotnet-runtime-8.0.26-osx-x64.tar.gz";
        hash = "sha512-EwJ0956UC7vVVhKTBNpRId/wQdXnEMoaR0Gycm71+/9xpQcWZttc1/lnqoXXxZo30RRrUg/o94pLGDKo/7ly4Q==";
      };
    };
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.126";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.126/dotnet-sdk-8.0.126-linux-arm64.tar.gz";
        hash = "sha512-VVkRkfVvAK/cWgEH7KZWchcx0MnaCou/GKARrhZj2wlnsOr/k791FDXjryrQBbVmZhTSSAPLW7L7z6KzQF9CDw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.126/dotnet-sdk-8.0.126-linux-x64.tar.gz";
        hash = "sha512-8FTdSFH1b5j7kRoOjVmjPGH4Owvbg/0doMMa7z2AadayfNjzJC+VURuHk0z6py8FeCToEfMG3sb14enX3c584Q==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.126/dotnet-sdk-8.0.126-osx-arm64.tar.gz";
        hash = "sha512-PfCRCqXe6dli8U7vH57HZinRfD5AHDwNVM1cGn6n56pCmlwkUCOq2cM0npZRJEb/Mtbq0FF5JYCcuG8oK84vRw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.126/dotnet-sdk-8.0.126-osx-x64.tar.gz";
        hash = "sha512-OUHeXeIRNUgERj2CQHBjoLag045tk4YnzieDL/2u3GMvZLmbFIjWCbkIEtMT2GbsCx4T+VfXKwe/00Ki7KiEeQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk = sdk_8_0;

  sdk_8_0 = sdk_8_0_1xx;
}
