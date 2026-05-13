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
      version = "10.0.5";
      hash = "sha512-unnJquNAywt0vQGo/zeGot7T2h0vB2FPimnIe0F9grQj1RBDTOmStKHuTr/8TNd4F+tBXfWdBn8cp7+3Z1p8Fg==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.5";
        hash = "sha512-pUikpkbJmTObQh5v7CrIGshp2kW+qYrxUVDML5pirTLPga3LI8PFp/IGaApvM2vO9nCj4QXwLCEm3WDi/aXNYg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "10.0.5";
        hash = "sha512-lwuqcJBXzERKfQsvyazrysr8w/sTXMX4yEWHQpxVbYbbJ0Q3NYZuBFF5b8Kj95CotZ7tROihtaj6NSU5H0Fl/g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "10.0.5";
        hash = "sha512-xrlbKJinxm8YW7jJztS4jsWA67o82rK+sw0/3kB6LGBO0OfTWAAyn2wiM9nNGc7mwatWlaJsz1VpRnsFXPzhXQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.5";
        hash = "sha512-XpJ7rugEmUKjQMfXfLRcU4WrHFR6Oim1r8A/hASh/EZzr0/JqIzUMvi2xDr6d7Sz0Usdb6zAsJj1p3Yudf+XmA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.5";
        hash = "sha512-NM7MFm5+nQ/sic0P2iGXgxwDj/bGZ2r3cjK+Ax2vvvQNHIJl5knw8y5r9lFSYpIwE4gA1FN66W5Yb8rQopHoyA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "10.0.5";
        hash = "sha512-mLRe66IRBIpPbQupO82l/PWn5ZPPdQf3DcN+cSgpP58cgCyEpFj3Q7jCRRS3f7tLe9jc8B50yrybb3ztBJ8kpA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "10.0.5";
        hash = "sha512-4uwzf2oSww5VcpDeI66ie4uRAB/CVJtuvWjbSunQp7tSxJcPIl7OnCY+TljJak8yFpJcFW4BiMlUGMIKBpKKjg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.5";
        hash = "sha512-Gi+ZdJq9xBsllyMv9TJAVtlMXeMpAWf3ArxJ49RJ2bpSW1lKc1nWEVQ3xI53MgGQTSi2D8fk/+mFP++jvBxD9w==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.5";
        hash = "sha512-GPptAxSiLpFiXblT0g+ourLNofK6j30a3KjIt74OiFklg9Tr5M2MKhV8KfzJ7kqeG8jgviYuHy+2yZ1+8QchGA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "10.0.5";
        hash = "sha512-nhqDpYsJ0ZtIzmCz14yZxLGb3NWqi6+UUOvX8oWK4TppwB6k+BUSbxJqizxnZiPOdvEtDGgUg82Mjy85oDKZww==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "10.0.5";
        hash = "sha512-gvHj4jcm27QN4VdA88D5LesFQduNQhmOteIsxpmmT6RZSnvgGV5nm7QEAsAD8hcfLMJanC4LPT8wkSsXahSYrQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.5";
        hash = "sha512-BflTzFpRaQF4mUd+dqgYfJvLn30XFLUofFnUYE485BePeXXu6rR/tOS3cVGgM3A32wqabsasYPrRfykQWs78ow==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.5";
        hash = "sha512-zTRKBdj7hhJJJyXrlkcMiE+5rF/0JkiADnxVP2MRLyUvj4d0COAIsczwQgO3RxyYtsAgOiwwLscOWmb8A5pvvw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "10.0.5";
        hash = "sha512-CZRQIfY04HIsdEFKvgAvjv4yV9X/odFOhgAl7cEBFAdZAfvdnnpZpXEPGxBmQsA9lNvwDr610O0vVeDO4AKfUQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "10.0.5";
        hash = "sha512-wistTWcuIbhOz4BI3tYLnkY5w6IjJkk1QCbHzQHHX0o15qvsmMT1eb25CM81ZJRAwMSxPjhZLshPdTdhHPHARA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.5";
        hash = "sha512-ZajiQZT7q2tQtOM18Lk8SWVoCcYLKg0YXDybHpIast0mqM4DXXvNXDeTOERufdioEoxy5s6STiOy7BPN7XnX6A==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.5";
        hash = "sha512-Kp+MsuKVXftYrRfCCSG1iX0Bx9PXtE6dkKof5WwgW4OKwEmQrZR1u/shk0pXlTt/j18sALS2HaZd0sHuHjVfXQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.5";
        hash = "sha512-7/upjkbj/5xKViNzlVkYPq0hIwCnjApGmxRCLWdW3HBXdwVUrVsvNtvXJW1L58HlIK9/AaErmZMrjjhfbZMUlA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.5";
        hash = "sha512-S/cZ4FGOWCCdkeV7itqKS5j7kui8GDnJW16yAWCT6QRRkbXF0yP7NE18hdnEydZaQT8NjECxRjp3mkwl/xkawQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.5";
        hash = "sha512-geyVni1xsr4NPqWB1ygit+ewOhJv3cHoh2PKT1dP+6AlBkeALZZnAhyrSuG0CHgIE8+mpFSv/CxQoWPWqFDZ/Q==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.5";
        hash = "sha512-E49zQ382W6Tdx+kTqxwS/6AaWXhOn1ToqArv6Q52HQLEPzouYvXKZWgw5cPIUnqk2lDO1xLnWJ3WgLt5t3XxVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.5";
        hash = "sha512-gSNu28XZcmjXfcbd1k1/05Yt1705LtruRRvU8ISXYaSHDhBkE2b1ylBZEV26OfnJFdxfF30lGXFoVzk1UqvYpg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.5";
        hash = "sha512-vL/Xgnw66cgdg2cwwttTEJ5BaHokLhjjW/q/eWQfkGwNF8DchzR4PFoMKd+o3Zk+6I5AZneWn1mGYLpo39JS+Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.5";
        hash = "sha512-Pty0O+hUt8GO3kB3XY3lGic5EKgbMgzY/n8XvkBsaVspJ9VeTvlvbhffZ81vMDfARdeQ4uYXzd5a14NSEfdNhQ==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.5";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.5";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.5/aspnetcore-runtime-10.0.5-linux-arm64.tar.gz";
        hash = "sha512-bKs7gZELo+bhGFlaRZSDMfXRUGtCrwlC956j22Yj6CBVehdXlzvsua/T1vjq2emmQWZ4YPKn+71Zi8r6OPRznA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.5/aspnetcore-runtime-10.0.5-linux-x64.tar.gz";
        hash = "sha512-cQjs3ajiYH+oDitF8SCdevUwHVNDi2XSJpYFuEFa69SdsjRV2NzXfY/czJBMkgK0g0+couAOJ6UB0gBhdNdsxA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.5/aspnetcore-runtime-10.0.5-osx-arm64.tar.gz";
        hash = "sha512-uGWDyRjReUEAiAhE2hAoQwnQtlcGC5cGixJY319lsQWq42zF+H08z+JAhzro8EUMb/x3MI2OXP0eTLkYelKxDw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.5/aspnetcore-runtime-10.0.5-osx-x64.tar.gz";
        hash = "sha512-Grw3e0NaX5p0fELMexfNLoxgR02XH3GelS8OYPWv+iVp5EZkhiEhODjWhQbfgOFbKo8zI4IOfyLyVRvPEJx8Ow==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.5";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.5/dotnet-runtime-10.0.5-linux-arm64.tar.gz";
        hash = "sha512-4jd8PCWQaNhgO6WgF5DexHbd42ELLSXlco733GbqR1BXRuhtMk+lK/yfFW7R4XAziJ95RLdSr66YOova7F6Qeg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.5/dotnet-runtime-10.0.5-linux-x64.tar.gz";
        hash = "sha512-knwiavQKvaWYax05TtlL8ACKJ5aN5A7HAr4vo+2HGsarbSa5aLjMrT9IkSaMz4QLvUQBxqeli6rDyHtf6NyVkQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.5/dotnet-runtime-10.0.5-osx-arm64.tar.gz";
        hash = "sha512-saRJmrOWdccRiWFctymL5sgJaLbxEehabDflHdc/SYX2gkJcjKX5Zyz5vU0gjZZUxQKb2QH9C/wHKceNRTAQUQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.5/dotnet-runtime-10.0.5-osx-x64.tar.gz";
        hash = "sha512-hAyjxQFVv7pSZYYlEybwAU01Ew32BI3eIq0Z5ckUq6EBsQUXt1bO5xMC8bIH/iKxTmdaa+eLuJeManTHjTpg4A==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.105";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.105/dotnet-sdk-10.0.105-linux-arm64.tar.gz";
        hash = "sha512-MF3H5/uZ/NiDDTkSKBf/W04EiMz2Mcuc3H16jsHgQFwc93IaWgERVKWpbPzDl1xgzToEjV0OgADbVAWXlP+olw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.105/dotnet-sdk-10.0.105-linux-x64.tar.gz";
        hash = "sha512-Kw7RMQbkyFnMueOl8aRQ6EYF69ib2ErDRTswgQ7PpitpV7qqLtBBzC6TL1EhE+FuOuIA/lxLSL5mdndHoG9OQQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.105/dotnet-sdk-10.0.105-osx-arm64.tar.gz";
        hash = "sha512-kFi8F6r3bQLmamLhJuraDDQwdeQAcx63QVUvF7nMOjPxhUEV2W6TfU45GOnIBdtb8q0wm8RciSIoxOdTSDktYQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.105/dotnet-sdk-10.0.105-osx-x64.tar.gz";
        hash = "sha512-b9HYoiXoPfpgO0uniMR37zQFLW+7KcH6FXRn+xmKAHEHgnqWGk2u4S8uXSctGFxUpfJeYe/hkEPG/xVD9BF1xg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk = sdk_10_0;

  sdk_10_0 = sdk_10_0_1xx;
}
