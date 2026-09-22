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
      version = "8.0.30";
      hash = "sha512-q8cwD52JNMGzYXGT3KLES6Aoi77QM8DfgGoDeHeJAhmsXcWxyMb0m4ultGeU0QeG7pO4meD9pr/M7ieUF7Il+w==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.30";
        hash = "sha512-giIGc4EddjzwUeVxDF9R3l0e9BqihQcNS3uaESuaRAEwSd/pWLcKIow6dCV+9DklHfgVe2Fj2/uWooY3wHcLtA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.30";
        hash = "sha512-7wEFGLYyv95NbsSKsLSsQhNyF29+5ggm9+p1HmIOrkO6B8JdG99xjPJSzfq/I+WxnhWGDLLXMp3LadXJ5OgYHA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.30";
        hash = "sha512-GEKeIsSa5XzAgp3zyZ1/dQUFDgikZv7Vz3l7311EagUWLk+6B65QTVUkSUcvTCOIat+k6IgNge88i6i1v1iW7A==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.30";
        hash = "sha512-gFFY4/EWhOAd/MfSr6gnvdCQzmHWjfrpWKITm3Jnn1ISbzx3oG+wcyNar5+44IYGUXzhJQIQX4PKYHhjJd4PyQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.30";
        hash = "sha512-+1q8/7kOxkAU6oqjqzNAgzDsZzNlPx0+ZjyVxfA07C0yRwkqsFEfiY0Ij9SO24wzwpdmL5axnIPcYKw0pFmtFg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.30";
        hash = "sha512-U4SArfVr2vpaLpEuja9yD1I+XS/EYT2Ul+1lsHHsS3FiyPZBhr6bmPcuL+Iq7B2z8lRL9+ETbs3Sv+hVWnf2pA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.30";
        hash = "sha512-EGbBpn5sIpYS78lxFdVJW69fhWF8VRPczAC2QwHgG8dUkYYKvdRQh3Z3LlbW3YH5Ll/ETxHCjmor8BvV7LYGIA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.30";
        hash = "sha512-PJmkb5Cx3frq83VHon27yqjZ8izkQD26pdt1ERU3ZYjevU0qg3+COFFXPEDqkX7Fj4x3C6Am5NpRjc4B2XpjVA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.30";
        hash = "sha512-pM6sXh7YZyRmcCMg3EW+q4CIBowX6KR9u/GgzF5Md2Hghgv/EKuev7CFuwkLb10tP9O0shD4HT+7vCyJ6ahdeA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.30";
        hash = "sha512-pIJ+u67M51EmqXHTNQMNuRPKmp1eCwYebj+g36Tho7WWXYylvzwxAvTIOh4kYcuEj877DugspMEJWY+P9jJe4g==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.30";
        hash = "sha512-Nq/xFyzEctcwBcRTFlllBZH3SwNn/HAmQFog+eyZjLJCKj9+Pu13v9wrzshb8Ijy4n/L8azFojct+FFKHWXqOA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.30";
        hash = "sha512-iJ02Moq4r2AsNeO+Df7LgyTpUW4ZZdKR+JdaqhagG9EXJdxgY+ybjrlbxYje03ME3dM047/piDvyCsWqhF+70Q==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.30";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.30";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.30/aspnetcore-runtime-8.0.30-linux-arm64.tar.gz";
        hash = "sha512-J52KuEthAsKfyWtZgIBegMZ5ojSr2+gEeqn1lUsmDdtwtK4Hk+LDeTNdIN+qbIa998i9fUQsjr48AtdbELyKTw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.30/aspnetcore-runtime-8.0.30-linux-x64.tar.gz";
        hash = "sha512-QV95Qg6fxGVGfMqyN/GLYJcQpxXr5DzTwFxpr5ddR0/dy+N+uDEWRHLeYHOYdCFsRR67+18fsEC0HpDkHcdyBg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.30/aspnetcore-runtime-8.0.30-osx-arm64.tar.gz";
        hash = "sha512-I8gV30XCIdVZvvbtPBrqdDktFMZaAuxtXDn4PrKGpqwMddyXoqry+q6qeEheXKZPVUNQ5PvzM0oUlNLfGqxpOQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.30/aspnetcore-runtime-8.0.30-osx-x64.tar.gz";
        hash = "sha512-/iKmWM497LZ3Q5xg8nIfrdzROcMKZfEJ59lx0LOxo/RvPtMVZRdCgDLlrH2lVYQY8x27n4DWMF+j23mhTox3ug==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.30";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.30/dotnet-runtime-8.0.30-linux-arm64.tar.gz";
        hash = "sha512-uQD7WCLkSv/BENBrnF7Tcu0BSF8wexkAvOoL0am8FmoQmjWrdBMnZo2Dov6disCpShKpT0GIvS+OHK30BGl6oQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.30/dotnet-runtime-8.0.30-linux-x64.tar.gz";
        hash = "sha512-ZNkhp6ecMsWj9F9Uc+i1bUEYDE6kEgS/Dv0fG5JJwuUJ7iGTQWFxOPo0/3mn9sqFI8SnOimltmFt3qLkMgTWLA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.30/dotnet-runtime-8.0.30-osx-arm64.tar.gz";
        hash = "sha512-PT4d5PeVaa0io1m1qTW+m7romdD0Nb4xXmNga6pvbnxAnrbzZ77mSkK+1RnUpZ2XhoF2yVJqv6S9EcpMofkOPg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.30/dotnet-runtime-8.0.30-osx-x64.tar.gz";
        hash = "sha512-yLxbzP3jrXx8MBdptjkqw+jievkN7KxYHer9ORg9Gq2oVwGMXizzzibhlJ8OWFZSLQURLVAEDsAZUb3vzBlhlw==";
      };
    };
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.130";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.130/dotnet-sdk-8.0.130-linux-arm64.tar.gz";
        hash = "sha512-KhB1RUVC2tHn8UxrptTLnA2BjMMvhZyFUJyBMDqJa7ihf+c8sIzPqWxTyEzP079kceKul0StOaOBJj5ALt016Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.130/dotnet-sdk-8.0.130-linux-x64.tar.gz";
        hash = "sha512-Tz7XARqST76dCTyrCH3v9e2bGfwN4CIhF/2nwTNGBcMYGLAf+9RFtp5Z8pT7TTOD/QD9GXAecUKst7yIubTsqw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.130/dotnet-sdk-8.0.130-osx-arm64.tar.gz";
        hash = "sha512-/20lYxNbdvTKeHNSozxVC9P5A/R+dqTQxfGHErv2GwQMui+lHBpVDt6++JvBZdWfP7MBJPd2s9Wjt1LPpY5j+A==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.130/dotnet-sdk-8.0.130-osx-x64.tar.gz";
        hash = "sha512-cd5MtwFiQEB0691VkBIOBrGhXjHYGVxNzi/pAmfLzHJ4thtG6uAecG8F2UxRIMNhtEQ0sayS7t8I58Onp/z7LQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk = sdk_8_0;

  sdk_8_0 = sdk_8_0_1xx;
}
