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
      version = "10.0.8";
      hash = "sha512-yNuRbIgHulQY/OjXMGK9UNW15MZ+geDD4J4s/djt03c5UIOdf8LDtxBhjKS3cOHl9PGqm+G1P8zunBbRtEDOfQ==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.8";
        hash = "sha512-wzbnex0a71Y4uGa0QoggaKKe5mZhOxw8a1cBMipGi+Aq9cgh3uPa446aFGtoxfB/vkPoSEBZIjuvXoIR3ftYOA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "10.0.8";
        hash = "sha512-4WWfqI5r9a5ijk/ujZA8fH+DyHHj5iOFl+Eid6BIBMwFZxAqNbg5P9KFhotW8JEaXWKmb21YBgAXNPSRJqp6jg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "10.0.8";
        hash = "sha512-w+llPO6UZQGlZTRJRrDPCeFaotGB9c+ReZcQwRMyGVyCiHSU2LxGF7YF34RCsscSitIOECHGoeXgF2qyee8x9Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.8";
        hash = "sha512-DQ+pQjHBX4uPuuqdy3tb0ZxF4oCGkvWEeheOC6sOs1s4omuKhACSLYuE+GFQmgpthXxhEWQR0R5iguoulbGA5Q==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.8";
        hash = "sha512-Tn9DnzBshk6gHp/PPe5EH+gGCOM1LjJUYXQSIXzr2II9k5m8JDSU8nNdU0JaPxbc3/e91/zakCdV4oAf6qfwPA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "10.0.8";
        hash = "sha512-t4NtwtyXFNxyKK1MTCafIEiFE6lZ9n4+6IZHi7gsEzoBxYD/UxZBPZF9EXRmEwVrCt3XPzUAmEQyjqTpzbXjCA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "10.0.8";
        hash = "sha512-rJO20OD0sWn4AjLQE3gheIo+h9LOqQszlbuNymGj2opwLfRbRC7rFwjpxFCnCFnt4gGqrAcrLdpGF+Lhp3xHyg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.8";
        hash = "sha512-q3H3uZ7wb3KjCDxkJaUfE5jzlaYRGEIVBGU1v3lUnH7qGna/a5Ore/bVMEshn+9xEFEYWt+hH520zQkNdjuVvw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.8";
        hash = "sha512-G+Y46Q/NoVkCjZKTJ37lWmdhOQP1/hPSTm/Pi9dDS2F3oUlh09R2NDIn5kVJXbeI9rZHsM7nXWa3wgrJadOzWw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "10.0.8";
        hash = "sha512-GuuCuFlrFBkmqUCVGTODkqwsZef67rv/IErY1CiqqRlBi36j/wlH3RwkP7KlLG/5aDz5Q+Q19qKb4IGLFNmU9Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "10.0.8";
        hash = "sha512-FM/UnU3Wiu5/gpdqmNLBxukQXEMUaZkLr1baQepV81dIYnDCyfJwIR3/h2/kXtYmzLuN3pz9Az+yWg5Xxudb+g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.8";
        hash = "sha512-YJWvYJpKboO8jkqvivxiZkdNrQeBykOolr7u5YeZ08Tb5Vzk8eV8GP+s3iMC+DoNzLQpIHi3fq5oWskl09+xFQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.8";
        hash = "sha512-ocrG/YxQowewfoofXv50h2iWj4va7hmGrsnUGIO/2cnJjxtOI97/oPfh4O35DBRthkxfJ748gxXqjDzF648Qmg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "10.0.8";
        hash = "sha512-vHBmMM2mk7Jg68kEslJML8dyQkFqZoJSp5L1Og+aL/fmdJDl8F9qDPQ6ZNayKdIxl4sVlkUfJRFEFVGoCg+jvw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "10.0.8";
        hash = "sha512-8xJHgbtLbrZCCyLWJOW+ML6zIx+aIkhmhjh9Qjrf6mH074W3xl5z0UhzI1wtd7YaH5SkrNlzQSJK1Ip9HRrdLQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.8";
        hash = "sha512-IEorwLEXLyw3Coxw+ivFw0Oq13NEESMtCHnT773wHt9hLHhNMQkLKekLywVI/l0F6rtDoxtz3vWlhIX0EMztow==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.8";
        hash = "sha512-hzgUJpe8qMrTjLAjq+Yzuzb+xzYkZHdj1dE4Q/lML1+LUNnZEG/sKsZ4/Kznd9oSrwIlM35vjQYX4ZBI1dRagw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.8";
        hash = "sha512-yHie172TlKeihK19ZAWZXtu011zxETdrkHaHzzM4O7l5sguMzneLVz4Vzdw6aU8XaS9zLaJlL0OZ9oJdz4MBng==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.8";
        hash = "sha512-p4HjGhEhYP3A7Bm4YWYUWbrMsZIJwr5MzprNkRiYs23nMI3AVNoWSkvPA6HbVFcjYLHRNcfVT1kPwfrQye8BvA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.8";
        hash = "sha512-DAbtdRyMCku5H8sO0rV7Fx+K49LXzlkmdcmi5WcD/taznl9OEcHKLy15WXJAQkbx57ibbJ35A8D800sOAhvqwQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.8";
        hash = "sha512-J67/wX1yjJYGUXHGCO7zKLAWB9NtTVkysSWExDeGsXp2ytsKi32AxSafayDAGp2NmDvB2UJ7Un9TOtbQ5GWrUQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.8";
        hash = "sha512-StuqQKnYTVCKlxGc/wRiTmDWIPKFdkR/m5L31RKmw7NoUS2ueTWvBGcIxbSJ2MG6VKWB5wqpAD+yqJCaaNhsMA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.8";
        hash = "sha512-CaZbXCxBP1vRSvXxiDC06ioZNLii+1qmDvAcw9x3o3MctJaTw29HFR3dcOh34HQDE7WcxIF601JD+6ECiP/wYw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.8";
        hash = "sha512-pyDnS9j4ibCSSYmqRGIYPZ0YC+btqRB/MloOZW2oWM7m1Tc3nz226FZObkVdVez9YTwcVcCh7o6VfNJD7ps1mQ==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.8";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.8";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.8/aspnetcore-runtime-10.0.8-linux-arm64.tar.gz";
        hash = "sha512-S73AWGsbGS2kNgYGm5KYkn0GUnzcXWG/T8QBv9Xgv0MDYH3LCdgi35Tcx/lEdIbrs5kFk8Lly+3sw1/i3jdFfQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.8/aspnetcore-runtime-10.0.8-linux-x64.tar.gz";
        hash = "sha512-45f+hSKveUs3yzEwR/t4bAYIUKEZHQ7Aoa4kiUOzz1FbJWUKrwcXmB2s2nhR5Bjz/ZDEwoJ7e2SV09tL6/HXVg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.8/aspnetcore-runtime-10.0.8-osx-arm64.tar.gz";
        hash = "sha512-xkvXPP9oJecZIRRQuLrbDTRSSXBn8GKfiYwl2yZcEci9GVvZPhfw48G2v+iayj3OQw65sNuWWNPiqw/g9lwAAA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.8/aspnetcore-runtime-10.0.8-osx-x64.tar.gz";
        hash = "sha512-1fnXiQZhmqbJqTIPjAXqD0X0eT3EPCx5iq6OBl82GnZjzoSzmajtDntB5Oz6GRuFRcG70hQsb0CH8F7PZEN49A==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.8";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.8/dotnet-runtime-10.0.8-linux-arm64.tar.gz";
        hash = "sha512-FrItoZpunhtzG/FNHYKtvE7vFtPOBoIulEWWSQXzjoIrym/UEGquMcloi/emCbuF86Iphe4emb2qVtVPqom1wg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.8/dotnet-runtime-10.0.8-linux-x64.tar.gz";
        hash = "sha512-5e0v8jJs6DMmnsqPNcKwURxJ+Vhb018rLDNUhL7sg0j/TvX7SwEzW3jwDR0XrZz9dWkJ2Efsbq7w33ids2Ggrg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.8/dotnet-runtime-10.0.8-osx-arm64.tar.gz";
        hash = "sha512-4aKouMqo+2THxpkqhZdrq4jiBTRIOw93eFaoTC/uKnPBHfqhwr37GJGIbj9h6fQYdAPd111c9jP9yCRdSiaXdw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.8/dotnet-runtime-10.0.8-osx-x64.tar.gz";
        hash = "sha512-afEKBNW9FOCj5La3+5CWkxVplwemxQz5yUXrq0aPhRydQKNACo71deEGA7ZD+Qf5RscXgcEwHrmHt8n9QTnmdA==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.108";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.108/dotnet-sdk-10.0.108-linux-arm64.tar.gz";
        hash = "sha512-bEhUby10OOxnMwtUFLtlzTPbNiPWQA+Nl9LEc6EcOdQJCUOwfL75LLrd+HO4behy5dsHbEFUCFM5BFHsQ9fyhQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.108/dotnet-sdk-10.0.108-linux-x64.tar.gz";
        hash = "sha512-4y92t2gBdxiqWjpR/KxLYXq0QoxfLRCxsw8H3X8eo9rU35F99I2FXXijR9Y15Izg7DCXh4mcU6MsTBDdIWtrGQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.108/dotnet-sdk-10.0.108-osx-arm64.tar.gz";
        hash = "sha512-0rEYmA7UCGAJEF39VegPC//ms1HYKxHcvRi3mCEZwcO8MyWusgwunLOrVVF9MIpkCAAtKHB7zw9tQD1Xfakybw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.108/dotnet-sdk-10.0.108-osx-x64.tar.gz";
        hash = "sha512-1Fds2X/lBZnlFZEY92rNLtFXI+YZKBZ3P6+ETyX2Gp3pVlNbwbzRAnfMTCxlB7LatShQUvn5b9twzk2+WRTsfw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk = sdk_10_0;

  sdk_10_0 = sdk_10_0_1xx;
}
