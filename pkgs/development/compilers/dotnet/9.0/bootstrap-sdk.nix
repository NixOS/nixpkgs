{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.17";
      hash = "sha512-3+NwczDPlHGYL1Akidm9gvd/5NzWqhNcfUY8Tqv9YOLNEjJRfBBdi+8ZV9klbreFhiG+bgLZDIQ0/4pGfLoG1Q==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.17";
        hash = "sha512-i8mMBlJy6rbkR1CA3Z685XiiPrZ6tVa34wil9f4PN+dPIdmYYMR7e98ps8T/UY0e2D2iiXqpFtO+oS27UtqpcA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "9.0.17";
        hash = "sha512-fZi78WnkuBd9TjqXzoiRY+6f2VTQhWR8W9oDtcmC1BsEsrUAhfThNZfc4srr7lSYMzkLsruxAVKmWCDX06ckkg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "9.0.17";
        hash = "sha512-nyjubJz2DtM55UOOdC8GZbKNpsb/HignCAPQdr7a5hqxPgtgAYGVTsPmhDBNX3Ul8rEa9LxFqzDK8qIECRp7Rg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.17";
        hash = "sha512-dT8n5W4efuyvElpZ4MUGU+Urvp2ryyJKN3nRasbS6vlUynuDxR9vnYplXcwx1+WNnXiq5Td9FndJFjmiqEa37Q==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.17";
        hash = "sha512-bmDFH0ZS1fcGv6RuLRO8ibRBlPB0FFbrXBVhoWfAqzmrZCOPyG9chYbfjOwXTxGa8Ms6r+6BmVkX1vnJ6d0yZg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "9.0.17";
        hash = "sha512-9W25M/gVU5o+0lsbjySlZjI3MQd4rUaGtRoo7q4Wr2KzjIV4OZDXUkcOOb0p6TulmalBBisvA6YpXhq2ZcqrIQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "9.0.17";
        hash = "sha512-lE0eV2RzhV5+HFsy0/T1pOndEp2ZnhiJKcGOThXTx82HcMz/xTlFDKOI1aCP+USkIjC4vzwMKjRqXiGGS+Fwtg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.17";
        hash = "sha512-v8Ia2eGjQRp1TsG9OC93/GWJ0mJOpRYQWtaSh9nBVDttSHUzcmonU/2TQi6zubN/Mj7jxFgDZe/p0uxU5fnirw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.17";
        hash = "sha512-uZwBaiOGUxQl4c9royJvKRqyFazF8L6Dn4agHhJEr4yS2/fNDnwu5Nmw01P3C7Xis6G9dTjCFWgkoF01I4FsXA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "9.0.17";
        hash = "sha512-nG8p5wDj3xG8OLOylc+CnmJ+SDjDgvCf2tM2/bJzKFDrHweg/M3t1y6bfs/EKf99kDubT9N2pzsKtuGmr3nalA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "9.0.17";
        hash = "sha512-lZih4jQh1+Ho/BL6vnDBXxoKiDeghNmQgv5zFfZUBRRUThSg0B9psphJ1VvyOLHx6MpJejte6zLRC7TRBpo1rw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.17";
        hash = "sha512-gj5mqE6mUnMt39u0kAACDVi2BHxROgJtH6NMu3xR1i69dyAVLyRjZue7+Yw+9PWzzl/GE1zprfF59aoJzMIwYg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.17";
        hash = "sha512-e2mX6Wg7KPKibfLLdyYO/LUKUrpLrnHAGtzIaFP3IEzRhfQFcp0unkf1MG9zkgzPYpuOu1g6iF8YsKdnmFjuzg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "9.0.17";
        hash = "sha512-kFvXj4yh0nxhA+8byZqS0Sbp0tPsfLmeCo/CyAxnJS7IenWER61609n+c/OSwRRUhoh6HCwGdGTOZ+wx5bBM+g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "9.0.17";
        hash = "sha512-4/gNpVnfQR1U25pBb6eJGzK8bX16Vhv4iPUudYNLFFIamU0PNTvuZUIwsUPOKiAjzsFjq0no1VjMuHEyY7dkzg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.17";
        hash = "sha512-29zjTIv3z8396D8o0nYPcOA8OcBZUu229Q/RCrNqAF60jW+WBgeaaw32F8Dk6nFgFDT8B4y9aR5Iovh7i8VRsw==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.17";
        hash = "sha512-1sBIS6pBipMSKlRpH4caGUopxD4peQlsDumGhpHcthmh338LCecP8Nk9uRIs0oke7JXKwV/OX4Xe6HrETCK38Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.17";
        hash = "sha512-grKg4od2++Et8RDvjyDZCmP+9d7wBAtKPTDYUo/NxOEFgGefBKT5P3Ga0I0KWrrkb4rBoHpz+9bFkpLVhQLgWQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.17";
        hash = "sha512-8VRhMTM1oBHuDqG6i3pcYRqFstZrqTDmrDfvZHUofBIpU3PCzq+kXSwSkIM940wNYsFcKvM0moySc+3pSyL7OA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.17";
        hash = "sha512-8MAZRJi1KxVu1OxdfpvLBL5p6uq6k0Nqbrh+xKlXs86YY7AajkPJ9KMkT2ArfL0xEZdYiRyg+fBaca06RH0kYQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.17";
        hash = "sha512-NGcFXzs61HnI1xLspKNkd7Yz7KY4vZjAJY4gKW+H05ZhKKYG6hjYE+tr+negiK9qJ8rjIhTNFZJwOF1EE4gaEw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.17";
        hash = "sha512-9Y+KohhgUisoFHy7hT3dSoHu4Tu0xxxvwbCWFbUJZu/QpuYvqdZFip7hg/KSOoPOhHP5Vuf9h/AFePjLzZDJqA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.17";
        hash = "sha512-/TXj4s0Blx/7TtJ/Q04Dwyou/+WNw6ukxGv+253Ptk8y8OKqsdotu5GbZ0Oq6dUfkZpmiOx/s7w/dyokGGmZ0Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.17";
        hash = "sha512-TDrpPgoviXR8Tyt9cOt60h9J58YSYU6o3AK4px7ipogwzdy5P6mxYdc6JmAJ9bIxadtLJVk8eIRy4Xk8pG9Wbg==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.17";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.17";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.17/aspnetcore-runtime-9.0.17-linux-arm64.tar.gz";
        hash = "sha512-bKBCk8JGsUhefbUedDxTM22HuOksariZLW0Jct6E/tCts8dD+vylhQgZnK0B8M6odTF9ewzZd6gsq303xnwZCw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.17/aspnetcore-runtime-9.0.17-linux-x64.tar.gz";
        hash = "sha512-qAC0en2yvr1BindVOyMvmjCn0ePaDnsHVyh4rDp1z6gxf3yWmreLeazC6Mus6lRnVm1BCN7xFbPyZZN3Zgqrig==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.17/aspnetcore-runtime-9.0.17-osx-arm64.tar.gz";
        hash = "sha512-FC06FM/8bnWQa2Zih+CrBdMzb+yUa8/HXTSWqLgMD5vX+wGjNaDvnOjXyEs4fwLUaREKry3ZGq2c9lEH6XCHJQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.17/aspnetcore-runtime-9.0.17-osx-x64.tar.gz";
        hash = "sha512-kkRNXXbRXs0ersUqjE4ut0pP2WxL11XFm5s2Q4omNikqgTaqVy1s1bJnguo+CIl2LHof9ejQ6LRPrhQQZZgOyw==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.17";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.17/dotnet-runtime-9.0.17-linux-arm64.tar.gz";
        hash = "sha512-HOVdpUsXyUCfJgtCkJEsQbBP8Wvf5vk1uCI3k2tHyIIrJMzBKzABymDiuBXQKFGNHom/vqItc9sGa+Lc8pM25A==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.17/dotnet-runtime-9.0.17-linux-x64.tar.gz";
        hash = "sha512-rW/D7nK2RF6aM4XQljNhriwmCqct0Wu1LM9Ewjq+aC9wvqiy2RWF8T1Y7NdEmK3TBb++CQf9c7YBgPwmqmV2NA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.17/dotnet-runtime-9.0.17-osx-arm64.tar.gz";
        hash = "sha512-u9Xvk094hC9g+A/BrN2YzqHCbm7LCrjetaxYgM3BjMGA2J1R4KfATHo3EwsVJnN8gzqZY8Kjf8nzZYYLpyJFug==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.17/dotnet-runtime-9.0.17-osx-x64.tar.gz";
        hash = "sha512-kTFYYYF19WDeNAtVbsBYBr+E/bfd/7YKyTc2RVKlKhjyoZAS544rZsN9kKJunBhWljBZCgKRlEkvNHXQFyNo6g==";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.118";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.118/dotnet-sdk-9.0.118-linux-arm64.tar.gz";
        hash = "sha512-ut2yaP1jS/hy+dGoYo2SDKCNY6U80VwbAS+QryA3t1vgD/WZIS3G2GhlGWDtN0serJ//AnNDc1LA4MzHtgdK7Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.118/dotnet-sdk-9.0.118-linux-x64.tar.gz";
        hash = "sha512-HHu6cYRjzE+NFiy4iAjroU7h5y4myEtfN1HDMMYqSjGvX5iv1d7rXCcgObXcZJJVzImvIB+NcGm8Ah+rSdGExQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.118/dotnet-sdk-9.0.118-osx-arm64.tar.gz";
        hash = "sha512-UhD8oktZlk5ctRVvJAVLW7QdQDE+df50kDxPIv4Zvub2i6Xq06W5W2eFtMIOzid5iD97kvPsF9DGw38uRkOymw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.118/dotnet-sdk-9.0.118-osx-x64.tar.gz";
        hash = "sha512-0gjEt295yyI42nN20yEy+n1iZ31Bw17lb699MY3BNbbQYQTZDcCcR6GpYsYe/aP1fNHsNqDjkCCaGHaU5a80xg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk = sdk_9_0;

  sdk_9_0 = sdk_9_0_1xx;
}
