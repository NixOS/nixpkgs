{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v11.0 (preview)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "11.0.0-preview.1.26104.118";
      hash = "sha512-Dyv6hbRJ8/LPiXV2OLLTKJ4WvM/ZLcCvV17/ytiZ9/6kpD3y5ftdVMof08EVOnKogeRMzE/zm4gFjzbVKhKfUA==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "11.0.0-preview.1.26104.118";
      hash = "sha512-hulIoT+IUYB76iC/KVZDYwu845SV1p2vYXUM9GZh/6mkWrdfaZIOL7LNAjMRrQLZhGHCJ5oFxOP/xmHpwwacfw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "11.0.0-preview.1.26104.118";
      hash = "sha512-vR1kJTUgXzLqWDvubZxEGsM3rb2KWVJIVgbU3b5HSSYPEqp1AghovLZNR2PPXljO2uBh+vCUrpsKZ2qGwjyWWQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "11.0.0-preview.1.26104.118";
      hash = "sha512-ojlZpWZthJCaFuTza3BGKv3mJ6+5lmgEeVV3CyIG7Bc2eSmkDQhExJiry6A5yX0kg+UXHS59n4d+cb57tiZqww==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "11.0.0-preview.1.26104.118";
      hash = "sha512-EKNpgZHOaJXF6Io9OgmLDDMQpnQnrGt/D3R0fU2VaV2jPEIrcM6SbQajaYKgwCw8MnzhWBYiO1MIhnujijUcTw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "11.0.0-preview.1.26104.118";
      hash = "sha512-OGanG8q+KzQFDZhUfKlFx0SHBPGdrWCe5hef6mtMuVBe2olTznkVDQ22VvVRqoKo/gguBV5eTEMELr3MwFx1gQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-22bssKEwE+RkC5QOD6HqppQdj1krg4YUR2HpKmMkyKLaVnCHnKuepuI8h1JyXFies7BbNjDuEC0gqi+IpW0alA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-Q/hP6yC+1UpvUaxGSHL+2DNClP32SF9nH12BK6nQjBPLIp3T9lDzriuLbR22cRhaYts4XAqFc1plzgedgzjX0A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-2CAVX2j8j7Sx9kDATYg/g0GbS6O9tXlrCJRPytn9L7tIKVFv1hA4RoFKLvI6SFrAdtxKYfWG1z3VPnXL+5PrgA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-G0/KIyd1aEaV3V00gSUd6YVnSMn4QgVSxko8ULG+6/GLk6lOOeF97mTE9vnYd+gDWPKU0pWrOyOGXIZcfjZkgQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-xwA0LbPbwCMkp8p/9CK+00nOohF3Qpt/Dje+wLkIUPXrt2NsxdyoLkizqmox0iudVezEUbK/Sa9uzYvPPFFUfQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-znXNegqYqDUIEZnfvmoXV/ob8CeyKafwpwlILjQpNUIyGdCIDY/Q7DEkXRqRp5yysvvbIMkImehfTgW1n31LcQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-4XBgyYelYI6shUb6pfbjkrzNNu0CM3Swzn/gO0tdtRUo5KWXTLJfhAYsVBd6IEfJzBtUlw9bvPy74yqlMvmdpA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-QWk9yJIlMtZfvqE5i7nFnc+lOV/hICF9FLtfdp6TVCZGf0/7/U6vZJpJveeNu69jDOdwXSfbDfQ/n54i21s5fw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-QnsshKlsaQcFuDwGSqmO8OygooZ2LhS7BS/UV5PGad0TF7n6EbytJ1oep/5wH3ZuREGFeXT0nHnSWL6a5MSQ6A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-FQLfa2/ta5z3heVU2X8tfzzBLLnVWyCILX01HJ5xU/oI52KYTH+Jaf9HyV2AL0pIK5oYX/7QlBNMmFnxu7S2Ag==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-JalRPvjIj1qQw16kznrAP+dhcl5HFGn3OWz+HqtDJ39wTNqoV1lB7/cNd0snG7Dv5sut8KhQ55t6xVhsTEH0pA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-tlVliBI1si360KLm5Dkn7UnJ8HVP2LmfjeqNu/kf9YtMnl1wdbJ1WMMY4oBLN9SGoby7hN4SDvwoTh9yfaE28g==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-odU6uqDdfcf0HHfTpBMyg2l/ktIF6YYA48qNxXO07t7YQi8dwZG5SE+UB2QbuMyoL6P2pKMryO1dE7ltAFgAPA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-ZLKcijgG6aY6gSen8F5DpTfBiaHr80JMIjqpnOtjFFcAobgMfmxave3qsVhk8k3Z1lc3kN3nYxuzglSw1CbTdA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-CxhTn3gqNCwK1zqIqUs4AORMS3OdG4G2NsN+HRIhJ8XKSQrzjacEDEAftzHpLzAfjK8h+gQpm9WzcYMHH2jPlQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-aokZcJbq1JjzyKpikxzEVn28ZbULd9c46JfiZ72o5O8QGVM3WtA6sYiTLfwCuaqgES8DMi6J9wbyZtEbOGYX6A==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-tsd7GVK7uciu+59olQpFcJUwxVeLcZibBkhNPmVUBf77GVuKg2RRCJGKdP0wgpNBtn2V0Hq9H7X0OQDs3t6VGg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-IwLCI1apxFTkDcHUV2mNr/gcSai723Xh6E43oAZCQIbxzsJRomB/PYdj8vL9Re5yD42agGECPg4DL/RhVsKWvg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-SKGfp/Kz+6NsLYmTTTsJPWULHbyMCzFf0VChJc6yvJ42XVftmMaVsWJA4iGJ/Y3fLGbixr7yuCQ/f2GHZcsZpw==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-PhtwFvcTnW6q8bwIFTFV2iEXO2UoHii7L5DF3zJyRbxl+BKb60XCq31XZyLmkL8Pg1/+dYfre16hEFC6rZwtKA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-tu4VipqoxkFP4+1rimb67RyAyP8a07TikJ77h6rSkMfByH09yPFkyUsGbhTcIaT/KDcnKekeAbJPddz6IaMLRA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-2q3FlGPXczF7TnlbONv+5JRHtPtcYRoXvCTF5V0aCXOgDHDFjMZmtN5BbdvicuQClWJNLf3p17B9F6QwhH01uA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-tltUcaFE5RYLm271UPsiymDYlt4DtgsddNXxNDW9VR1xdsMepwKf8ZXsaL741+Jo923R2Rdvdjhbx9UXPW7BUA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-Jypak3kRcry1SOTEheFyJIhUOyD6UGed6hS+IkvJhY5MjcSygyaD5S1ygnlLfENU+wrlpVd0wjhU3rLF68xZiw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-1Qh27Tl7Z8zsEdATILf/uHBPpbt80kTJHF2RvkJzL36weAHoaKhlKEkJnEUkhCaQxh4YZQBC8bYMNkEnKNFZ2A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-ecG1wBIJ3beoXHsuAdO9gw3UYA5AooxCo4IuLAJig0wlTgY+dGML96PZ9Huupc2mNwn9IsUrPlQWNs8AtTTVEA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-hLv9x1wmKtS8s0Ax/t1Fbi4LXafAipf7LU04Rgh6+4g5iV4/tVxXZJgGSNFSNE1D+C2K2qDg20NJcGt9IgGWAQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-2WgXoos72iCFzde5jpDsRfTbsMarRQJt8djsUhDpCJpFFU5EI34/4FEYBOHC1uzxZ/VJ7lxN9y9wdc5gIqEKXQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-r3hnW9xG9FIXlr2HKsk0GTVUg+3ZNKSJCZ6nDXTwG6pJlN1FJw/ByuWL9dNgxK5IrK2CUfz/HFdigWgNV0y6Sw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-1xkmJGmloYHceC8U+5t63aq2HUZIqKdxarVlBXXnWfqyGTIry0bqekTnlElOlytIkxnq4Qq3ea3QMFBNID9alQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-2TtXYlIJ8atGIeccqai/eX/h8333yJxH5wNAT91NWIGsG6FUoJUBIl0vYPg08dAj66XpnQDXFL05HBb9abqjtQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-fbAceVle6lb+thunnwKs+pC0ODTci3mUxwh1P86KGnjGnPnTAmjoOzfHH6bMJrp73OPpkCM+5AUsEI/Acr9kmw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-4t00pKx73PQI9c5zhTCDfZeyLFxE0i/DcP+yYJH2LkgKb7h+WRJ0zhGSp2BHfZTYbVu5kd4p6QGbUr9loaQsCw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-jxR6b/s5Xp/IS2qQd9ufsXoOum1cunDP+6NcIp9bL42H4FHVFU9o3DT77uwiGmS5kzvdvsMMDyyWmE1ZTHA1UQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-kAvHT4pY3CnEpDJIGOMqCRTHn3WsvLMB67J25NloU/vOUuaDI1ZQ4DqKtp8fcbuDhSJKd6KoFDcCBABocM2oTA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-BCWXUvhlBma0mKUhaMsWVsrIs48JJhFXMwwnAFd01W2VdynaJ2AolXJ/mskNQBFiX3wCqfV0ycbJc0igX3Rrcw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-+u0HmYvCxfnhSI+OQAjkPdSM8pTg1hv1RQSVhJtqcMUNZhlYMvY4Gl6fK6kKNUQbbh/sF5zpmzt1h9H2/zkYyQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-GePoiWRTgWGqgFX9iSM8IKdxVkm5m+Kb8D/vzrxaw5FDR3smDIUIaNVc3JDet+ESwHOGPZ6DWada6POFewaxPA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-mEU98ElK6jeBAXNWW4svhLY+t0DY47i89Xd9PeSQcgmXvg40h+XjwEnHTGPKdmX13NXQW7md2a34jArYgPPqOg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-o5J4BiKmnJcZavli29E73JLGGLZmq8v6MoO4jXzU4ufX2zbP/S0euRRz8a2sKUM7gBze+Cu9p6pMUOzh3kHqaw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-030d+cA4U/s7f8CLMZgAtCJPdB4/llUIq63vwWSU09QyvsDuV4/NaK3p+ybfyfIODnUn40EjsyT0xm2/FSYdNg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-G/VlWxGxNSZbaaIfoltXV3yCTJdOPEkxr+BXUraIDNxu+Ts+PcfEVzy4XpFeUiJYWFoDuKJ99reqGuzS5L8Wxg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-8L0tnuprfF2KJ8JaV6bPrV+HG88RIOKxKqm+/1GDYQ4H7ftW/RpS87YeWzF8AWCRApZTcZegtBf6xsYbrZ6Pfw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-d93g+k6JdAjXKMnnmN7pX7y5u80OpX34sA9/BixaPDRnPWgIqtmtzBEF8qWbG6bSqgRE8Su5Ljcu7KaDX+J6EQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-9ueEKpU1jQz5ZTsc07uIp4+XmlrbhvU6yCrVyym2qkilBITG8xFVAdcKPWB7L72LTh7fwYN6GsNrn/ccCLA3mw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-DxwgVoIq9gHn3GesUv2XX0YT88qlJbCOhJy5AYfjyhV2n2Tk0LCD5cfbbwHhnhVIfvYYPQdrVvFUAl9TVNfkRw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-m0c4XfX9I1IcZzWgR/zAb68ir6Nt9hpjkWHq2Nip7mHOc1/Eatrkpg6YYf7Jr4Te2GyblhiCr+adrHj/tC8YLA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-n+WjwfOcYSvirmbxHpioLkmPgbVPrRc9VsDhCOgFOiBBx4QURg19upiKBH0ulRIxRGFbATfMON9UlAuVEXpjtw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-1Lh62qg5+mlNv99cBH7kEn7GmekJYzUd5EHHDIAjhDGggWDJ05BrY6kQBkWtKNPGkp8nP6qrPKTjXn7I0OF/kg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-MKnPUltEhWf7gW1BsSecd7O78mEZe8F09BaoeEGcu2VeNO3w5KjgIX19LP/AcQbkGAdSyoaa1c+lFko6GYAkiQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-5ht9RPyvcO+bTYnpX/8D6nQgGAYauSImeOFrijvVgwRW0icnH8xbL+ZM1NAM7PzJOpuKG8SuK7rsqNuiM/V9eQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-VCo1UvJdp953X5O7jeppFOBJcwcHYZ/LGno7HtuYPw9j+tQN023SaXw361vQVELa6l0NdAsxi9nKFQ8Pgc4Bfw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-EAUSuVGO0xWqxLQhALGaUb/lybY8+2wT2XAS5/+dL85ccdu4vem5nrfkI5hWVuQ5itBU51SB+v0ljF3Knn3CVA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-rf4EPoK/K8kN9uI9+dAYMAWsxLTqrQW+pYHUzPGyG7wAynr7OZ6nrJ82m1rcLAACtDxFzAWzCGY5ZrffInfQkQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-wKe1dOPvdTXzmX5/3zzmuGNbJBZXatUAyOQwQ/J7X7LYJk86u+TkIIKgXWupVIGUiigbXtArDL6MP43Xer7rNQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-1l+R5kgfIuf23MqNp+KnoMbjlNsSSu77jDGfkr1MYrhpIPJEgBaWLr6HIQRaT+RqIComvev0bjHj/zJq20yZ/g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-Wkp6fm7aZja1R6Ij9EW4puKPY0LOozSmxSjUI/drgdcl/2JRqqjCmr22b3/v4vrDg8kzYB+DHJnf0bWLt/Ir/Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-dmlnD8d1NbSFuV0QXWPtgi2jGlhogeqiwcHTUrBOPoY5ZWxYvXe3mxwQZhQa019kQrXEREGSudyUrmUvAy9lgg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-xBwqyu1mXvBQeKRC3cHMz9To5f4L3zYIHyDb1Y8aYQEEQTxp6KSTIQ/Uq5RtMqd6joIHhKHH0fx21oLyc1ZXkQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-ilJXPvV8LjebPbn1rWgEhmUGLn/wIef7JvqWroppWbi+ecMlt2Bi+08J910Ho76PyNerHCp7sqmx3yU/j2HzcA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-ZnFvPEfT9dSKBt0JPnhCU5nbsp9CCqzqp9S9jlxTXhYwqODvQ41m6MpwAKs/iOs28qAO0mK3IcT2Cr6wj0O/Eg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-nY5kA2MOA72x0liuFo6lknNihP9WgJeoCJ6yut734fiDZS26Pls/5SrGI9DfcXv1bEowz6MScudWIt+zRLx9bQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-TaqgXoqR4mFpMXn29gzyxZPixbBaRx4ap1eAz2u3A/XEALdqSzuce0V0mxtmtdcFMwd420pZGJqEutqlXLTmaw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-F/gGJqCIdzub2CQM9dDEdi1Kd+NMBJ5cBdxaQ92uJVMLPN+pcU4/HIoYKleImzNUioGj+gtKtK9DvlpQ23ykKw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-4KC9aFnGUrCKTXOwKI9T8DcfJcRmkXscUe3KqGcSW0nWnlJcbp8Uhctcr/RWxCLmJrcTbv3KTVceLalHEUgFfg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-lgWaoS8aZdtk5CQ4fE5wQaB3K73u9fE39ACx6NOIGvZLr1va3stLZk7TfHvMqiNvO7EQdjpWaiYfASPsGW51sg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-IwWkuqM6vFhumhuciOQUikiNDdneU6oHBYP46VwaH34LCIeRjgDmixB0LI61tkpowWLxxBuw0Tfu9miYNGD2vQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-R94JzaUweqk3YU76v2bCQGZ9ozqPWdMOOtmkz1Ao5LrkIZNRejh5YpwXn/x6SMCZ4PBkNHBlX2tl0BgD1YnU/g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-pvRzscx090ruYWuUC6lChWVCdcCAJTPKxVBeFiBONac3X7uYK2nv/9Me/TmC+eo+8W0e/FNSHXjvwmI0oG9HQw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-WDZVx3uNDVAD6CXNxQZMW0DuHecJXAQPkHC+r8lfz14V0LKVvg9szAFV6bAHwyoC9uK5T9w83hXyPQT8crHuYg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-imPfX0UJLt/MHZ6LaCpHS4RRR1SozeIOyZGdRJ2aWRv9xurPcBk9r4KpUfKdDFpNhvntQSXdFC188WWbPCDwpg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-jTmtNwMBOyRvibw1lBpYsgisM/UicZMS2UVnHzoTp4/y2uXJ+7acJPwCkb6C0HQvAen8XfAS9YgwMJMgorY2iQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-e2CZBILYnfEfXnpCmawVDm/8Q8NsNlZIRUIhbbQle4wDlchVau3bEJKJRhExM+4z/W/NcO7l4+8rliSJcaADDg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "11.0.0-preview.1.26104.118";
        hash = "sha512-Tb53axfvcflm6a7EpvS4IoCLV1SZ1saxRZF6cHjqIozkcZMmghv2qbtH59GzX59AC0BBOy7AIk7UfnpHfuE39w==";
      })
    ];
  };

in
rec {
  release_11_0 = "11.0.0-preview.1";

  aspnetcore_11_0 = buildAspNetCore {
    version = "11.0.0-preview.1.26104.118";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.1.26104.118/aspnetcore-runtime-11.0.0-preview.1.26104.118-linux-arm.tar.gz";
        hash = "sha512-iz6Mi20kCbvLMagd8HncgmcaO4hKgZwxEK3887R4NM6/xuW5QQVaCrs25Cq+SJrZAvvyfDYjQcxt/NDDC/NjWQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.1.26104.118/aspnetcore-runtime-11.0.0-preview.1.26104.118-linux-arm64.tar.gz";
        hash = "sha512-2Nmn/iMYnlUS52gUVt/wUEibBVyVt4PlBHJZIQ+51jIbrhm0YiKXbJSu234JJ5hmkH9aAIJS8oEnj8w5yAH7mw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.1.26104.118/aspnetcore-runtime-11.0.0-preview.1.26104.118-linux-x64.tar.gz";
        hash = "sha512-DpsazAMs/Vazcb+RQJWaCzz3E6XEQKTBOARY6pKjaLwunmLGxJdsqMRFaPz8OKIfsbTOMRZezuRI1bAWslBRFQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.1.26104.118/aspnetcore-runtime-11.0.0-preview.1.26104.118-linux-musl-arm.tar.gz";
        hash = "sha512-pE3ONDh0uc48fq5PTU9wk++bD/24YmnVXZylCXRF1vg2u7N1qTvH5PoBFKHXdL9Uk9xt30JjdYrnv7dmQygp8A==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.1.26104.118/aspnetcore-runtime-11.0.0-preview.1.26104.118-linux-musl-arm64.tar.gz";
        hash = "sha512-MCJgmQQBL7t3r/+80aCIQBgWlJe+G3R8hLob0TfAr5UmkHmSpinp3pLdNZ2Q0mU3zVpHe0zUty1WUEbwt800Ig==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.1.26104.118/aspnetcore-runtime-11.0.0-preview.1.26104.118-linux-musl-x64.tar.gz";
        hash = "sha512-B+8AWJze22JxPCKWTqb+ceKZ23fOLvrlaGl/L+Yzy1gY3Xfq/UgmEp0UVeji9b+o9q77ccKlTxDHrz2q+lpj3A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.1.26104.118/aspnetcore-runtime-11.0.0-preview.1.26104.118-osx-arm64.tar.gz";
        hash = "sha512-r6el4OpA+/D+uRyaZisVfoBHtO3HzEJCgJ8pK0zrmEjFBO6zEMmLS8k5V4q17ASDqzx3CN8QwqXvRoov5bcG1Q==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.1.26104.118/aspnetcore-runtime-11.0.0-preview.1.26104.118-osx-x64.tar.gz";
        hash = "sha512-VjiRsgXB1dB0ZX2gAtZ9DzM4y6p0gAextW3//MGGMqAdmxdbusjIhea+aeZqT15zI+WL4iRDDTlp/Af1meVKhQ==";
      };
    };
  };

  runtime_11_0 = buildNetRuntime {
    version = "11.0.0-preview.1.26104.118";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.1.26104.118/dotnet-runtime-11.0.0-preview.1.26104.118-linux-arm.tar.gz";
        hash = "sha512-EqJQxGT72/g7ptIy6hOKlSPsFIAez9IS8DZvpNc/56SUh+jmTLPevc99U2jmRW/FL7nmvnMIjOFAAU5UjuPhkg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.1.26104.118/dotnet-runtime-11.0.0-preview.1.26104.118-linux-arm64.tar.gz";
        hash = "sha512-58DDBueoTe2AYdhGGCoE1maE+NNQIIdqsKKnDsOp1JS+/vQrghUHcbFVvsoUI3/z/2xrSotD3jsbWrT1ZCdUpg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.1.26104.118/dotnet-runtime-11.0.0-preview.1.26104.118-linux-x64.tar.gz";
        hash = "sha512-pcqaaR3LRNNgBQRXzTaGkUd4Jsdnqcx0cvdWVSbkqV3rau6wmbzlH0yMtwfJ3J/3aPVzC/1QJptTdy0xXZk+wg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.1.26104.118/dotnet-runtime-11.0.0-preview.1.26104.118-linux-musl-arm.tar.gz";
        hash = "sha512-W1s9BVLMZFHJEymOZwzcNVIUc+6wcRQdWvjyHZI/cmdkX621NDUqkd3sKCjrMiY+mcjDlW7O9Oyik3mmQYW+Iw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.1.26104.118/dotnet-runtime-11.0.0-preview.1.26104.118-linux-musl-arm64.tar.gz";
        hash = "sha512-NTsGvU16r988j6oXl+bozy/tc/h3CwyB9boLjr5tzQOmaEBj+IS5h77gKC8/t817IPNsKQ6xO37RJSggp/EaWA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.1.26104.118/dotnet-runtime-11.0.0-preview.1.26104.118-linux-musl-x64.tar.gz";
        hash = "sha512-z+gK8uR2jsISRYWb0w+Jo8IaDqAz3AXOSzfqjfAc/SSVXA2zgiSFjfystJQPsjDpok88Nuv9BhqmSFdPEsyrHQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.1.26104.118/dotnet-runtime-11.0.0-preview.1.26104.118-osx-arm64.tar.gz";
        hash = "sha512-FY/UJB3r63dZv5K0kLHNdGExviIFPkWLuz1QwcDy/b8hzm/7SCl9o9ebtQZxqWYedgO/mtBVQzsZwyx0JfQeFg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.1.26104.118/dotnet-runtime-11.0.0-preview.1.26104.118-osx-x64.tar.gz";
        hash = "sha512-SzmJHM3o1HDacicabuqMJVz8TpI2pwkA6Oy8zCLg2rdRlmyRBk4Tp56Xh38RgDrsdnri4w5qoEn+YChvxxIx/g==";
      };
    };
  };

  sdk_11_0_1xx = buildNetSdk {
    version = "11.0.100-preview.1.26104.118";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.1.26104.118/dotnet-sdk-11.0.100-preview.1.26104.118-linux-arm.tar.gz";
        hash = "sha512-KYNP4Zk3HsbGAfHHrJPTz5/0KWi7PTC0vAO42O5P75aXv0wtzTwi5ah1qUnX4/xWBEMXq7ocm2av0JIO+yaU0g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.1.26104.118/dotnet-sdk-11.0.100-preview.1.26104.118-linux-arm64.tar.gz";
        hash = "sha512-bnmbQ3Rq8ebzsLlOI5FH6P6ICXBeMtkCOvh7oI+K1ku0uZDadrsBLMtWgyw+mz8cmyWl0EkTwfZ7gY11PPywDQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.1.26104.118/dotnet-sdk-11.0.100-preview.1.26104.118-linux-x64.tar.gz";
        hash = "sha512-YYf0p+QkecSyzoLq8UIiB2Lr8kVuR2VyH5Uf8I1MebQS3JPLjSUisJt7YsnGAlre0gHxbw1T09XvWwXC65DESA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.1.26104.118/dotnet-sdk-11.0.100-preview.1.26104.118-linux-musl-arm.tar.gz";
        hash = "sha512-xEK80L4GWcsagMrT4XdIQPQlheJBhi2WuIi5MmxvKOp9LYQp6iDdmzx75cMSwx7H4U4IoRb82zOgGPhrIBSH/Q==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.1.26104.118/dotnet-sdk-11.0.100-preview.1.26104.118-linux-musl-arm64.tar.gz";
        hash = "sha512-ZHy09rCxseV2qD9rsl++3ZWPtfLHAA8neNZVoWgglYfdAgiVCZSW1ovkHbCJkRg1XRx5hH4k3CtmQwDb0L0qiA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.1.26104.118/dotnet-sdk-11.0.100-preview.1.26104.118-linux-musl-x64.tar.gz";
        hash = "sha512-xpyXA8uqSl8sTrl2bI+tcHOgtvAvaMjYy4dhrJiaMvjVugjogeJBvbnWbsDTaXmNDemvkLvEnKo3yNwcNmvVOA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.1.26104.118/dotnet-sdk-11.0.100-preview.1.26104.118-osx-arm64.tar.gz";
        hash = "sha512-clFl0qEyxq2rFsKCzIQ3/WlAjGvDcjx+ahj6ID6DQscGwLstDJ1DCfWI44GmOe8ZFktkUcIgFS7EmUfuw35Lng==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.1.26104.118/dotnet-sdk-11.0.100-preview.1.26104.118-osx-x64.tar.gz";
        hash = "sha512-m1HkquND7AsCq7HXU3kFApukL1C9Vz0B5Oz1m9Q49zm3eORjo3st2u3hWreD+j9wejBCJXZTKERUOM02tQNgyA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_11_0;
    aspnetcore = aspnetcore_11_0;
  };

  sdk = sdk_11_0;

  sdk_11_0 = sdk_11_0_1xx;
}
