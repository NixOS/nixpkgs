{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (eol)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.33";
      hash = "sha512-vtHOb5B7NHm4HenhxTYi2TP18wvKCSYknMmS1fKTKW8xWPYkzc240HocCrSckaBFIjwkSj1bA5VsfPJF7emexQ==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.33";
        hash = "sha512-e2RWU9+/I6kaSxD0eJB59GxD9uhu87NXJhSHBUJtH9NxDM5YJHzcy8pMQyX34bOJYL1IxLPdvmzZTvBO4LLoyA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.33";
        hash = "sha512-oxxlKm277tLRewZxmdCxaxCEMNB/F83AG/bDPucvfuGjZCCEXbXYAagbpdUvdcIpXA8eiRTxVDUnGHbt501cVA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.33";
        hash = "sha512-cFNes6IcxNFRLcNYM5Z4bPMpzvlEpp9t477Bn8cPI2QigCXVK0AgbuAMpsdLrbo8P/dG71q6l0ZVh4M02MXkAQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.33";
        hash = "sha512-KyuC0oi5UAcFOJV1eibi5gDarSXRrSTCgRjAerdvpm/j2gpN+4wUmjisWc7jsWtvzPdia8htiunfHv1dEcJ8RA==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.33";
        hash = "sha512-X0a/xbHzTrmjrkXkLWMB58jSVqpmzyzO5xslMWQ9WPxBMgKIR0Fhl2Ydd1mqBlgmtfPTUv47GFS3Y5Z5DCL+lg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.33";
        hash = "sha512-sWbb6vpLVfSKgPiKzDGMLBVWh4T9iExHSktxwsRk/TvYHf9etdYQzsL//1k48pow3RPrP+poO1w73MY2WqYNHg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.33";
        hash = "sha512-KnoyKzoQwuCBY9WNnj/Wsxn+7UlpLabt9/j7REZs0LnxZG5HsX8vqY1jZuEH4byZZhTA1cBLy01IgnFlTRDgrQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.33";
        hash = "sha512-2ctqCMiqxeGnlc4mbFNEzxp+w2svSaYKRIN3U3Vq/C1p6gahM7HGUw6NJBvSdG7ryTPWHUlArAe0PGW922xZug==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.33";
        hash = "sha512-l8UatlgZ3cJkRYZYmJwTBT7dQ/erf9cbFpry6XP7IXA9+wNmgGhzzNihlUqIxtd2DTSMJj5cyowtW0fwyG6r4Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.33";
        hash = "sha512-f9wFtPsE/e9pSpuJh5h7/a4XGK1DqLJxcy9++yIy+qcOcnzl7N6l6oNPIGZmDFcYNK6yxvmLL1lSP6NFA5wv+A==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.33";
        hash = "sha512-CQi6LfZtySQ4dE3t0kTwfSbF9hUvtPmUKeSDZTe8mCGuaaFai/Xy6xfniDDvGWpw0gWOJ60dnNqCaPtNdr3TRw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.33";
        hash = "sha512-oM7mEHEMWoEy0nWMWYmziothHbVUM7xy67jZeezrKLpwEI9wwQd6PAorDETVkuvKfJyHBocdew1AQ1MWZm1IRg==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.33";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.33";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.33/aspnetcore-runtime-8.0.33-linux-arm64.tar.gz";
        hash = "sha512-050baS950ams36ITg4Ju6dH2BvJGk6T/5JWhCZa8vU8zfQklRNpI3lpU6ubl7kdb0SqzbgRRbpGl1kCSEqiSWw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.33/aspnetcore-runtime-8.0.33-linux-x64.tar.gz";
        hash = "sha512-CON8bNCe3eYBcPP2VTHxtohhD2kvneYhJeL3IXv/oqwTDJ1rSYAyZqwtSRapGid+CVwia4Po6lZdfeQBRCKqbQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.33/aspnetcore-runtime-8.0.33-osx-arm64.tar.gz";
        hash = "sha512-VNe9dIfXdV4FuRVgSGZIiC+JzVfSvBb+wd0mkWICsBUoWh9M/TDyxH/xTRoTa4KupUt1djD6CMJUCM1S0sstbQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.33/aspnetcore-runtime-8.0.33-osx-x64.tar.gz";
        hash = "sha512-g6KfQsKXWVkjyw50aR1l0HVKKD6U3GFquLkglCP1Wb40L8U5TnqFbVEmcMYcag2S94IDVZ4Efdh8S6eH5X1WIw==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.33";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.33/dotnet-runtime-8.0.33-linux-arm64.tar.gz";
        hash = "sha512-qbol6ucvmOJSM64gLW5PtmY7LI2iO82deXyJ6LHQH1HekPGZTccQGl/vVttAHAWvGExeJRqbzlcK3wRMTjrlqQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.33/dotnet-runtime-8.0.33-linux-x64.tar.gz";
        hash = "sha512-sxQDnTN6jFxL5qb5lxKiYYy+teGrfKx6XBy/HJe9NV9dEWuZMqjPxgSseEn3RjiJbroFNIksZRgxGQiroptPew==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.33/dotnet-runtime-8.0.33-osx-arm64.tar.gz";
        hash = "sha512-C+N7ZOofSWUbuqPdCOiUdpGc65i9aznSiINDnBbB2cvMz1zwH2fJEwlenyMjXcYhElpVGm5za+Tr3b8GDrgnWA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.33/dotnet-runtime-8.0.33-osx-x64.tar.gz";
        hash = "sha512-uhd8Z4/OdC+ZH8XphbfiafqiMeRNNWIr4TgAy4scdX/9uD5uEIF8s8SLZPunOjAcLUG5HOf2BE4fZ582oOo7Sw==";
      };
    };
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.133";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.133/dotnet-sdk-8.0.133-linux-arm64.tar.gz";
        hash = "sha512-R5zeAooOsBegoUI5AUdt9OnUPJEvA8EDi4lPpMdT2ybXhH18zrsDh/SupiU07/kp96CwVbDtPbCrznCskWJXRg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.133/dotnet-sdk-8.0.133-linux-x64.tar.gz";
        hash = "sha512-Wio0w4jxf/s8Gt/sETQoxwFSdJwjwDB6tl0vF+61YSXw9KL/K7ZsmwRaHUJB6ieSbiI9aZC2zX6imzzt4gtqfA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.133/dotnet-sdk-8.0.133-osx-arm64.tar.gz";
        hash = "sha512-IXGE/jtLZ80mToi3VgTx90OdVlSc4drXpY18TH1JEGrQ67gqCMIJRZwQg6eq/RADbjRO2nto6THnQLUyRXDMSA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.133/dotnet-sdk-8.0.133-osx-x64.tar.gz";
        hash = "sha512-9b6PR0AZjDBLGZni3frlsFz0GBkIHTIvNgx0S0mK9j9qDhIdgwmIlbmQAPIxLmklsQFbL9ppVtJsQzQakJ6nEQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk = sdk_8_0;

  sdk_8_0 = sdk_8_0_1xx;
}
