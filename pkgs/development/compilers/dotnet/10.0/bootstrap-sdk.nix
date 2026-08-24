{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v10.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.10";
      hash = "sha512-gE8O7DrRAI3Qir3ySzvdRl7DzVf8XrFfI0vbUXl2GHim3dMPdVol9DxwNh/Tzq9ymok1KU+2wu2qrF5jWNv1pQ==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.10";
        hash = "sha512-S/l2kyhwQAypM2P2bEm30xKsJQLZVSK7KkmvCqKYyDCeaN+13RLVRBwSe+3hS9FcQRwgIS8uUuUm15oSQntpCQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "10.0.10";
        hash = "sha512-nwLzk/KTkdBK8scY2LBpHOaMey9CGsfc2ndXraQoEsuEobLzCkK3XgCYGreNrGEszVZtV+/hfUQ99XWJwlYfjg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "10.0.10";
        hash = "sha512-WxmGaJtL47ad1wtoHCdlTVU1mgPCDQ3/vYWHSZyc3kuLRjI/3batqeD2orRfhXbRKBgnhbTE1t483sIALT2JwA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.10";
        hash = "sha512-pA4e9aTyEgg/W+9sPVaDO/zfdlkco0QSdau22PCbRF6oXcqHDwPGonrdWQAGOkYMezf8B99Lzb0qJH9IdmS//Q==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.10";
        hash = "sha512-tLPu++eOKgAyVtYw/tbBX99z5iHp0Yqd42mhvrOIkXb2yXW14Xth+EgAIYiJajwznfBO66Pwnyr+uFqZ4rSDqg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "10.0.10";
        hash = "sha512-aJ/1FPJiymDcZp6q8raAzOg1cRW3szuARDrHNwYix9/6rrlN6foXzahUm3mFPT/AjHS9tP0VsJEQ5zSEXMzxGQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "10.0.10";
        hash = "sha512-AK3NFdCYbCQKNUputEirayv/uQLIPcOncyuYl1jxrCU36VbUGhBp8FL9nrBRgvfGC3vTsu+ZD7FALYON1AQkuw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.10";
        hash = "sha512-IxKbZWV6ikBPmJpM1IBA3TAxirCayJ/83PbFqYKkAZXlsdHI74wT7/Lr73XCHeePJDa0EszXV9ckiXdeEa2lqw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.10";
        hash = "sha512-vkoocTUasco6tNZxoKzm0rU8QqtHtRf5ksjpeQPaRobgwz3a/mVVA9owV8fknupHNKAsqo/clyUbQnV7iTLSoQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "10.0.10";
        hash = "sha512-onIb57QhCIhNmz4o/NSyulCWEuiqdNYm7KW2jHyAKv63rKeV8GyYKitzd9Err0vvUB2/+Cgoc+XoYASCjfreJg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "10.0.10";
        hash = "sha512-siywO1kWzXGgWVBOV3Wy0oZvsrKkpGA7dNKvNfBNsx/B4rL7wD6mMpjhfPOE63d8pL6rqCf13ZGzo9mWUW2KjA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.10";
        hash = "sha512-M7oiYYtSsgYzHBMjuL4ROibbNy1Wkp1yYIbKosJccy219GU2Jh+5Knxldpyxi7K1fxCfxQLqE8k8OXkB5ZpfSg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.10";
        hash = "sha512-QgUpTC66r1gSB62oQ4p+71Y/46Mm9QXC1YJNHLzPb6NiylxiDPexh+bbevRwd/wF1kT5PdbsTaJcPd8mnudIlQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "10.0.10";
        hash = "sha512-UsNHvh0adk1pkfGkUtj+IoZO0QiiOVqIvJJCXcFqgjc9B1Yq40cMGnK04EUaBb3oHKgpkrc+Q2o2NqmqCqd4pg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "10.0.10";
        hash = "sha512-qXSaEO0PbM1CdF2h5wgnoyfvDSIDGCAu2uF7IIPWzZeCyZB5CX3hjQ4fcosvv/2OI9AbxIlhERy/98jgJ7MbFg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.10";
        hash = "sha512-le0X7trVGiaA3Q5t1MxHDI+CmVAOMD6ZdDWdmfP7SYePF1GFjXuawZuRV3GydjzFlo6us9f6fSbzfImVNKx/CQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.10";
        hash = "sha512-aBtCKth6hLH5uSd0l5zhKXub77x/B9rQtBRR7li1s/j/4/5rBG2UusqHShGzxmcGEsvLIe2YrWHPdgVIm5kf+g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.10";
        hash = "sha512-wvXLiOfFb1gKY6uBDbZ6xyxlmieVXJLvkmVjoxi7CHzo6LEqypq88xRYtCPX1pZvGBcOQIWHGxvQGvdaEn1oCw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.10";
        hash = "sha512-Wea7/9BeqipVadzXn54xWlUvMovC7rZVuSqslythntGzwlEFcGLwl0TLm0hol7e7qE2Twjtc7xwAcIcReZgPoQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.10";
        hash = "sha512-xScwy9MuoiEMYwYQd8jG9v76xz8HIJQtxTG6knw+IJoy5mdtdKdjBO5b8z/tcSIXY0JUuMZxfbB9lX7R7gA8uA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.10";
        hash = "sha512-qT5DaWKFw777elmcmj8TQrTw+tdTsBaucL6W+ylWWndGc0+FtcDjs/0WEdZaRlcdTOu7KmjyMgO5YvXxdQ7kUw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.10";
        hash = "sha512-TDvyn0oygOw20euEuEuo4jLcflyDwNnuV4VARBN0LXVwAJe2CpvaDdXJvqY2lU6C7XJItjz3wgjLKRZl/nYJNw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.10";
        hash = "sha512-TGF4ZEiGwjDWFSQcf3ASYnkN8BwokQ9oe8AacafOKY0Pt6r4hvueprXIVj2/7mMjyCSwEv9TEThP4xUfo7Qjjw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.10";
        hash = "sha512-eb/xl5MprW8gAwcsOgewQ5878WSfk0gf/VfrQa2OKM7/MVKxP38dABzqh2g1fpUsab9OjCFj0z5+OUnlOhFMRg==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.10";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.10";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.10/aspnetcore-runtime-10.0.10-linux-arm64.tar.gz";
        hash = "sha512-b1razZuhAv4sOlI/ByW4Leuji/unO+CuxML7k/CQwdQI3iLxzNLnx8pxySvPdBlcy541pipmnCHQqqgoVLI9Cw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.10/aspnetcore-runtime-10.0.10-linux-x64.tar.gz";
        hash = "sha512-Rxkkn8rKdEuO36W2UzZsq90l9FKny56WG4Zx3dL4Ds7vS7i3Tg+tiZ+T5cfIsTiJD/C9tJ8trstIlFXZSHpXKw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.10/aspnetcore-runtime-10.0.10-osx-arm64.tar.gz";
        hash = "sha512-54fEAmqSWqHd+m9P8utn7pW1rL7l8mJGpubudzJkwNYpbVFT/tb1BP4MscyPRjYeZqJ53s7HLT4jCv5d/Go0Zg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.10/aspnetcore-runtime-10.0.10-osx-x64.tar.gz";
        hash = "sha512-4A29BXpJJt95XoSR7bJOsoWFT9fak5i9i7uQZLmWcgs3C2tHIB+/XYxL0YmzCTV0X4iNyASvBJhakaLRIbwNag==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.10";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.10/dotnet-runtime-10.0.10-linux-arm64.tar.gz";
        hash = "sha512-PqKsYm/bDya7UvAlhK5eaO6IwnXnQLNNk5GK04CYXQ2/oWMsAXZY393F+6OWEUtidI78EbJYl4d4FKSkxQIu3A==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.10/dotnet-runtime-10.0.10-linux-x64.tar.gz";
        hash = "sha512-dLK0HuF3/nLaAnQdW6MOijxerUQVHXpyoE7YGgqTPoJ/X4z8wEi6To3lrrdlGVN2G3WGJ30LzOLgEyPKKcy4Ew==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.10/dotnet-runtime-10.0.10-osx-arm64.tar.gz";
        hash = "sha512-ecvGS/64BtXyqeCiou0zbHqidbBDi72I02I2obYgOVBUa0n/MHzFBnyJQ0/+IsAhpZSy+K2tcRRqXs6CVlK9hQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.10/dotnet-runtime-10.0.10-osx-x64.tar.gz";
        hash = "sha512-Qmn95dF77gkvR/tjOHwLsatYsh1K+OsOrRGLUdZ3/H2tqbj0bPPR4lRJwH9+A1CTjNdB6ILtQ79qsVQdzNSJ2g==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.110";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.110/dotnet-sdk-10.0.110-linux-arm64.tar.gz";
        hash = "sha512-DTvW7zQ9+8zbBlw/EkhKZ68wdy/SC4P1pSZ3ZKyvzGfMeCl8P1T9BHuJkHXxeYrSaePk6GTZwLer2fZ/qaQ2lA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.110/dotnet-sdk-10.0.110-linux-x64.tar.gz";
        hash = "sha512-BeWiLO+fQXSLvWNgKmtZUyK5EhTQO5oA2kPWmFAWSBNvH7Kk/mzmrZxoSqFpg3aCHIdTrwxC4za491P2wHj7KA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.110/dotnet-sdk-10.0.110-osx-arm64.tar.gz";
        hash = "sha512-oC/nq0JRualOU3N3L5mC8s/lsekazTMHmtTxGuKGogK11jLl85pTDWI0WqkgUU8VKjHHr/Id8jBmP1g4G6wLsQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.110/dotnet-sdk-10.0.110-osx-x64.tar.gz";
        hash = "sha512-a0FBb9slaf40s7pdtDrrvJVE5XrUrS0fpX38abOApKn08OHY681RX1KEhRhmNDS+4O79Tjx0d0mKAXkOzZn57Q==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk = sdk_10_0;

  sdk_10_0 = sdk_10_0_1xx;
}
