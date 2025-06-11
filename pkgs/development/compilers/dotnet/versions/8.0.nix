{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "8.0.16";
      hash = "sha512-MR9FAOeqTC6UU2XS6s85l1wtrEQBn7/3nT/j2NoSEmxaYC5C8sJQQruOgm2RsLbNltiykKWQhutv9YJtZdsfnA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.16";
      hash = "sha512-aALkqzq7+6p6/yXuUgiGinbvn6JaG+OCe95pSGM+yxtqMYCYmzX31n6kU9OPTn9VdgzW8Xs/ZDIlzAvBRC8JJg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.16";
      hash = "sha512-vEEL6YBpGBdlV4x8i/p/KFJrNIBG3az+5ht8RQW3YIw+WmCL1QVRkiPEvXVSSmEkaPJrH8c8mMl818AE/S5CWg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.16";
      hash = "sha512-LYLsVR9dlV8GsIXn4uvX9l0JitGP/YqtYiTp7JiTN3wqvlaBLDwocZ3GBOwDiASzlmyu38oDtDLbF75ohEELvg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.16";
      hash = "sha512-52G/zHYDyNRghtFkuOo6I9pXwsd7qkzH9WLKmOVdC+X0LXKDprE7YISR4EuiErNc0OE1qKhCNdhjyr6W2c4PMg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.16";
      hash = "sha512-R/LLslGX8t8qwOGsWReybSsGiXuKCdOSdH5Pb6VBiuqgCuygU2rLCZPdN2dNH1WcPqAPFJFW3fcjdc9J3mElhQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.16";
      hash = "sha512-OEv1V1AQb892jWtsrylFlewn9SDwdxRDSCSmhDcpJOqz39CBgg0zEH/dM+LtWMne/uwMBtN8Kt4oUEfHKzWblg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.16";
      hash = "sha512-Pz3s0acdPIqpr6H45samMDpqa25Mg/DXcrlRfVySBCznpNI613r3MnMjCiSzYaDhi4HbvTl0+dkFcUtccmQ6Bg==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.16";
        hash = "sha512-jBdU93KORqByySIYxL9FmzjC36WNKQ0HcGT0EkvwTmHh0CxpGVoH5icQYtZK66liLsLbgR1B654GpISLsOvVJQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.16";
        hash = "sha512-CAnPoJS//D5PAZlA+/4dHGBP7RMdoo0kmG2kUOw0muB+bqsXIQ/Wdw4ztrgPC++BZlkwL9CLWWNk+fW/8mAuKw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.16";
        hash = "sha512-QMSFoSYbn3TUTWVnr/1ViHjgOhbKaoYwUrSXxxrlPdOBoV1rL6kwF4loEF49+6y7Ty1Q/Vl7ZvePYi9GbQzooQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.16";
        hash = "sha512-7jFOBzAAjlw+RW85zQ4kuHw/BL+4RWxC9KNBfYUyOkvqjxhlTAS3oIO92myQsjEmm0VSrxck5HnTytcc8kxyiw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.16";
        hash = "sha512-kOC6DR5x2UtVDPDzwj3ULdvl27F0Q3rRZWId0d67tgqWCbp1dBf0RGounczSKP7J4c1CahnBVXTuzf/WznOYsw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.16";
        hash = "sha512-MZYQ4BYONhcpg07DLwMTG6HlAo+Q8m6pDwho3+G/YUrajvoMHbg3Y2Yw9XvLoGa5Cw3dUXa0eWiqx3pOuLuFpQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.16";
        hash = "sha512-jjkFD9g7N969HqTen91WEtcI7up91yKjR7C5S3BEzMpPDFJO2Y7Zuq3/8fz/h2emh+BQUYcSVBDHuOsfN01QDw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.16";
        hash = "sha512-+1sNjZRW3W7rPdIyxBKO4tNU/DXwpQ6d1FmfEqnVJbE5bFEQ+5WALIXP/0TGMI9U3N1xwRaHoSXVvTvSdw4wbQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.16";
        hash = "sha512-ZdKdJXNFjLJYbsiGn4v/l9fFh2tysHXsNgkThb8PGjCparmv7RoNOq2ledsZBNAcWhHMU+B64tWFiix1rGNbkA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.16";
        hash = "sha512-lzi29sKhg5QjgPf9NTexxX37iYqQUagpiPq0OT6fmVNfCrnzcAjYjA0klEAZlGE/0Brh3dhmsKUsXEZy8p4sEw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.16";
        hash = "sha512-Hv957R9MMq2DFCVuf0AiX82IkAWnJ4sDr5anJwzoCQRgTsXqwg8u5jqjDE8Wo5YIK86muWeNgk5DV27j+xsrfA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.16";
        hash = "sha512-BP7m4CEg5ggvyBDlWVVbQBlU1T7Jahnf6+Emt/3w3aXbdNp4AD+1jcJaaIXV+/A1hru5H9hmSsiIEuJsCjbEGw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.16";
        hash = "sha512-aRrl44G7/Vjy4AdrPEHIDefm5ew0VZXNq7GPaszXq846V38VnJhAU6zknNyBqlYzEAtNSyCaBXKtPrz5LsxqKg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.16";
        hash = "sha512-uk2pxu2NzxhLIdy85gikp6OCBUMYeTPCYt9BDQefc0G6eqaEhPDloc+WocqWLYs+vX6IM3qEhL41aYaY8KnZQA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.16";
        hash = "sha512-m6WHjEfXIHp+h+q4KSWknLGgM+zfyDF3P2GSftA8BA2/u/HD93CK0FxatQR6m8YB6Bd9vpx1kUNVqBqmAmuObA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.16";
        hash = "sha512-HCWrW2RPsSmsoVvHW1oh9vogOeqNLqmseahNP6HJbuZVnU3pw20nvHBm67547Upx3C2um0Y2Eix4UOwUzmAckw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.16";
        hash = "sha512-bt6PWTJmhE7GdZBbF+Dtue0cGlvZ7ihUSLivLxpoHH3ANwITJqnyPWllxrfflrDfLCaDBE6WspQ4jeuepiqShg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.16";
        hash = "sha512-erkrCvfM0GCpctVlMtRk2nwDkUhFWjcTg3stKRDK9ALvtgNVICghe83UciBKlCvhmq9BtwrEECrqst9nimTeZw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.16";
        hash = "sha512-OPX3Dr6avujuCFr++QsKO0M6wmldtpNVoOLw/vuAfx4os8iMjD3/0e2YhLNPakFHXm3F7tAs9ArSFcrLISClQg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.16";
        hash = "sha512-zQtpJtQsIwiRioQqNHA+gyfYORoYk96PJMd20S3dJRTms9zJarx44X9gtZCHxXeR1D3/XfKKAwASfTV87EsM6w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.16";
        hash = "sha512-fXnAL3PgEji1ztgKsuqXfuV56n2FZEzVgHX9R2HSsV1yEfAypwHDNYzB7bW+dcWsmzijD4f60UJJOmlYuY8sNQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.16";
        hash = "sha512-DV5JG9tZMaGgcT3sHWriN0w3drMJ6kEmYFKHyt70gt0d1aBxhZrWsdjAq2oVMSY4qlWyIszrQff4MObBWRluyw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.16";
        hash = "sha512-ZOM5DcPvB0lfJwbt3kNcs6fS9u/58UuqV9FjodMc2vdDVhwicmolnvEnsuV/Y+3Yh9qLTGh3H1XY9IeIuvelcA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.16";
        hash = "sha512-3CQk9N/l9/3nV6tgpiedyqy+oNFL7T7WNPWF4whUGm7yLkJsoFtw6Pc5LwyT3OYyiXdEnPbAkDBQuNpJ+zaBkA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.16";
        hash = "sha512-I7DsyLTf0ZGXu9L3D6iSp2dw+PkuDBa+vqvfl0EdSRjgE16nraXjVGh/SK2ASaJi351xbboEpRqewZcWTCKxWw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.16";
        hash = "sha512-7h6k9pSSvDXC1TtcmKykPg0Oz3k0MNfahqQpBQAEtxZ4xVCuGk0rkzheWqvbLSehVIk/9PFtu4ZeO0dH4rEgBw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.16";
        hash = "sha512-YBhocmkKTz5ABulIf3WW2NjH85W4O1CVysmY1LgWCMlTAX1uw0MRaJMtXUR7COZLHbHXNAPD7FNwuuYMgmIhUw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.16";
        hash = "sha512-6ju7d3rPYcKBvwZKr/z2RQ3ctBczul4JO55fttyOA/oifm1LUAY3TJtgagAF9pf4j5HuCoXTzvV00ZZEqtXLPg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.16";
        hash = "sha512-15ih5bce3YmsSs9MFp/NH4UY3/UMMyRs+4TKWolHguVkNbPcYdWg8YL0Fhr4c7A7wAnDHhCCgSqmcOFYI4N1/g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.16";
        hash = "sha512-MGj69hsPIe4e5Z6HXS+T2KplPzuZqETZLSP1oftted94gXOO1KOHJoDd2VbBVBpooMfqaeXUdw1NtgdS4NDLJw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.16";
        hash = "sha512-XwkekqnJyq3V/rXSu1WZlxzihsjvNV4ZbTQnb46583LeUJbG1o3ra8EofvxA/jA+ryXMpJxaQmVRNODJy1kIsw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.16";
        hash = "sha512-wZCw0LIMH/WIDqiIU8zHyOg+EWExwu3S4T1JMTd6xra7HXGWlHQKj14A6P0d946lOVqjLxfW6IZXdgmALTan8A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.16";
        hash = "sha512-9u78cVhiXQWJQsE2xxGcx2hbvaHImV1RcwtxIt9jjhh20SFJ0SoK5idgSbSh5q/63WfMoWKHPOkT5Er/whQ/3g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.16";
        hash = "sha512-4PjcN/ILs694XXBFjzrxqBsqzqAAU3UwwPkn/DmZYgG+oCvNhToiFYMOmHRSR08s+bHevGbDkpC7tHAS+S+UCQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.16";
        hash = "sha512-qHM2tlnjKfDdZ6HWLQ3Ffo2lIgW68VY4cAy49Wjhj7k2dGf8Aj16bWpDxo/WEd9PrsXeKaggdFTHwsv82lpDZw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.16";
        hash = "sha512-2/VRY3SLruFnV2eziW5dl5KgIzB6mIqXfPD8A0yLQ4+0iYqnU5jjCrhSlvcy2xtH+tqkq4DAjSoJ83UjZoxg4A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.16";
        hash = "sha512-Cf3ePr98FaAHMX7mTGTEHMHHPvLlar5MktJIHJFda37u7RX4UYDABk1J60EdOUdXmhVQQ5gxZyBlD7Zj2ZjQaQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.16";
        hash = "sha512-13QUsacD+oc6WO516SyH1F2d+QgfFMGzdzIEMMZEDNKCYSZuYDL2R6Qs+9kTfiFHZgt7P/WAAA3UV/QxlxlQQQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.16";
        hash = "sha512-6/l2nBV8h4meBgQPsthQw69pZJNSmbtmLGKaHPfzIlPHD6A2zI3rVjvmgU8Ahn6rL6/TnZTpC1KdaWzRCsdGZw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.16";
        hash = "sha512-lFK5CU+pkCWqr/mmRec63X+tdF01eZmaOcdc6K9lTV08hS0rPl2F1UK1RmOn1eZSMD94w2M86LZKZNLwI5E5FA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.16";
        hash = "sha512-UiaOuNRso4nVM1DzBL3i98WR9gnLg+DnQaK9ZXVu+jXsQ/19Fi92A3Lar5H2WIbtaQcngbYCG2HXRkVYdtHsUA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.16";
        hash = "sha512-TqzAj3Vdql+FVkkAvrCVADoCfjBkryuFuYNPI6VnriQgMBHPbeD+In9hqrbMdmjTGtdXMbqVYSZttlJwvwpVaw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.16";
        hash = "sha512-xUyQ40LnE8H82Vi8wU9zKjiW+u/nsOnyKYUnPnEWhDvpF4xsJOC2bG7d8zXYKhFGGbBw/nCw/b/alhGzIfy2Iw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.16";
        hash = "sha512-peJrVIokSCtP06QIUP5YXSPDysocDOaMFwnFWDhNqD2qZFluJVxTxS16WHBNRhZphQ05CflNH0gq1HMpSeV5Jw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.16";
        hash = "sha512-HTIcDrg9ZYCTRZv4nSftTxe7UhFYomff2fMVqRsX/4QBgeuF72KIbvAihv4wPBDNh6RSAC+qPVtZXZCtJO0AEA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.16";
        hash = "sha512-9Wj8HvYDiJ6YEqFtyTnxeKKHtCSI1PorGAsuuA//jCqX2WqEEt9+vVcCZLs3ge0S/3vEwELeu7xPXabAwiIsyA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.16";
        hash = "sha512-RfJHtnXtwALzUNOvG8FVqvfEEhAQ+KzgzTK1p+hf3qA+X79iA9Rwq9dj6RHE8Fjt3FMXb+8inialcu6/+7/Lvw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.16";
        hash = "sha512-V0vfD3Z+O/2atM3bJivfm/BKo5QUSaqroFHuYi1jVilICslvVoDfKood5wgUX91T/TKkVzGG5kZknxgaylw1AQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.16";
        hash = "sha512-GpOecd88g22c3eMXwE6N4fa+dODPrMyC3xkbMOivdqH1Gt6Qmj/VF3OwnwhFMaaWXILCI7wkU558D5mj2IcbLA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.16";
        hash = "sha512-+wj+u4y2B7RI6FbkJJN4uKtkJploawLSRUc85tHfKSRd/VWUVrg+NQ2Ii4YADE2aaP9x1yVJRei8tChJm9XHaA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.16";
        hash = "sha512-N0D3EjGiPUbiA6TscqS8k2F7DqZqtjYOfFQ+PPfDWAiGP0/UvuX2HtOYxEALNUGzn90KtMXJUBfI/sKjxCQp1g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.16";
        hash = "sha512-x9FtAd5kb6DbrUSLYtJ9cKog1Z/709IzwCPy7eG1RawnUP2v0Q0tdJOXdvoaTyVgsbW/NEgvJVd3ngP6SauIIQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.16";
        hash = "sha512-GiTTne4boLVAyJ0CJDbpBWZw9oA6+Rg3e2h38LwfzF7kS1jPZbc10igA9ZsnUCOYAFxzWzNi70Bb5icTRRBSjA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.16";
        hash = "sha512-nF4234V77TrV7JSbSx34EuMl4qnyfODinwdSpZ6uX0MKUEwk42G8MT1/gLZBp8cvGv0I6Yg78+E/39Zd82RQBw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.16";
        hash = "sha512-VCfPdIVCm8hIp8XaaPw4vg7eRuS+UQhST5xuPHbw+v7wInifU56jkapE56+c3TB1J0QoyUUL527sp15QqugXuQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.16";
        hash = "sha512-MofzgXDj9xPc1cm9RpzvOMeBLqfQEIOrctQMauI5CvoH8cVZdQWEo7EDCkWiJvKJjBKhStQ8PFiJGymmf0aPsw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.16";
        hash = "sha512-ZpUWmllmq2HR7eY21ettHwFv3BapesdBsI76kjtGriNOivMQwWd1/21ss2PeKFd//HNZ0SjMAX/AUPoc6qUl0A==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.16";
        hash = "sha512-TabUjPzfTmIpttDvd1ibCakKZA4iGxPYayFnjecfbenQlL/5qRFLW2HZ7aRGdMtPwKfp1MRmcTlwN5nHiPEavg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.16";
        hash = "sha512-C38paqrnwY57InUeWK+PhcOGyAxHnHpltyQWZ+urFGhkBN9PjcLh94xL5Th6BROgLeaeAPIZkDD1nTfZtPFZSA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.16";
        hash = "sha512-ZaTZo7CUGUmW1uXppfGAg/zFuoSyyDEXP+CRKaWcpNdE0DDoZtQBuonrjHrmKJ4g2sdgpOErbD/qDa+pVsnSsg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.16";
        hash = "sha512-jR7uaCNjagiMvrU0dSL88yogPSjbm+JUbtaQ7jx7c7xLCDvW/3rdZpx0lIAL6yxSRCPkthOSf8Rt2unoam2A0Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.16";
        hash = "sha512-Pan9aX4Hd37diyf9V2APLS5UpuPWnSxVjjlnpPUcyw0ztWCpVivQwSme8aEzn1SAnWnQ/88le9PtAEgJvG4juw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.16";
        hash = "sha512-BtpDN3TeBLsq96C4magsVnNIb8mPXW4rYk2wLK372tAD7Hiycm9eBYVdaLoYhEW1Ct4erWPFo284Hpl1X0Gq3w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.16";
        hash = "sha512-k7+KT81WP9yepIARsWCNRyK1Z8f0l5hRfAUbtmKIZZF8Zb9hZBeQ/wfc8hDvG+Av9abOnvVDOm8oWod14MpUUQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.16";
        hash = "sha512-juqAOH138FUGV8IBgQXDp0pg6GS3H6t5zAaaovoKAhZpvAlAKdLitPKCkWfaiVzqRCMljRMaNTLq53U+CtMBbQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.16";
        hash = "sha512-wuAC93N+hDc0H1wD1IHdkSMokwuOxTGwfVNovQkfGLcvWB+hWSqYwn3HlAooVGi+juYMqgFgCwSUqj9UXzPPMA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.16";
        hash = "sha512-JTtZzjHmXFqUYP/Z9FcfUuh7ZVw0Tq9sW3amlYNQWKggIGaaCQsicKN5VqTo1rbWrbGibu4DbcSUlkvQydpeOw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.16";
        hash = "sha512-b0Glt0ehO8tmRx48RPp7fQOw/05LHN0u/rJxbnFcaj++6huetGxyFy3RDm/xnr/PB5Td5qENk0ZqG360ZLFX3w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.16";
        hash = "sha512-BVWMbeZ0tS2t1ze2y5f7vD64uJwWwc92yu647Tw3LVxMDp4Dz4bzduDNcH4+Rxs4hGRHt2cwRRfM2NGxnydX1g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.16";
        hash = "sha512-quU62eUZW2ls3EouhRllGQOhIL1DkjgYT8R8B6Yv6gXnQzD9Kaixq9FmCgSDoG8GlZUrh9jro8no446j99pMqw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.16";
        hash = "sha512-puv/ricB6SdP3NKk61bwWXcpP6Q58snrpFZCIOxj6mAJwl8RsdR+0GLPyR0qTQKhnuE9ZY83bGaQEPn28CHcag==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.16";
        hash = "sha512-pbULyCi7O6A1h1PIkaTq1q5E+JKzr4FkAO07t5C282BeLd4Zh91Dgi48iGdun0lYFU9LEMQ9oLl4EHr0xAVCCw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.16";
        hash = "sha512-m81w4eMl4VxnH+2goP0FI13Wrh9OoVGV4kiOsmdR9/KMik9WKsb4eeqj7OFXR2Um8QIlUA8z9pAqv8VkiphnSg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.16";
        hash = "sha512-n4PzbC+wqBZnh/v3Qlr4tjuJDnEL1uTJHwyDmBEgoBxPlImBYaZXhjjPN0h3e7nlPqfE/fP0axGGNrqm2jIrVw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.16";
        hash = "sha512-CLwd+6uc3SFGdlZg6hWoIsv/pyCJej3k22vYbmz1kphIpvJjkcQQbHKrEed+mR3ruTtGHAtEc3ALvTfFRNGwOQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.16";
        hash = "sha512-iK+92YNFakNasLgMxjPA9B34/188ur/Cr1qNw9KStNqQ/t7h0af+LpCh2CY9Tb9rtiQ4JDa4lhAHnRdF6mgF4Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.16";
        hash = "sha512-n7oHeX8D3Qmk/YQPZ6isIXLM0sCKNLRczAjoP8hfmmnE/bYk1uhFbxhPROelIN/tfC1G0yGmiNLXYdzL17q9jQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.16";
        hash = "sha512-F8lb0QVbYAcWrxCxGAkYqS8F3QWqrhX6AmuqvYG4hBki3JisiuCRhCqJeiVgbPXk8fl22hf8i9sDQaJSrBXDbg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.16";
        hash = "sha512-9o5ign74HxWNBsT3Cdvia+VVBdATPhe006LBCh3xeULtcdYIFpKdvHO5sGsxHPp5WdKG/kuH1LunOkbO4mmIfg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.16";
        hash = "sha512-q22oMVxWzD5aLlZDPAAsuuoOFrCtHpKGsHXxsVontq10lmFiRhkM01V46vhJE99gzUjEK3rBXEb3LpH1KEnOTg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.16";
        hash = "sha512-o6TXTHX9Uc8BdIdzsNR5cQVK6al/Q0lHlKRROtZCY2nP7vRpC+D6+/lUBh/Kvny+dwQQ662wCJrs2Ya1XoWF1g==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.16";
        hash = "sha512-Kh9Z+U062mBYGkXrZrG4/rIp8jfglP2GfPr+a2SgDuF7G96y/wrFcXMhtpvkdj/6PQxX8MrrPHMVZ4wml1ch8w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.16";
        hash = "sha512-fXEfLzBw6xHfliy1XoqxX1N+OUBihYilCQeEoR1yRCNSeNXnSHdPT6pX3reS6qI7F49pN35s68sPUfCWLFpNNw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.16";
        hash = "sha512-PNnCUYpG0auWMefWbyH/TYJZrKNJziqNbfIQ6IfJBL+2hYfme3xCEn116fsG0nht61gGvlSF0ZL2MX+yTCyHLQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.16";
        hash = "sha512-ZWcEzJrU2fGE5nqi37Ms2Y6QA7+e33kl6BFmf+iApJGFDQOiE9u0JmmyGXQ4r8yfIjfHiQIvPYNFvCMs5n2efg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.16";
        hash = "sha512-7WwAk1dSgfWwir2Mdl5S8sAl5s9fDyRq5o9QUdqa71OxDdl6UtUkOzF5R8aHo1BXs0qM2SXJlf9Fgp9u3Bk9dQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.16";
        hash = "sha512-+0Dm9S2hIlqePk2mkdlOaAlrG0UkCwJotbUv9535BiC/qbPO6SY0izAHX1dZL6LPoFKBewZ1aoQMtrsF9xAzQA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.16";
        hash = "sha512-BauQzQcup2e1iRILzm1XU2zqgFeQ9A7mKAlFY9XQVxtEWlRhQ1047lkvf1E1qmPg7S82HfigvC+tFY2+BJi/Ag==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.16";
        hash = "sha512-OIZrbirMArYlnOV8X8AdhVaCvhumkaiHMTCivh+J4bY/mUXZ1GZw41wWpw1Rhj1AZWl2DSa1jyGphtCSgwycRQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.16";
        hash = "sha512-ig9SH+K2HVzuER+P6jexExvt1wOAR0tmZQwD5IEs2RO0s3BVOPwxJc5QjqixPP7oZjvAMK3Lm/Vy3QlVpnVpGw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.16";
        hash = "sha512-1zB+91bQGwvUb+hFzPAdVh9J2a6sqM+cljDeh7Yw1nG2AoNt4UZr9AQ1WaCd7z7sE628J49JH8xEPrJkig2qzQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.16";
        hash = "sha512-e9XIuQAjb7cz1WCdBVH+/CP8ndn4SnsXGc8bLlEMUCL3bAUplL2aG56gIeGRwYJP+AcfAEvFkHNnzEC7JtOrQA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.16";
        hash = "sha512-+8EYnxw6v1x8sHtsELUqUda3dcomNY5X9fQc5VDew+9bh84lbTeexQEWUBAjkmrz3JLDkh1g0hLS42SS/P/wrg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.16";
        hash = "sha512-Hd4LNJLmrzLkhoBTjAI2kGQ+/1sXZLamflSEAVh9GzOkoYMoKqfCxAZNYUJwPgIzXm1iUnC+yfyP+nJJRrUd5g==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.16";
        hash = "sha512-4IAmnrKN8GRF3VrMuPkIMJsG9qvUcZFqrRFDjpMFft0n+A0eq5Szyx+B9lG0EYWE0UZuJQOsNyqs3D5dVFgUvw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.16";
        hash = "sha512-rCxgwEzg33svrD6JvyIqiiYGIo3+vpwdAupgkdOrBVZ6xJ7D3NeqcStXWVs97n60+fvUC7bb4Bwl4dJ/KQYb1w==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.16";
        hash = "sha512-Owmg0DKS/rSWDUwNt7+MUtagUPdJwipxfPtGKzrkzw/xvxsmw7ACqmt7ONqAXCz3XP5MQBRo/CLhw3u9eVAh+Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.16";
        hash = "sha512-YcXpTXwEQbqvQFBWv8VC6rKvilmelGBphR0KUNzanN64uJL/uC975jCytnFlkqHGguor8OCzVkSDG7TIOfldXw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.16";
        hash = "sha512-ohiHhvm9mZNZfSIOcoD8rkaabXJ9LqDB269y5pfCpM0kRohj6WQPS6cpPn181jxMLOlplYlE2+piJ8quAZfUAg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.16";
        hash = "sha512-crVLHltFGP19DUYri0zM1MN4x6PluOLaoN3Jbc+DTtIQ11GBtBVPUP9p02Km2m+iismSZ4W2bZQZ+WJQC2wbKA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.16";
        hash = "sha512-Keme6iMgYtf+4Z42/waSQw3tQZ6S4fzvT9A3DwZXuTWhThx7+L9HRLZ5jrn5VhWVralHTFvriS5PtV3aJXJWtw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.16";
        hash = "sha512-TAG7BJ/xiqqUWJ9C7Why1eMi3ctsGJYgfmMgyTc7pk2zw6ZphR/vddldzYAjLX5Tzy9wHjVtRThBTr0yw7Pn7g==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.16";
        hash = "sha512-azCJIT0ar8N7F8QWEVWgbgS/ZwJ4BaCClcALWC3MNFdcA4cpGiWunVYROhuCe144P4NEKqQo7kmesHY7ml1rjQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.16";
        hash = "sha512-8OnxZ9IQIwUt3uaYCMHQmyrwAi3opxGriQ/98DW5cJJbU6asG8wdtGwGGRtcN2rx7aDplXhkdctSVKUVHSCvtg==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.16";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.16";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.16/aspnetcore-runtime-8.0.16-linux-arm.tar.gz";
        hash = "sha512-HfSe3Kpesa+ubpuTWgQYvEqT4Cu96DQybBoGYJXPKOdgfV0cqK93canS6BYx5Jkxp7+ZhJyJEHkd7utqmQJ1xw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.16/aspnetcore-runtime-8.0.16-linux-arm64.tar.gz";
        hash = "sha512-oRXg5iU86n6aSB7YL1f8lkE6pQznQHkyEoy6FTvfSuwb2M25wE0pD/APhURCn+rIa6bo0rDxZ0wlW9Y2wsfm3g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.16/aspnetcore-runtime-8.0.16-linux-x64.tar.gz";
        hash = "sha512-AlbKxBUazW/8grC3tkIfMEgXtv3C2csjIBjPmT5A2msijUFTl90bGzSFnP/h2Px717tHDfgRKDdOXJRKFMWDYA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.16/aspnetcore-runtime-8.0.16-linux-musl-arm.tar.gz";
        hash = "sha512-TVMCx2nSQmKtt8HhqSDAWNmLnmdC3t/rKiauHoSkctYs4l0TfoXj6hctZ3e5G/9n/ooGMl6xYrDKs3CQ9eik/A==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.16/aspnetcore-runtime-8.0.16-linux-musl-arm64.tar.gz";
        hash = "sha512-IiIKQlFGuspdr7QZNHe/DE/sO57Zyps0Bzn1yngMQE++yByX/qfPMeZm5C0pnQFzP/OeZBkytkLkvCEfVdqGQg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.16/aspnetcore-runtime-8.0.16-linux-musl-x64.tar.gz";
        hash = "sha512-L4Vp4TNb0lock75SNk3ROGxg1wxfkFyoMAkxJd4gv9mb4ICM+Y9qr9agvwhnli10NqVOp7jrQqb7Me61sI45og==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.16/aspnetcore-runtime-8.0.16-osx-arm64.tar.gz";
        hash = "sha512-jsx0qVkTEo56VGFjlUH9hhnAMH1JYGLGPFAi44r+op9wozgJM2HVwwnqUcqtVGP7x+yK5rhr4n0+kmdWQkEOFw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.16/aspnetcore-runtime-8.0.16-osx-x64.tar.gz";
        hash = "sha512-KAqOpgHl1xLNORTYT/l1+Hj0tX7fYZnoBa+TuWhWumLQL2yfha9lhg8QjM+w7q3Usqr+E6bkkv4+IYDjRU/Y2w==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.16";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.16/dotnet-runtime-8.0.16-linux-arm.tar.gz";
        hash = "sha512-PyRbnUYDgJGX2B2AoH1FE8jRYIF5sfQGm+3jxrz26Njrd8dPX/rahfuK9RcFKifT5K3lRjGUVX3rManwJBfk/A==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.16/dotnet-runtime-8.0.16-linux-arm64.tar.gz";
        hash = "sha512-3bFN2M7PiAaWmBJiWRk6JaabS0eu2iqhZByMAwGy5XYJWZgct2fX8UrTfKmZNsQTb119LrUdSGAxjnr6NHR1Lg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.16/dotnet-runtime-8.0.16-linux-x64.tar.gz";
        hash = "sha512-4JJPiLZ5XWaeXGJ4hFpXS3X72bWutjoO1jgiT7jT1IuRuyqa+yct/V9A6CQdQahHkrn8/kJuj9z6FBFrwTLO4g==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.16/dotnet-runtime-8.0.16-linux-musl-arm.tar.gz";
        hash = "sha512-obQ9XKIxX9qNN3fSCqqeRyWmhnsEMNkxBp5lMN7DLmxu9kEy5xeIKO0QxaNp+MDCt6QmASt17mF+s89lMFrbKA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.16/dotnet-runtime-8.0.16-linux-musl-arm64.tar.gz";
        hash = "sha512-mvLKdnzZTiO46RZVgqutGOEdPyXJcvq60ZuXQ1FEd0qkJ3RuYFYTL6I2HiN4Fc416LYkRkHZL1EUJyI1Zau5IQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.16/dotnet-runtime-8.0.16-linux-musl-x64.tar.gz";
        hash = "sha512-rnf//h/I5rZaaQi8b4tBOz3BWonbGkJZdK12hr8wewaAdvdweboGIkEpp0IJwQqrp6QYpePd9Nvu+InC/E2iPA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.16/dotnet-runtime-8.0.16-osx-arm64.tar.gz";
        hash = "sha512-c8NROsGHgdLpMFPdhclEfM3qff5szTjfmjYW91Hw9m/cTkN2Xy4o8ZtvI9jQdGmOAr5dksFNbQm3tMocKdR2Eg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.16/dotnet-runtime-8.0.16-osx-x64.tar.gz";
        hash = "sha512-9oAY2+9/jVtVNQ4sxDHF6a343rtnyXGii8jeD7/Sc7NCX0ph/T21RvtlCjXOzntUu+ZVMpTE0n9YRugyMA5AHA==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.409";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.409/dotnet-sdk-8.0.409-linux-arm.tar.gz";
        hash = "sha512-0pk325LvCF1MNzbxvoEcV06BzA/psd7O9BmcLVFwlHZIp8aU89KpY0A/QQQMfJofeMkJygzZPBrcALDtSMWJ0w==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.409/dotnet-sdk-8.0.409-linux-arm64.tar.gz";
        hash = "sha512-7nCQqd3INHq3Q6MTKgyKeCIMIZzkW5tMn1t0G39m6BkeqBYu8X2qODC42HTHOiaxmIKXWzXQrB2jF2G1pkx96w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.409/dotnet-sdk-8.0.409-linux-x64.tar.gz";
        hash = "sha512-+4Vf8E2wEFlLt9qITjqG2pTiakPMXYWHJMwNPY7jH21k6wlVi609ulQKJQgiGbpBqn/rQNHE80aMNyDqTFUv2g==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.409/dotnet-sdk-8.0.409-linux-musl-arm.tar.gz";
        hash = "sha512-WGOaoEpT8TBQ+BvYD4uHaUkFq2AwhPjx2UZZ6i2CoN1HSnFMJVyTUVPhVLmzt4EQ4+d1RY5cMX+bL/nwYf383A==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.409/dotnet-sdk-8.0.409-linux-musl-arm64.tar.gz";
        hash = "sha512-MSj0qsPVYvA3zyJoQzH/t9OKzLtbn/iYRanuj42BDBazaqOL1dqZMgSCalm5Npg3zDIGSTz9bMW50jF1QzF7mw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.409/dotnet-sdk-8.0.409-linux-musl-x64.tar.gz";
        hash = "sha512-gGEoRapNycgUs6Cg6btoSRnfqJd0yKFCza7dTS4qFbfKp46LBsig9INDJkkpCPtgmqXziBEfpn1/ED6wzXImaA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.409/dotnet-sdk-8.0.409-osx-arm64.tar.gz";
        hash = "sha512-N3xSNwNCGD/1dcGNP0nRBGgyXyclNLAMUkbzqt+w52AdYdS0K7kT6NBTll+1kfzf+bESP4X42JcyJr8lGA31aA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.409/dotnet-sdk-8.0.409-osx-x64.tar.gz";
        hash = "sha512-suDu2U4SF0hMzIukqsjXWWs1AyrWBB60btcaqCHYvXHz4eyagsCVSA+D73Q0JYLZW12yh7U3cmkvH+OhlTswWw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_3xx = buildNetSdk {
    version = "8.0.312";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.312/dotnet-sdk-8.0.312-linux-arm.tar.gz";
        hash = "sha512-gNp3oolOQ/voJhRVAfN/qWJOh70TanEjXN4gFxNTFdMVfIe9d91UekxZSm+MfaXRdUGa7D/SWRHbRxnseS6i9w==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.312/dotnet-sdk-8.0.312-linux-arm64.tar.gz";
        hash = "sha512-y3VxuhGVatH03KArAqYXe00Kgvhe3agmfdhJjw8xwuLi9rPOhuBGleXJO18TMYfQxeNdIq+8tnaloC7JoSPztw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.312/dotnet-sdk-8.0.312-linux-x64.tar.gz";
        hash = "sha512-bh/w6VgwPRIyqaHOJkfnSqq8KKW5PhChXd8BLu2Z2z4xkqPJHnsRBttuG1sq3si6BPI3RX+oz6652LyaDokLtg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.312/dotnet-sdk-8.0.312-linux-musl-arm.tar.gz";
        hash = "sha512-C8hDdwkOgW4224NnbFrHwH69kdGRI3WbghUJBbBa7D4TNAF3f8+rpAfjvfL5YK9O6EmcRuV1uCrs0IXrSa/iTg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.312/dotnet-sdk-8.0.312-linux-musl-arm64.tar.gz";
        hash = "sha512-tza613fA9r3rW2r4dYJ7RUkmuLgFmnqtpWQ13/HRTUKQULXv/Khu2GlviDd/9hPzOzsfEeUKHfuK4ghnEgx90w==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.312/dotnet-sdk-8.0.312-linux-musl-x64.tar.gz";
        hash = "sha512-25X7BG1G3FnYsiXTcWwrMjtm4dzVOUwX5E/544O7y5NnrHM/P9tYHj4qH9RDjPwoMWH4tGdFAsdGUeZFkqw88A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.312/dotnet-sdk-8.0.312-osx-arm64.tar.gz";
        hash = "sha512-bSfd2hPkGjqY8Y3d/x/umUqWnZfa5mAc+2y9J1iyk9pv2guFuhLNHCnj9+mh+hnxPLK6ZzsMT44l0aLH12xbeQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.312/dotnet-sdk-8.0.312-osx-x64.tar.gz";
        hash = "sha512-nRKy3FnojVBdfp+iAosIlpMj/F+qIDQc7VRvus5avLnld/rc6f63FOWnVDxqclU1m0G+6mDInNUDjVnobT/XOA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.116";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.116/dotnet-sdk-8.0.116-linux-arm.tar.gz";
        hash = "sha512-FfLxzRXFY1wiIw8z/TBGb7vnjUbeCak+S5NwVze6vzae1/C5EZZeyj+PbHpmGvYLqxW1Ug4iMp+aJ+1BisIm9Q==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.116/dotnet-sdk-8.0.116-linux-arm64.tar.gz";
        hash = "sha512-jyC6TSULBIslAreV70m/A9gzMyx8Sr57cSY4xIh7S7dmabwXzVV3BkJmRmH7MrdbGEcVyPpq5VAD9yrIOyFWQw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.116/dotnet-sdk-8.0.116-linux-x64.tar.gz";
        hash = "sha512-lsY0oNFnhCn+3pkwM2ugNR0VELxNBFa51yJcXJ1YfXAOjzDoQd/Wdf/4qMcJy+8gnKh9Ectlf8svISte767Icg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.116/dotnet-sdk-8.0.116-linux-musl-arm.tar.gz";
        hash = "sha512-UGE9fDJJLJksfQGfGE8JcakRQTfsn7LrtJIbhpnv/YKKwqH3f7Yb4fRc0f7Ekz1uQA1EkdorkQb0dZt0lJQxPw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.116/dotnet-sdk-8.0.116-linux-musl-arm64.tar.gz";
        hash = "sha512-xmoQFBSkDmJTMKjLyFn7uKxUXIcaNCnoXWt4kAOzzC0gJumBBTliSO2KZq8p7/GbE+lLCrXAYK7449OML2ezdg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.116/dotnet-sdk-8.0.116-linux-musl-x64.tar.gz";
        hash = "sha512-47A8T6hvHfvHAJlTAAgqgdxK8j3ypZyjtpyJ4NNy48yVRL2wXuAsD2FUsrrJevAAFkxSSuvQqpFuxy3zKbZThA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.116/dotnet-sdk-8.0.116-osx-arm64.tar.gz";
        hash = "sha512-2HyTfYHHtBXcK/7fMV2s5giWsP9b7GTQF9q2EqrBpUSCrcfFnYYSUn5iLCJW1ehwBaIR89M4kNM/o8+uABx11Q==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.116/dotnet-sdk-8.0.116-osx-x64.tar.gz";
        hash = "sha512-Pj1nGgahBXZRrtE3jGTt6dz3tGsAXmil2RnOW/K1VTuZroKQn/H6e/kU1n+swRiYsOHPxI7Rx5wcT7+XcwhUUg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
