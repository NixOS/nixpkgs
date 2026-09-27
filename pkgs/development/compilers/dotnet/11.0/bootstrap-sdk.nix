{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v11.0 (go-live)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "11.0.0-rc.1.26425.128";
      hash = "sha512-IhkhoUu9QFuaPvj+xouXXOInU1bazgYuwjYRHOdvvgvS7FpHT12G2BU8XhhaiUPqEZ1FdGI/D40mJyK1CvaNOQ==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-b1vOv5csjimGfY/RYcG3//FM1jaInyL+A65U1/p3qfG5L1LxNOj31Q6EmHEO/9HRCUqa2SCwoC+ZuMckqvv73Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-CKnX5v6X2nNOczIX7EazAeLxPXddmjKESvHfUIGowbz1crb1sgzEA/Jsm0T8Sv7ZfyCHc5OSFb9j9Ff5R/XUtw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-9JRF6LpBIC3eK1JiNjnPHGxjZNEvHI/Pc3YeP1VxBntFFuaXLuc5xxn5b6Uq5cvUsZe0vmG3rPQ9hdRb/DzOgg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-emPGSJ71cJopLbkc956vyI19qDikp6Rob3WVJSBz/JBoYnDBd4KFFwKFw7yOCzQdgJ52bz5apYpOrdf0ZupTcA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-ad0TOIiCRRK/9ZIphF8G3XgkjOVOgvLfLLWjDzYC9QSstZ3q5mxf3ihU8mpZ5gqYFGesDhdJNBxaAkbV/2MnbA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-jj0w0Xo9tCKeTdi585NCmPrM1BDtMMreZDkoqhpBDuQlzBHKi/le1LWXQaxR2s/hB4VqeEtvEi43RYMer80OUA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-2BTpGbhwGYsRHcWdxMX2tK3DdJKRrTas3A8ItS/iX1stHO4FEHvA0+tpi9UwKIvIQDyW+/9ZnjhWYifLexjPvA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-Ri6KqeDkRtfS1eMTwsBhX0DsZwxsCKZqoNTU+LOvcnytQAy6MIq38KdPqry0HMOt3DWZs3FkU1eM2QB709snYg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-2TvIoFSDGvqsiZjCUxchJxjeFrqaEPSCCEamG0d2rM8BhttKs0XM4bWfrEVh9SA5eD+WZICtu0cN93FdRDZj/A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-4+g4c8DDL5aPB5kxDL6pfKul0n9z9d3MyVqkdH7mN1Xyjv6iObWvJiyRTz9Oa9MsQmiYqFlpqYd8H0DdDDp9OA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-op4HWONH32dtqSm9IbfC6wIGb0u9mFlr0qaRLsv81iptCiDoaJn73YY+LD9ntCidBgfX9jy/CNbXi3rBBaA+WQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-ZmwA1ignNmB4a0uG2wL6W02iFkAtaI6lNQDtC3q1m08gFJA2ddDWeHk/ARg6BQ8I89V8Ih+TEZabZKNb/VGNLQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-wpZmNTHCde6fK4SCNzKfC178z8a4lCbZbg0eA+nFcCSy0zjwBhCog9K/QNDcJfkn/yLiQG4A8YoAtvlGyRGk8g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-FHJupsn9O7/QvcIXhEXnsTK/oiVgyt3AdUw+0h+H2pnpwMs1C45tDxrI2WGBb3MzEt4SJGnyhK0EnHR7xm09HA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-ueMFk/5+v1yOGqCDJvyJwZTju7zvYYEhT2e8LejjSByIq4lYbImlMLn3CbJLiKTAuXMXvP7PsdCidP3r8fE1Lg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-xySNWQKhoB8O/2qMtE727wTqkYVzNNUpHhPRNsmqYhCT8GWPalM+aczF7EzstrlFynkYImIiv0+JsSH1LKyFZQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-yBOMiAOwHclMXFUJVru9XZoRstBoPsm6D+Dza+xAGJYbv2aAdbwVVOdYn3ivESCf8ZtoxDTRpBo9rM1LMKQsGw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-ioxs7p+Y00LNYHh7cR003eLfqbnMcUCccor5IeaJ6d7oNBrJu5pcQZRakvOVwis1MuX3FqXu+cMdLEMNj6EIPg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-iN0um3Ns8MhhTuOjNA3nhuTK76lsn48p2WZ32n+uxpclxudbqNv6Lnv8FPUw4p0AW/3dAYFiFKTbJuJ9ge206g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-HgncrwcE32D5qvru5zbNMhHaVeQXIF6AvNEheh5BAV54htAPyXu2BPvQFm7GcX3BEi1JgXl9vEZTkie9sMixfg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-ihFD6fFZ28k7RaklvQWOAsIlSuuxUhY4d70MITdh+adQ6jAlBbhTYD1huLmn6Tbg+zum/tlVi2+MRFsIUPBIyQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-8YDlh3uvkz2aBjFZAqTJeCkBERaDOpy5If2IOIMp+CGPaxQj616ysbEDupCaU6RhaIpQqszZ605G7EeETDtCCw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-1nnTZrfQAhgywbzr5ASt05TAic1s4rgyMhp5mpjPhnCUTVf0yPKzMVNgb/VyT6+vghPkBio2vdhFc7iZCUopWQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-pOSkrwaTm7uHHSPF8qJliCLg11xUQItxTTZTsk8GXMD4BLLqmtiV+uBMDTqyDAYXJfTv2HJeE3ssunr5mFfg5A==";
      })
    ];
  };

in
rec {
  release_11_0 = "11.0.0-rc.1";

  aspnetcore_11_0 = buildAspNetCore {
    version = "11.0.0-rc.1.26425.128";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.1.26425.128/aspnetcore-runtime-11.0.0-rc.1.26425.128-linux-arm64.tar.gz";
        hash = "sha512-C7Ui3Z0p6vtRuDFQzUFzLsM4Y8iZFobWOO73FDO9lOlvtE7UPsyX5f2Goj0HA/q2f/8RImqpwLYSayDlf9mwBA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.1.26425.128/aspnetcore-runtime-11.0.0-rc.1.26425.128-linux-x64.tar.gz";
        hash = "sha512-L4sjKj4F18RLEVruWBXKhbKZKhrHMvVwTtRzOAITYppeddIHmRxYIvTxGGXJS2NY0drDZTb09BIq35MXUhYDag==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.1.26425.128/aspnetcore-runtime-11.0.0-rc.1.26425.128-osx-arm64.tar.gz";
        hash = "sha512-3r5JdumFia1N4xv9GKde9lkieIPEvXqh86+6eSnPnZNsmwRT5ze1R/lQefk3L2dEzhXHY7P+DjcgevqUhpFv5Q==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.1.26425.128/aspnetcore-runtime-11.0.0-rc.1.26425.128-osx-x64.tar.gz";
        hash = "sha512-MonPxwAQzl9uOfWDnfvFyTejNPirufY5Xs9fSXaTPTw3F2traZqEhm6Zs9Ne3iLRNYOU9dDpYX1+BpFoiY4tnA==";
      };
    };
  };

  runtime_11_0 = buildNetRuntime {
    version = "11.0.0-rc.1.26425.128";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.1.26425.128/dotnet-runtime-11.0.0-rc.1.26425.128-linux-arm64.tar.gz";
        hash = "sha512-8eYqlLO5qRGDPjXMyOJGADLi3xyTbSJ5ljDjL2EynBsbuQt87d59N/7z1cLR5ZxWI7Kx9u4cEbFcS2jgoFnGpw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.1.26425.128/dotnet-runtime-11.0.0-rc.1.26425.128-linux-x64.tar.gz";
        hash = "sha512-z9N+dT2RWDyoumWHjyeJTPTijDkPS9DBe+9msAO2fvB31O0hIsX75ut9L57wajj3pjwtoxHzWRlEbRZj1x/h7A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.1.26425.128/dotnet-runtime-11.0.0-rc.1.26425.128-osx-arm64.tar.gz";
        hash = "sha512-Zf+rCX1uNigC/h07NAoiFXAzuGNaadp1wqpl+g/KngI8sRfgjUPS+2oP2g9wr+eHQSSb53eP80xPuuW8fJYL4w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.1.26425.128/dotnet-runtime-11.0.0-rc.1.26425.128-osx-x64.tar.gz";
        hash = "sha512-IFg9dzZGQs1xsldeoIcxqlivzztZeaan1uQ0vh3daVZSFEj7JZs1cBVu9vrnksyTX269NdYjmsLjEPsDDqWqWQ==";
      };
    };
  };

  sdk_11_0_1xx = buildNetSdk {
    version = "11.0.100-rc.1.26425.128";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.1.26425.128/dotnet-sdk-11.0.100-rc.1.26425.128-linux-arm64.tar.gz";
        hash = "sha512-WePIwZN/EiGfQ3oF/65v661+iBVerIPCvJe9tZCnCSnf3QtYWJjgI804g/9Ehlv7jN6enSZdPk8bpJ23cgyV5w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.1.26425.128/dotnet-sdk-11.0.100-rc.1.26425.128-linux-x64.tar.gz";
        hash = "sha512-YIUYV3qrnbM9uS69dPD8m/vMez1HNhn0cxrKLtuoCvbFcaONW+aZSGL8Rnn289E9t2dxL8tvcKdoOXShiCSgzA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.1.26425.128/dotnet-sdk-11.0.100-rc.1.26425.128-osx-arm64.tar.gz";
        hash = "sha512-lptvOKDr6FPdYy3J7wfdBpDMlr/lHWN50J16QF9HFgKrXl4JxQX5N4Nvqe6XF6CAeoyChZnIeGVSj9lSyMaViw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.1.26425.128/dotnet-sdk-11.0.100-rc.1.26425.128-osx-x64.tar.gz";
        hash = "sha512-nah3CxK9t4ww5w/p4wqHR6Br6zqO+bTbRSlXcW7v0HRtb8CE5lBrvX6ioeiJ9mYtuFeNt+yrslQodHYC4NB0Gw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_11_0;
    aspnetcore = aspnetcore_11_0;
  };

  sdk = sdk_11_0;

  sdk_11_0 = sdk_11_0_1xx;
}
