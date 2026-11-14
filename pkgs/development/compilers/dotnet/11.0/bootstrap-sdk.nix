{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v11.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "11.0.0-rc.2.26504.105";
      hash = "sha512-C33EHQmEOKqMVN2XjbYvnOP3Es6J1bORvWJizO/qBZvryXrQS0ireuHS8P2rxkqGlLsvzZTLWrtXtIYraNem4Q==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-JzEZRNFdYLktEHRK3ypD2kMavoGQ3bZMHbYr6GOMuX9Gg0GyzA4c/3gfpBIybGdEaJ23TPeeVJnCYCsBGky8Aw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-sVCmZSwotXZh06ozP9Xh/Ym/FjllHp477xQhEGxe7EKGIC51h9sSpa7iwLao7NMl2VXwgUOOEHJaEUFGc9exdQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-2exS2FHyzP4/98aZUGtLOnYTiSqpNlkNG+hYpA6k7UhM1SLN99xfmdTxG1coRI//8xflo3/FLHWwpB9QaqryKQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-hTMpYTm3X/Idl8bFlFDKRooegyhzCqNPLkYbn4Tq99s96eUoWtb9i+OzlajfniREfdYFICNRLgmulyjSP/bXFQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-lQDa/N2n9fET92E6GZTep4l87dfPOk+Ym84E8HJ8uUbjA9o0DB0I7SUVTSy9gfANjkWXRr6M9MeLoKOPCw+OIg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-82eThvZUoCPW5yGmdbGkkrp8IxTnrIf9eQ+srpSkSw+Ttc7K7QLrsXTY3+4cUtB+l019kT+YFmWSwRGvlsGm+Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-xw0IF0lxMB9O0Mo0GW3dq/AR98L6fVkzah6cGZ7U4X5EskAXwktjp/6P8x7I9CdrGHbR65BGlxZItUgT2W2h5w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-R+QLUJqwo7idy5D0NAoP9uRfPWtEsELbbKCHLfmjVnoDyD2uOAP3J9X9ygVTGzulvXtxn7Gl2t6vd0pF60NMMQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-sVWv6e4um0YuMxn5Ow9ipuycsdpYQJlvzqg6FtOMrp44YjOku02WRdPEBuOno/ovhCeb+zpIdx22OATrDfJmnw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-/toWQyGPT2fTjCb70+CBY7yLHm49EPWh0qJ4/OFjEpR9AD/g2dUZOsQwHXoJlNVNwOpJ2Jwg9xt7ut5ugOjOWw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-D6OPYnNLu/33XS7gbXSVRQP57r4BaZ095C9FSABEhIitT04Pg3i/y9jO8KkGBd/doqfuWxUVqIygq7x40nOwfw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-9GYuRIHvgOLeVzDihNGmTcVFc1BhQJyowM6Oju6AiE38VeJIdzl7GU7ezcTZlVvh2wJTN21jJgEaYjaezSqBng==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-kSjWH5TR6G9p7bMO6x2R1UAr3f7HfCQNPzpU1ZnVL72BSGPNNx5Y0Mo1UEvpDMZ3cRJ3N4dGorUW9WlTagf27A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-uxnybuCZHvFKHLk9uDLJy5JJpCr4ulXmRG7slb8P018ULssaiwc5ZQQbcOp1ETwIuIp92qqXi2tnIaViSzLfLA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-LQYvg0IZ90i3Mxzkkm9YZO/iUVu6IYs4aaXMz6TddIAtOEWE1Nj/w7+yIVrsRjR9mS/4EoHEva+KE021V7ASbw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-yLqI19MBlNRmSyBbSXVJTvLpzIoEj/mm2OlteqxjCjfsQXjiZp/pFm6/Sta+2OAq1xGmfGd0Vw/NN4qiZVlPnQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-2hsEUJ4MQt4ufogSq7iLu9gm5SvehdTGlW3oDuYSXj/1hCGXxsqonRBs9kzHq4JNIYTl0eXYwo1N0pjrLehlIg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-uTSLzhuvhWslzfmO6uSUNDCDKGLVCfbFJbh7TygL+4T5x6askggK6DFLZCUzdAKqtOL4v4jK/3pEauW1vMIezg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-/9Ae+bVRuAZYG7q1sqhYBOocbLzJTvieyh1gDUjTAdNYIsJr+MphEszes1aKsVvkMW4jNO3+vGIjkMpbxuLs0Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-rWOxzM8IuQmToVJ+8uA7NKyEeNf8rAcgy5auxizgNG++HLkomeJexo/wCBZIgnU9zJZVZy0qVHkE6tmKC1M26Q==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-A2mytG36vwyQ1bOCYUIvKZLrcDq1QKUvQcJpDZ7l4Vp3lQBF6kIOlY5N+3n0LsdX/XZfGnvk4RWZ8Brn9UJmZw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-IA3i9Hj2x8gKHX8VjzoQa/+65K5KH/EzcZ9Wi9QI+vBJ6pTwq1fLV6+Cj8g/OB7ZBn1zlZRRqSOOLX6xlk2GyQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-KdeE9r1Z5Ycg5/Jlzk01WmFn19bxi2RCVkay/AkwmcJwcQn+SAT+W5AID3MSj47ufe19KMzoPxWeUMyaZWPDcA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "11.0.0-rc.2.26504.105";
        hash = "sha512-lXX3Jk42asq7OI3w2Kmn3bgvHumEdHt+1UCKOunXPnYRlP5iHGkeUHWJSZoFIUCsSrDoxmzFERJZbwQ3Q1U7ag==";
      })
    ];
  };

in
rec {
  release_11_0 = "11.0.0-rc.2";

  aspnetcore_11_0 = buildAspNetCore {
    version = "11.0.0-rc.2.26504.105";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.2.26504.105/aspnetcore-runtime-11.0.0-rc.2.26504.105-linux-arm64.tar.gz";
        hash = "sha512-dumAYGoW7cogTNvmgmIgWx5BNI/onZZOqGKj29gtWrAXvbqWvoYlzJG+cfUCvahQ5A29Rv3Y+ND6G/a6GJkRFA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.2.26504.105/aspnetcore-runtime-11.0.0-rc.2.26504.105-linux-x64.tar.gz";
        hash = "sha512-IabiG/64wE0yhKOooRhP9I/k8flcn7MgNrbmErRSnx1d+ndlBlck5dm/BZl531q405M4PPZFe3O80afpG9oqwQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.2.26504.105/aspnetcore-runtime-11.0.0-rc.2.26504.105-osx-arm64.tar.gz";
        hash = "sha512-5S6huMkQOxP+uiX6AWb+H9p5a7c5D3ZLidqaJLobqToam1XpXf6IwDjIP08T/37E4Pyrv3tTbi5JKNMEpyKJfg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.2.26504.105/aspnetcore-runtime-11.0.0-rc.2.26504.105-osx-x64.tar.gz";
        hash = "sha512-cHdPFVSLALT9TWfZwF2HClHYVkfBz61KtEELbZ89MdRV2py6QSu38Y38cb18onRHxDYRZV3bIeShPUONhEXK6w==";
      };
    };
  };

  runtime_11_0 = buildNetRuntime {
    version = "11.0.0-rc.2.26504.105";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.2.26504.105/dotnet-runtime-11.0.0-rc.2.26504.105-linux-arm64.tar.gz";
        hash = "sha512-5xy/yQLxZZjZ4cV/XUI5qAPdri0IZ/D59dped1kDiLG7JBTVhuzmUC6Lf9G75iVwwJAXOUjnGj9nfNlwpX+hQw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.2.26504.105/dotnet-runtime-11.0.0-rc.2.26504.105-linux-x64.tar.gz";
        hash = "sha512-WduIE0/dkBL8bEP0AYGJ0z8/88yHFyL4piBddfEU8tn1vHFgU2GIjKD3SRGs4G+X+bQZ7rMW1SC+DCQQMSM5IA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.2.26504.105/dotnet-runtime-11.0.0-rc.2.26504.105-osx-arm64.tar.gz";
        hash = "sha512-5Qd6lrPk4NlBn1il1ju5bodKFDpzEPbjLP/wNMJHF4uMMjbqpZSY/+3SLz/R4wPRgoCvpj9VGLMOwNhz+0F0uQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.2.26504.105/dotnet-runtime-11.0.0-rc.2.26504.105-osx-x64.tar.gz";
        hash = "sha512-IE3iFZufRFwQwwFQrgompmfvihyyvMl8UvCo+ZDi7fJ9SCngCOFD6xlD1Afthbq7oT3b/FEZqik+O9zpC+hKfg==";
      };
    };
  };

  sdk_11_0_1xx = buildNetSdk {
    version = "11.0.100-rc.2.26504.105";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.2.26504.105/dotnet-sdk-11.0.100-rc.2.26504.105-linux-arm64.tar.gz";
        hash = "sha512-LrrqJjuUKK8g+X/YtTeeEkjyFAHoNFtSkDh/9d7tqEZkOU2i+exIBFMFbDB+2KToa/Z1IZ6QSm4dBrFWUlqpWA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.2.26504.105/dotnet-sdk-11.0.100-rc.2.26504.105-linux-x64.tar.gz";
        hash = "sha512-VOlGMzkzfO9o9FXpfa2sCp4bSUFqOxVQS1dxRLJK5LTu1Oe6O6xQdlC2Ht9wTpd7RifTgE9MJojMW9abTy7s3Q==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.2.26504.105/dotnet-sdk-11.0.100-rc.2.26504.105-osx-arm64.tar.gz";
        hash = "sha512-bnRzWfLXJGKmLwItwtbzc8zfhLO9wR8RCxeXuEatE9M85yvoo+GeUN2z+j7vyMlOZdY8CwPuGH+i3BgynRp92w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.2.26504.105/dotnet-sdk-11.0.100-rc.2.26504.105-osx-x64.tar.gz";
        hash = "sha512-VVKxeHM8BqReKT7iYaMlbc04xaUwKR1Pn3Lj7Kv+DEhMyvKzvA9sexeAQj0z4TTgSLhm4iPbcaetTwx7KpV2EA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_11_0;
    aspnetcore = aspnetcore_11_0;
  };

  sdk = sdk_11_0;

  sdk_11_0 = sdk_11_0_1xx;
}
