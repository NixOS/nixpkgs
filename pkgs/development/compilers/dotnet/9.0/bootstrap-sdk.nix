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
      version = "9.0.18";
      hash = "sha512-vGh/bA/cj8CxyfZJKjRe6aixbUfWa0HBy4LSpNBUnxAsKXcfjUh97lpipX/b4+E1Uy71OUTF4xT7j1QGF3uTQw==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.18";
        hash = "sha512-NoQjyiu/fxfwECe3AvXQfSHPI1DmahNnQ/mcEr9TlDfeb13GzfVh6+pLEHXgD5iWJw7pac6rlEL694DJZq3jlQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "9.0.18";
        hash = "sha512-c9Y9yao6owWnxd1oxNOILfJj1zJBi7cEqly2ehPoIEYkPAnYF8mP2m27U7LcGAXwVv1/TIdrKdHkYiFXOMEmVA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "9.0.18";
        hash = "sha512-Q/JtnudUYnhb2HfwXiKXi1rrxTvALnUKqFANhOfN4CZSlOZQ49zbNJS2ELuiWoE/OGwngMP34k/F+UtYZLQ7LA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.18";
        hash = "sha512-3Xs9z9YbsQX45FZWcmlmvYXicA1fGK+n18nvVvRDPsYEAr7TFBIpXSmBHUBoVbRVBodflz5/jznsF92kv7t46A==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.18";
        hash = "sha512-rK2/A4bphL6LXl/6nhsVQKs0qH8mn4CvdaY9DZAcvP+NU6cqcXx3cya+DmDqwFSYQHcaobqS5wdqQt7mqY5iWw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "9.0.18";
        hash = "sha512-sEzak50cE0yUHS3ToYgjxJypbHl4OZNSW7Izzo6BPctuRpX3ZgCi+04aEypckEWIVdOV193Au0vbzUi/kMYQLQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "9.0.18";
        hash = "sha512-dXYrhSqQXpPZ+5/DdKCzjiToNJYvrdXS8tgr6ZDr3hKBkKlUoWyvOZnoFhrVStH4tEfp4pl2m5YKhImjrkOtiA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.18";
        hash = "sha512-C+QztmpRlb0FMZEjkKacG7XG7exk+48ix10EGkBaL1gc3Wz6DN9Tq/Hz0FqAKYsizIuFP0fruroBCeTQ3uyiVg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.18";
        hash = "sha512-mc2gdXJ9UI/8ogFVEFrQCJjM+UjCvs/9eKS0UPol9HtDC/jBFk5srFnYh/VjxLx5h6LusQ/hqm46rd5HXUasVw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "9.0.18";
        hash = "sha512-ytMEDWDrgXWXfd5uAHSWJGzypiPKeB4LRglC3JNpQB/4uaS8qeoqO93U7mfb0OXiTNeAWd0/PsDQo1GchIzmUQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "9.0.18";
        hash = "sha512-HunQHi5eIVsZnpDskC+DD8rw4SN2MfMs3nBwB5Qg3wA5vta9xrQtkZFiLDbi4QYHoAqAHMEFYiHXStVMFxR/SQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.18";
        hash = "sha512-q1CleZJvR0hl/mp3MkHMxcTJn2frQVgsiTyGOquKFqB5kvEzvQsrM4UlP6OqLf5m3JZTzsg+YXatEMgHqPVSkg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.18";
        hash = "sha512-OI1cIweVR6vBRo8zoltpfgHkSx7XRyUVkTdIP/hk2Pd+2j/+1ReqCEnT68/7b8sG28Sl/8eFut8y1ekHBeTSQQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "9.0.18";
        hash = "sha512-JH1MxXRSCxpS+gOnIecIiOBbNyG8QKS8cUZA/KfjL/ShXz1E5YyfSPyqLTvBThdcq6OV9GnbITbt9XPtera6QA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "9.0.18";
        hash = "sha512-CIijr2deMGuV6LuHiL5x+R7prmC1WG8g9/lkh8Y/6G4wIUjm+Pr9QqxOkJH2/d+SKObSAv7m9XgRQTKwgF6l+A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.18";
        hash = "sha512-BOOq9ybpYgEmvDqj/Mh6eU8QuQ+zTgtQFkO1EYqfVyFUK8pbUU/lhyHsydet7UJbp44tAhoJKiauMicSDZcW5A==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.18";
        hash = "sha512-3j9w6ITFH63hlbrhER1B6hCxY11wFoE8FCDFltPUUMsXs8ftE4GTJUa2Zh1WXEAHllDMZoMwsbTAGCckRwIZRQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.18";
        hash = "sha512-l765I3RFBBqY4raH9NhrrsUnPvqR2nphHm7Hzdl9cNPe2iv7nIWkeRBvc9xEr+4AFcmlzGl3VLgZpctR/CYECA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.18";
        hash = "sha512-8w1M5ugcGFU5ktkzALvvhGwxeYicf0R3csoxvpW2IiIhWDEILGfcovNWqmIVQcBLLtWDTo84baPFiWziqZ/4Nw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.18";
        hash = "sha512-79wzG/nHH7yLJUVf0jYTeNY1s+jWLF8RZQhacaWAk3FHLw1Bb1IRkPDcEdKPWAdFQlfZpuokcCBQf4cGCRQ/IA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.18";
        hash = "sha512-ALNvbnl/W/SvHfJC3atUGe5Pc6FxlIJGa2zp7Ay5u4njtfBPu6wKp7pOq6g+pd1kWLd3QlKZ/KbAgUt5BFFL+w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.18";
        hash = "sha512-regM2Oa4eLL6lFTXv+ABf01F6ClQKqcbH77+I1Ll3AHDM51P0iELKDDP5TCZA8nnk7VEY43k2U5EYmx0UJe1YQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.18";
        hash = "sha512-/xGK2d4NpSGTK7Z1K5CvvmGIG7THye6xTV1FKV7xn+SNk7lXoUA6SVyKfucc5gkp2UrwHzbNz7E7WSGqxnSjOg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.18";
        hash = "sha512-WcDLnAa6lXW+yu66gXTjEJ0dDThZ3wcn/uyT4tnjc2xe4KAEaYwVW0yxBcdGJ4TqQHcM+NYXfrTg8+H5CiFxRA==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.18";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.18";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.18/aspnetcore-runtime-9.0.18-linux-arm64.tar.gz";
        hash = "sha512-B1wjLkzIY0hpk2jc+JpoxaOpOGdqOtz3C37SKufkpbVDoj7+SXkKAL+oHKjQeVwrVhBEtipiq+Z8edSFo1mwmA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.18/aspnetcore-runtime-9.0.18-linux-x64.tar.gz";
        hash = "sha512-Qi7Ntw4kVVqppYfYBI0IfeKk3glmrXPH6qPbi1IfJvPjnRK/YQYXaRXGuBLZNkEbOnh57pKKfDRUT84IMOrS1A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.18/aspnetcore-runtime-9.0.18-osx-arm64.tar.gz";
        hash = "sha512-NDq1E9+CoLEapLmKEUPh0cF46QbYMV5IRxEm7VEa7f60N8sSsHe4/AsyILIs55uaiFBwO1+bX4g9zojmmTU6VQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.18/aspnetcore-runtime-9.0.18-osx-x64.tar.gz";
        hash = "sha512-keWKx3Ct0j1UNHUsBovruP7cu+b7hTe+Ia8Mzol821LSia31yQTnO0HMOeAveRy69wudCcHcRDwVhnr42THaIA==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.18";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.18/dotnet-runtime-9.0.18-linux-arm64.tar.gz";
        hash = "sha512-5YpVm12r8BJ61SuBoveaCBYsOYSvBOLleFdV3HIrFuJuciSMgnayHczo03AAB7ncYsgjKUeL/nbk6eA88CKWyw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.18/dotnet-runtime-9.0.18-linux-x64.tar.gz";
        hash = "sha512-l+uJpaN4G5dh4qhQmWkSroG5aZYInHirzrvEQRE0VwiL/L188fqX0wNvesj+IsfTDgQ+k+yvyRDwe3MxfHO61Q==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.18/dotnet-runtime-9.0.18-osx-arm64.tar.gz";
        hash = "sha512-2dleEhQjILJbt467IdOXgHt+BUrE8Ull89cEpY/YmehfJsIfRrHuy+lHwukleti9fdVAm+9K1/UejdtFFoQHpg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.18/dotnet-runtime-9.0.18-osx-x64.tar.gz";
        hash = "sha512-+QhvcBgP9+YzfCTwv1CT5d+2as9p09jhvZ1bbmTYDIZpaYanPF8SXuNxpz6vvhLCHTNkG9H2JM63/2f4I7Jk3A==";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.119";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.119/dotnet-sdk-9.0.119-linux-arm64.tar.gz";
        hash = "sha512-o4wcPwLHLKWAdNhHOlcu+YwiLdz5euxeC/VG91eMCcocS2hSNGIVHZpYpM89WEMJptr8jQz5+k9zT2W8kQ5Urg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.119/dotnet-sdk-9.0.119-linux-x64.tar.gz";
        hash = "sha512-J3GDQXjUxcpfEebCrqwT1rD2+V3G0RaFCSmKS+ODdniFNfdPlnXes0cXSdS3YIp+mOdffA8gWurvCuqh+XtyIg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.119/dotnet-sdk-9.0.119-osx-arm64.tar.gz";
        hash = "sha512-8ArSNJ1r08gGp5+MzFdToorrwqfJpgu4fNmGha+OTe6PPpX9GpNb8uSuiCmPYk9kTB1IZjZluIYfZMBLvaG1fQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.119/dotnet-sdk-9.0.119-osx-x64.tar.gz";
        hash = "sha512-H6tule2exeouYc/W47z8lcghqAHkjxJzz2lVQfnaWnmugvdj0w/sdd8+Cq5RHpT8dFjMWJ5a9oDjTvaLirrMtA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk = sdk_9_0;

  sdk_9_0 = sdk_9_0_1xx;
}
