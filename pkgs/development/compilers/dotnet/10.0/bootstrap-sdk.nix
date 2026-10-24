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
      version = "10.0.11";
      hash = "sha512-hMVB326ViZa64sqR9bxmf4oB41LMuaTrGRfihXZw3dylFRFfZPutLwJrKZmdisSvBcNM6kfuY7vtj9vdR9IbuA==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.11";
        hash = "sha512-ktHa71j6xxZzaSYVn2HKips+N5FI1BANjhvRqeGf4oW32orhMhI6kSNtt9M8qy8XStB8LyNiO7kZnoOXS2FhBw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "10.0.11";
        hash = "sha512-9JPrO9bbmHl9HK8UPzs57zILxc/irSC516X+XzHPwlzpCYL9aMeN7linRiE+UxtzZy1A223Dolr2jXSVPr7QBQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "10.0.11";
        hash = "sha512-81IzS8gr4ALeO4toKuwOTHZCLC2h/MstyDKSVGJyUHbtNU3GZtxt6rTkP3PhxyHjg/Fg1/sWrydNCevmNA2SvQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.11";
        hash = "sha512-EtTwxmg9PfefrrT73nNntoxnbHN7h4X6LlIm/ZJq0T/9J4uf9MnlDzAru+HwNof+f6hOvI/kwwXxM+WDPJ41iw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.11";
        hash = "sha512-kb4KNaI16vCAPnlAttZkf8oIBRHoUgj2wUBhc9BciDI6Ue/WNv/EGIISiUIpelKgF/flafOvexv/Gpt61Io/+Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "10.0.11";
        hash = "sha512-8ybmrjBHA6LSL1348beg7JmV35gBxRZA+nC1P6WAcLB9fxerz2PUJj/PIELFrmWt7CCHJeQahKPM05g0pLOoWA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "10.0.11";
        hash = "sha512-qd9nAwFm6yTdRjzB/kYC5V1ZWHEx0D9lSMtp5NVnGRg8nFT6iOmE0946fRqeV22YSrVoihkvymE/V+/LRke+ig==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.11";
        hash = "sha512-xzT3xSscegBsQMjf6IOLE5Bf6b22NjeEkCvXba6D/1Xx+ieIysxzZliW2Q9CdQflgU7HvzvioYNLoATowC+/nw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.11";
        hash = "sha512-Y/8LzYfB4LT6GPvqmfsKx3+LkTzHoaRP7rn3dC5kRc84Xsiio8oyEegPPP5P8XzZDeA3lG8YzA6cNMZQgjRRlQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "10.0.11";
        hash = "sha512-qBL6mDCXONMCVnpyBjnyE0F8Gw6Dzqs95TMlaYLG9AaL+RbPIqoRE0NM5g0OZCGXgo2YEJuRUvzAKOMsWz23mA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "10.0.11";
        hash = "sha512-lLC312LPXZCQe5x6tCQpMNgkI3KPBNg1GQbVXRsu669eyvpx3NBnMEl7YtJFv2uw7mX6wuEBul3xPuBL980Qtw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.11";
        hash = "sha512-zqZTeuF7gT7ZwAgO6JMuJfaFDzqsrxU8UvYP2q9ZxRWHDOAtsxMtp/8Yc+WUPl3FJGi6jw6KJx8AWYeLQ4JXJw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.11";
        hash = "sha512-mNepSLSVvthaN56/UO0kqqbjo3svV0yTQu2BHaKYYTwkePP208VyACgyElVqTVXNA5uKFN1rfw5AWcOG+Z5+FA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "10.0.11";
        hash = "sha512-Z0Fuv6PnZAYLVu8FBbbeXDkrxelSP2Admr9shitvurOqXqtD1Qnw3kwKY5nQLzgBwgMqGqsSOWpsjqbHc/D23A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "10.0.11";
        hash = "sha512-KEPEO4fv1z46Y6Ru8G0KNHAgzNK+IjtTJI6QsCRmi+qgNJzOBMnBI9jFC9iMLRVaFzeWbnaJtmCXI1C3D/Kcpw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.11";
        hash = "sha512-BAQNYmn4y/pUeNQSya5QllcN8VHebtDuMh4a4m7Onq5j/x1Mr1N+1NW3qX0RwbW6ePrjtW7WR+RFKTgX5KaDJw==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.11";
        hash = "sha512-gDHFTYuhJV+0Kg+lmwS6CZWqoAc3daRCktKmvZ4PqjLD9h9ZNNYKZBhP6Y6hnaq1V4T4qN7M93dVwZtUdRpPeA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.11";
        hash = "sha512-2lKSs6dpNXSgX9Wuj2iasd52IPUL/VgP7YLb4CB9OnytsjFfVkQEPIAfIe9Dy2ke3Lsm/OotZVNjJAJcnak5CA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.11";
        hash = "sha512-jBVAhk1hdU+IkKJ1qkUODvsj9Q+VZlrsIYwECWgL5ItiGprBVzoQPxJg8Ei9ZZ9fTn1QmcYRMu9g0V/HXmkUbQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.11";
        hash = "sha512-ef6XpQH4KI7lukxMuXnh0iDM7a60cR0tFiynPPmRK7TnOHZXKpwIlPd341kInZJvMw+u2B3qaHb3rVEMIxLWlQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.11";
        hash = "sha512-JnlrGXHx2XqDHf8SX5rclpBOhB9fyOvcjgRmYV1P4g+bqmBP2ELulaXC6VZ4eZA3Yk/281EUNTtm5JRafvfmrA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.11";
        hash = "sha512-7+/J1t8Daj/Rtrf7ySI0ONwPH/pGXmIClDQKVXnv6L6WBfYBC38azortAsqPRlvJw+UKodGl8nwydxNlxedxCA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.11";
        hash = "sha512-+cDuH1GmIRK3/3rvrQnF9keE6Ry0RVCXu3xN91riR/hseQqhZ5UcelODFgSvUxspKqKaF7oZQ5kJS2dQw+0rbw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.11";
        hash = "sha512-WvFD+6nJ8zBDoEqGru/z2Id8ifSm7/Zr/+wkOFWzxQMpRBByYyPxyjaiVLXMB3nYdy0KqeLQnYmF/IcJAuN/WQ==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.11";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.11";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.11/aspnetcore-runtime-10.0.11-linux-arm64.tar.gz";
        hash = "sha512-lUn3pZ1db33T6WW/iGMWmLI5dK/0401YkDfWrpo/RDOQKIG00j9+GGAquVSCP1vjUBUFSm7MtXBBsPINkoc+1w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.11/aspnetcore-runtime-10.0.11-linux-x64.tar.gz";
        hash = "sha512-TGvgYjMwB05pnauAhL4Vobrrt6UYwN2M6Z+Tz3l3fNRvOjjvnSXtwVLtYG8IS2Nza9nkCC6zLRiPw1e/asTR1g==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.11/aspnetcore-runtime-10.0.11-osx-arm64.tar.gz";
        hash = "sha512-cikD+WGArQJeYC55ZFAMh7A4X8hiv32zwXTV7iDj0HQE4Q4Zw4vVffCB6rCN+KsG9fXTSfoaHDtsR/aAUsMJ8w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.11/aspnetcore-runtime-10.0.11-osx-x64.tar.gz";
        hash = "sha512-P+1bUkNrtKR3lV4qy3QQzhAP4svrln6bYN1cTd3ewQhUri8LiVy++4Y17U3joJMz+xbo7jbLvvSbHZYydY+Gbw==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.11";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.11/dotnet-runtime-10.0.11-linux-arm64.tar.gz";
        hash = "sha512-KnKaTv9qVeJxs659Tyvpiu8W3yLjuTFoJ1WOIE94gbvwt7n468+xoUGch/vLigD1vnK2R04CxpXDCyxSuvtl7Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.11/dotnet-runtime-10.0.11-linux-x64.tar.gz";
        hash = "sha512-ZMd6X5jW38Yzk+1dL+1HwoVcfN1DIgCLOxPh0LcQrvwfun5WYS8l9+iisbbO9c93yzqDT/NoXnI60oZwPDOW2A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.11/dotnet-runtime-10.0.11-osx-arm64.tar.gz";
        hash = "sha512-6WqKgQjVo7cOgnVnskk+3lQPNwXBIJ5/NHNrpqo5jdTQ0V8x62Z8nMo9vNMK2DsxWobV6aE/0sNw4vwM7OckNg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.11/dotnet-runtime-10.0.11-osx-x64.tar.gz";
        hash = "sha512-ysotsQD/gd0PEfLQS6HaiR2quaAV2tSqfdDPYX4qBc+y7kOU2k9FW8YnSNig908Ah7l/zqBfCGkat1Zy3Xm8Vw==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.111";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.111/dotnet-sdk-10.0.111-linux-arm64.tar.gz";
        hash = "sha512-HhFd24UJUNRRTWo7MrLReyQKTw9As3IC305b32gyoOVGci5r+bntfffMyzTfX15IvLB1Mi+wGBW//G6cI5mfDg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.111/dotnet-sdk-10.0.111-linux-x64.tar.gz";
        hash = "sha512-quIhvpajtRDVtv/+/GnYrS+llaFDAplBkxa7ccZfJgpFfKmvJNBE4XCbKKkRh5jKr+xTXM/lj3dnxay3NcADkg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.111/dotnet-sdk-10.0.111-osx-arm64.tar.gz";
        hash = "sha512-AjEkZ46Lubpobi8oe8zxTCvfRmrrEUgZrkJWqO7USk+7iIpXruHwd7gHD6WMYR/TOwvolPyLDKsuzkrc1APqMQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.111/dotnet-sdk-10.0.111-osx-x64.tar.gz";
        hash = "sha512-lUlhjlnGFd1H4v08XYl8b738Sjzj1pKPmdy/UeMgI1lUGp029ixs2NDtMqphu8TsGRsRRtQc9fsRIfA+dvSEtg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk = sdk_10_0;

  sdk_10_0 = sdk_10_0_1xx;
}
