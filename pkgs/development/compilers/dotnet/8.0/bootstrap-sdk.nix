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
      version = "8.0.29";
      hash = "sha512-So7cyQ1DqVWswW05BrxkC6dRpyz6bFtGFL1PqGtDQ+R+KXaYkXBM1nchq3FpUdxfvNnFtCnpP2Jz0HByIgLbzw==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.29";
        hash = "sha512-T8JbvNfBQhgeYkkQuEbrGdQe5PgDYL1+mSjpuQcdoKw/dAhUulelBp+qND22/oox8bHkYfcMME4+/kBLZt6dAQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.29";
        hash = "sha512-DZR4wT6pXdPuQyTzK4sEAMe/+5XZJAIkYhMUQ+vUIXZmHWNodm2kjxAFF8E+XmdxTrKBsAODwg7qeErfwlNTWw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.29";
        hash = "sha512-8TXwZy+tUbPdyg8TyvKPYICm5aGSr1pzXu52/CK5G5IBIrhM7lmF5bq+fZyjC5voZZAWmBtKg1/CGyxV87JhBw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.29";
        hash = "sha512-63w6MPBw6qTnO8LTBZXJjpQZKl4g2PdMFsl/WnuHIUHH6xX4XbQ5Znxee0GV64+UXk2Jb5cWJrS/AfdE7hW3SA==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.29";
        hash = "sha512-dPP2jtAgqEZaKbr89MPxRe0cvfVvgT23Tzi/IYpOxnlBlKhjqYXVOkBWTZ3OAmGIo3lmywsYkd2/aVrA/D4vEg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.29";
        hash = "sha512-F+x1YJDJePhuFFoDfmEz42bWB1UzbStAzOtUAZQYXGucZK9U6x/D05/2KwFa7v/u6qfCFz3B/V8/Mmocl10A1Q==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.29";
        hash = "sha512-jPamPfiMdPQQG1Uh33v2R9sl1iEmstMd+1347F1OM/3dZxz5HW9BLVoozrmaHK8EkbBfjkiFY7PSJxCEmsVtGg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.29";
        hash = "sha512-+QSC3Hby6bbiDfyImo5gZ5Safe68/SmxMCYDi+o+SelYeWDjycca9ggf2PJJ8FxF82UabON1fza5EOFo7PJ83w==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.29";
        hash = "sha512-SWhJfTl7Q7XjuZJZDuvmav0CEwcGaI/dlcX9HnvEI6eipaa/7h0tTNTHR5v5N4XCJ+sJfiojPJb5JeRFf6LCEQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.29";
        hash = "sha512-vNVJ8u0XEUzuN5xKvsI5ey5dF1s/09WR12ul5OQJsQn+ThNCjneH378LfUa8k0Mwb9wF1nxEDyUVOT/jaJv/yw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.29";
        hash = "sha512-tFKB/+yCkoFC74iTVYQT0RZX+A/Ekdn2gd0xSWmlb+1aNHd63YD6zvRQZseXezB8KOCpQN3BLy+nr/xg48gJPw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.29";
        hash = "sha512-SAPpghxpxNQvvdxhQK5gqAYLF9yvghfFJt38ADXBwAMtJUobVY10NFOqQFpMLiEQ5MBgGY/LapcunHVQHFnerg==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.29";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.29";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.29/aspnetcore-runtime-8.0.29-linux-arm64.tar.gz";
        hash = "sha512-j44xL2PqTxmLp9oDTnSGr/ABqprqLtmr9LXCU8hEfQtz+ijDAD/zzsifRka7cwxAWk7bJMX+51njYwzAOSXG4A==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.29/aspnetcore-runtime-8.0.29-linux-x64.tar.gz";
        hash = "sha512-qq1LnvCajhoKAeMrPVB4WBp1mqbtgLQrfQHWVCmpiYej1LNN6/jU3krgnNycDRy2R+aHElo3G5f+N8OAvxiVrw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.29/aspnetcore-runtime-8.0.29-osx-arm64.tar.gz";
        hash = "sha512-xNK7R9HcxbqHww7mqwYxZd9alQ92nXduUOsYsuJxJVRCSOLcEXYmjzg6xZw38AHslz8pOO4Z8ABinlFsrJGGIg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.29/aspnetcore-runtime-8.0.29-osx-x64.tar.gz";
        hash = "sha512-+f7bIijcvrKIRRuyUmNEO5CU1nJZ5ZhCjZl5zVKHNqRLd1/H+8ClTYxU2WDjUt/zAuSY4elYjkoBqMhtqC0g6A==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.29";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.29/dotnet-runtime-8.0.29-linux-arm64.tar.gz";
        hash = "sha512-LhnAKtGNtYPInwT8Y/OENhFMduY0bY73doVLCI6G9X2+81NZCwc7Ekh3coH4SxvHXMOikxKJKH8Ew5LbnpktgQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.29/dotnet-runtime-8.0.29-linux-x64.tar.gz";
        hash = "sha512-Jzmkj17IFzjQU3b3vyay78UpdjnbP0dItFjVS/eVoITFvUeIZEm5mW6xozcbuMOQDXIEno8BUNClrIIw7zimXg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.29/dotnet-runtime-8.0.29-osx-arm64.tar.gz";
        hash = "sha512-5gopv+k2ori/5mjlI2TOZD6a6mZ6MMHs8zb+FBhpfoUgiVhTibo3mQvRZ/VzdgyFlY61oRra9pYKToEmI7vP5g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.29/dotnet-runtime-8.0.29-osx-x64.tar.gz";
        hash = "sha512-oxI/M8NiWERnsPsuUAPx5JOiwBHoGgCvbgW+k20ya6X+9wwU1gJujLaPXnE9LeJY4xVsumDg3lU+Sb0Y3Wt82w==";
      };
    };
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.129";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.129/dotnet-sdk-8.0.129-linux-arm64.tar.gz";
        hash = "sha512-Wwbe7Z4otLzO38nAh5l0t+2RRq60Rcov6mw+R6cRqJjTFAFA7SV/at+BXQIN1ArOnXfTkm8JWvFOkMIsTdfUeQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.129/dotnet-sdk-8.0.129-linux-x64.tar.gz";
        hash = "sha512-KaliC5RQp1RxSMnVQx/iWsC3NsPyAD/LJRK2cz774aZsUgHGrPR/i7I2HXz/MpOfEOmR0rjL3YM/ezOsmeNFxw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.129/dotnet-sdk-8.0.129-osx-arm64.tar.gz";
        hash = "sha512-XwhsJkWnt8nUOlwWtjF3jwqUwQ4dRdsTys3hzqfxJD6Na6mZjlFbf5ChpMj+mBzTlRNM86wwUsVlJBAm9sw6lQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.129/dotnet-sdk-8.0.129-osx-x64.tar.gz";
        hash = "sha512-feX9GZrGOJtYqoTDT7Hch33QLUz1LlhVp9rvhhDIzYUXJXHTI4gjnvwROGP13+Ro+Yu7egTZ7vimADY8+aGnZA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk = sdk_8_0;

  sdk_8_0 = sdk_8_0_1xx;
}
