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
      version = "10.0.13";
      hash = "sha512-0X3X3VG/W+UmO9EiS88KlEQ8wppRe0bctvc5b6qu8tFBxRFfg/NBwriNeR7LMYa0AzNachpvtmkXHE6WyI5zJg==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.13";
        hash = "sha512-+oFHDejFRowp86/LQ1YMNf3uRWc2v5IkRAe2za/khdJ4zAbc9LuvVAv+XRu++/Nziyvj4tFOB8KRPtMKXBl8IA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "10.0.13";
        hash = "sha512-HFBUUKWc27tTuzFczdJdmZp6Xc46IDZpqCE6hxDuPckTuKaIFL6o7yIoif4RQlBVtrXR59KOsjBprq03Ebqr7g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "10.0.13";
        hash = "sha512-PJmSzSteyO+AZX3HiLl/O8A+/kMI43aKJKgcvEb5SIBMiyRfvqL2BbEITw215lnP4K+zlfg2KIyVCmeCvvwEKQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.13";
        hash = "sha512-EN4+Spucp/yPiEVTygA3FTTy9noYDxnUDDb9mQ6PB0BkSn5IN0lhINOPuqh5Zxj29NJU/59E1HEqLzbO4TFEvg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.13";
        hash = "sha512-xCcpVW3jRLfLScyeXIDiJSqpFI2r5+a8SEcjfaH8Htig1CH80Uk+h+0edGvPLaGEgwjJ/70mAuIhD+WXteH79Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "10.0.13";
        hash = "sha512-uSJCZ9IKd1RD06U2hquvRYqKdfS7kSuo2ixG2eBh+YMbARlTMbzxSFghBHyV2Z97pxr0kNoKnXRhrwThFizbBA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "10.0.13";
        hash = "sha512-rwhA0w/J+5Gd6s0Jz7yddnBpyysiDTTRIeNga0g84vYk4WwENFTZDEVnWn1+hgx8yejRjm2/1cHIBBZYJZwuaQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.13";
        hash = "sha512-z5EQqXnArBulOqhgGZ5OlTknvQbLyuXCXNFYDKI9nswtixz24WvG5KqOxkw59pwTYiZ4Q/7aYQnvFq2SDQMcaw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.13";
        hash = "sha512-TIxscT7D3tTYA3oRAkjkLuOT6Peup8n6fRvi56RGkDVLVaOK6aREeNnMYva9uD/PxQsyTDvnmpIHZmM7yFr4gQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "10.0.13";
        hash = "sha512-99l5PJ1fQb2/a4fOVkfRIEr6/WhcqM0vDU+emtZcgJLjjbHsxAEJC3XsxPxj1MhPqzdxBL/DLxixRHI4KJX93g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "10.0.13";
        hash = "sha512-NgKcAogXwUfzDlCd9DZZP6tz42LuH1225L/FC+WfTfV9t1LydY6YChBnkuI3ighhZPhfi07ZtNqfbyp+fwZq0Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.13";
        hash = "sha512-yJ3xUvojbSbYV4H8r3e3COtAbOoawASogXeR3WLUJGc8GSEAeJagtuKrZy6aE9VqCupXU8Hqrb8hnK7gVzniZw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.13";
        hash = "sha512-uTisbEjLVlrf4gAkvlA/mkJe7ISbhfasVMhMayPzOiw4Qv3doTPfPyn2JzfN0ZS7oKES1p8d7hVNmBzRtwu4gg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "10.0.13";
        hash = "sha512-LxXiBuMNJAaArwFxUEJwiLQBpsjsnNlX2i/eF0hED2wX8Fyjt9Dd9wGmJrhuPn5PBeQzmK0NI+PBg876P0eIuQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "10.0.13";
        hash = "sha512-lS9+3bvleyjJ7hRbFy3tGt+PzOWrFuEjEE/tAF1uTievva/UIUeI/r6Bfqlrmw8UsRqa9osTtV+LODCJbWhM1w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.13";
        hash = "sha512-RetqimPTPg/yCy+h+qswPCjOB9xl65i5HBgpsrM8HdvKoK9LAB2ZCnk8fVlwCmMKC5fyjo/ZpD4D1H2nGg3JSA==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.13";
        hash = "sha512-eVv6CPHngsyet0EQLuXxXa/R4OLyZfEd2M5eNPMO3lHuqaCmAneyrmuQLxOgcOf7cLEHgBichXeePqx6C75/4A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.13";
        hash = "sha512-8UR0QzIs/ZA/5SkXoHZiCWJEQvrLQlJlnUJt4gCQx+KDT7cANolKPyX9gsH4E/+9TFdKJs/tfH37soRCwNL9GA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.13";
        hash = "sha512-0/onL7C/TK+A0kkCqMHWU7Ek9Y5xTgzL+Iu3f796T7tGSU+nCNELuAqvgf96Bz+eqE5hWZExam9QHQ1pQhBkIA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.13";
        hash = "sha512-/REkglvNhkHTaYq+6/YVY2rjleCzgNhgJ2/7bEvpy+38SyktZh19QmNm0261frVAGv2OWM5CtxO9rK1R6JYx8g==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.13";
        hash = "sha512-/EFfOaa0F1geXvwzCXiNvGaV6mqdNL7H2sJ6vLQ2mkMxplZKyRXdxRQ+L2CSw5JQPQF1Q+U8IEpM0kLTeTbL8A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.13";
        hash = "sha512-t1bre8Gyn+Lp1OEm/5dEr3VZGscoFOlY3vWxVfs7OuqLQKKrCYue8Z/hxEPvSEO1u6aI/BObW92rbbC0ajKUqQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.13";
        hash = "sha512-Jo4hEcZA/rdEl6NVO5iQDIiujr5Lhai/2SSgOIIsx0CnyCz+rjY3D3S6YlGR1AVbk9x/yLhBXRiPlyXz9n0y2g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.13";
        hash = "sha512-FnYzH7x7GcAjBpNDzxabDPO8Vx3BvCSlcgusHolPhOKtHdoL787gCM8UHsEtE+ZW7/dPAAzLG2e4vQ2oJtyBRw==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.13";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.13";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.13/aspnetcore-runtime-10.0.13-linux-arm64.tar.gz";
        hash = "sha512-f3C/EvcdCUk3C11mga2XAtE/Xx5Hb57I8EVcVkqbaeT8pFXT0gGu+FAP738kRVsnh3IVIjPVo2odt96a+tTtNw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.13/aspnetcore-runtime-10.0.13-linux-x64.tar.gz";
        hash = "sha512-eyDUFk8Jfhz2FtgXS2pkvhAObzDcTgKLFuVR6LDIbf8O9CS7S/UtH/DsyjjhAtP6gIFOBsuFoy1u7kw7mXZPeQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.13/aspnetcore-runtime-10.0.13-osx-arm64.tar.gz";
        hash = "sha512-sd2/bERBz0k4AWuDZgZfE5lVHUOgsS5+ay1FNVqVUPTzn2lEzduuPo1pigYhOx+FufjiJNnaqOr1GiBIoGLecg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.13/aspnetcore-runtime-10.0.13-osx-x64.tar.gz";
        hash = "sha512-JB5O4LGnLrAyD1B+lJO9Zv4TMc1XHfz6si2T2KIa5n9SPIgGoXeo3wW0xe4q7eN+JdodwBv/xYKxQ8CLQJ0KYw==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.13";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.13/dotnet-runtime-10.0.13-linux-arm64.tar.gz";
        hash = "sha512-+fCwjn11/5UoMpJQv/5YQYqcHWokZ7x7wZZZt7OF1nxWbbhHfYDqTAh7St6yzAW1HjPsR62Xe5fx7tfNQzvoyA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.13/dotnet-runtime-10.0.13-linux-x64.tar.gz";
        hash = "sha512-lXTZU2QRBAlBZzXnhCeW+NYUwh10yyXSBKPkz9EbLAXv3xnKibgGllCgT2St0nBZZ9ywS4Zlo216PzCl2MBa/g==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.13/dotnet-runtime-10.0.13-osx-arm64.tar.gz";
        hash = "sha512-M5xbAxtf19ZO3ScxSh0PihMguMYfmsMFwdTNthyUvEOEgoZ87qCdOPxxlNoqBeaoaxZJkqXseT6j1lzM4OprrA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.13/dotnet-runtime-10.0.13-osx-x64.tar.gz";
        hash = "sha512-dzz1tjVlxKA0H7VFfzR8ZEAc3HPtE840+ILJlPyMKjEcVumfdkPx0EiQ9KyK4sRSTmBz/VQmDi0+JTjtfJUddA==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.113";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.113/dotnet-sdk-10.0.113-linux-arm64.tar.gz";
        hash = "sha512-UTFBQwNFnZdSvvAiyJ7GgbcFluVEVu4cePGKUvuSM/vz/bGLV9AT0THxIfxkPY9H59oBSFJflamCqbdKxYqQEQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.113/dotnet-sdk-10.0.113-linux-x64.tar.gz";
        hash = "sha512-HydG02hO94LEMI4FbnCek2GALgguQBr/N2CGgSUAmoruKAP/PuuHWH3GDHZuXcT5v9YFHGYKhWAsyJLDH3IlbQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.113/dotnet-sdk-10.0.113-osx-arm64.tar.gz";
        hash = "sha512-H+foO0cDfhdWEVBPCyOKGNlVieFBOiLqRN5D2KW//Cg7mq29WyxN487yQ6xdAWfyx10i5ecZ7OpLnghwfKEFCg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.113/dotnet-sdk-10.0.113-osx-x64.tar.gz";
        hash = "sha512-zA0pqFGBhsowA+/pocyb7evJxU3sUVc88go/vpaUvfOEyYZciqBB8qpGkcDr9DHLOHh5bojs0X57v7RrPNI7hQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk = sdk_10_0;

  sdk_10_0 = sdk_10_0_1xx;
}
