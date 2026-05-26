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
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "10.0.8";
      hash = "sha512-vNyn/JHVXGhyYeBhw7pqz6QvWGzZo9gzcqzVeDQAT+jtmpPs7JWwSoReFuEyqgOimZHgqUe183WTRy3EVgMBpQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "10.0.8";
      hash = "sha512-q6HoPU3tp/n68u54V3aBhLtkgGxGuICYAU+LHRdPlJia4NaYhL5HU/XeU9vcxuDNjuMdHwSbczmAnU40Tyh29A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.8";
      hash = "sha512-Wq3nnkJ8rzTmxMx5rVSX0+pKpkRkaDAn2lxSVwSN79KJqtYChizsGvgPiOedv3aeOd2Ee2jAGdl96dQpB99cyA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.8";
      hash = "sha512-EhxzvB+paGDySmChYU9rXnZi38Z4Cspdc/yyLMQ78x+BxpuBrtrZIKgAVjRciCw6MLQDcIUctPYwWKX3OGjLgA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.8";
      hash = "sha512-YjZC7Ns/gRh8wbk790Wx6uFXLazo0jmpD7K/UJXe7i2ZdvmfQckEkVwmpcQlBofnt7WfILXW8L5s1o664mqyHg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.8";
      hash = "sha512-yNuRbIgHulQY/OjXMGK9UNW15MZ+geDD4J4s/djt03c5UIOdf8LDtxBhjKS3cOHl9PGqm+G1P8zunBbRtEDOfQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.8";
        hash = "sha512-23Eq50tK9QdrDLuCkYCguN5Hy7S6YgK1WQTpeE2QBvchR2E2j0/Mje8ihJ0akIv1rNZJc5Pz1jwI7Z+OZrc35Q==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.8";
        hash = "sha512-wzbnex0a71Y4uGa0QoggaKKe5mZhOxw8a1cBMipGi+Aq9cgh3uPa446aFGtoxfB/vkPoSEBZIjuvXoIR3ftYOA==";
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
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.8";
        hash = "sha512-q3H3uZ7wb3KjCDxkJaUfE5jzlaYRGEIVBGU1v3lUnH7qGna/a5Ore/bVMEshn+9xEFEYWt+hH520zQkNdjuVvw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.8";
        hash = "sha512-6Shf05CQug8BLvV3KpLpecO9bqoT0OxdgUKM8AKiD1uyQ95+Cf6cDLKKcIAhNVHWrXMxRBVukoD5T2BB/a3R8w==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.8";
        hash = "sha512-GsF47cZc2I+HsafD1XZDqh4YX5VjCbo3EWNYabpaGoFLuUfhJDZxZET7XDaoN+gpGsqz5cAPgNhPhxdXHsutog==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.8";
        hash = "sha512-Dbi8k/zNM3OKXRBiO71rvOESXL8eJLZ17N7SQyC63Y23YlPqKyT3xGh6f/3kDErhR6+oJ+8Lh7B9ly8ZB/vlOA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.8";
        hash = "sha512-EsCW496/3MzNcGam9Ezql7vuM8axMTbwu42SZaEd2iLVnXcN99VCjWolEYn5kCR8XFkNaeOr72S8bZcf/uvq9g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.8";
        hash = "sha512-jxZ0ByIbNlqWrzkBm2LVfHybSYUcSWxHf090Rxafnvy8Zys2NotBo1kbgWMP5bv/jl251eXGZhGTHjHhwC1WuQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.8";
        hash = "sha512-G+Y46Q/NoVkCjZKTJ37lWmdhOQP1/hPSTm/Pi9dDS2F3oUlh09R2NDIn5kVJXbeI9rZHsM7nXWa3wgrJadOzWw==";
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
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.8";
        hash = "sha512-IEorwLEXLyw3Coxw+ivFw0Oq13NEESMtCHnT773wHt9hLHhNMQkLKekLywVI/l0F6rtDoxtz3vWlhIX0EMztow==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.8";
        hash = "sha512-c+mezC2xc56VUv0+ay+706cIYqlAWn2xCT5PSGatxxijEL93VO3ZXCiPUi2TevVxA2qzAjb0LYFBCGXMlEfQNw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.8";
        hash = "sha512-8dKaW07zipCN/afTNbJqHV9cALiN1xj36fHb1wkAFlqN8Euh/41odyuZVc9CtUFYzPIdnxkxBAU3STVQuDuvLw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.8";
        hash = "sha512-imyB1A1l8k/zBEfnNHUmDsFsbXn/OB/UgJFFipaRLIuJDxoHo9vWs1Qqykff+5B0FCzYDWA5VgKGQ1krXdZ5sA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.8";
        hash = "sha512-5JjdiUzqvvMpIucy5v2VrXEymndrB7744HFCbDsRG2N0tSrqyd5wjqgJWWMWrU5QOla3yHI6uxnckTnwIkHMDg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.8";
        hash = "sha512-zNHVnCG/iFiPj1B5c+Un/+PLdr1pi/UZ6BeSkOs6OnwuCngK6nqJ57r4RMe6zGnBafwz3yl9XXxQZ/AGFOThrg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.8";
        hash = "sha512-IUV+7MOJJDRr80trN+Sv8m1mD+c3YyDxu/jNxhMwssQYD88wj6QhPsOhMBxWnQ4nkok1lPa3dZCI0Z1giSAzJg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.8";
        hash = "sha512-VJ3vPHXkIaBi2UtnqeoP5DsbNYArIObhZVRYbUqhg3tZuV0AzxamTe6fIHg/XKfIgo5/cQmWxAdEe4AQCjCnfA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.8";
        hash = "sha512-YFMVdsOtApNUykNADb5W8/U/KjLz56zDdyADtlZl05ZBKS8k0WOGup6eIsauMwUPZBWKna0V+Kee60XpARYs2w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.8";
        hash = "sha512-KNMxffTuibRTba1jslw6bvUQqRvSm/ePuJoiHfbYlTvQZIckbKeI2GabRPnOtNlwa9a2xQW66V0xaLGv7vGmKQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.8";
        hash = "sha512-jsjb/MyXdTCb2B3qql8TTotUmAz8nsnsU1Lb8NpLa9f1lBfb+f7ZYYvv6/nkr2LllW6hoea+UijHSI5Zy8fo6Q==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.8";
        hash = "sha512-hzgUJpe8qMrTjLAjq+Yzuzb+xzYkZHdj1dE4Q/lML1+LUNnZEG/sKsZ4/Kznd9oSrwIlM35vjQYX4ZBI1dRagw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.8";
        hash = "sha512-riS+tmHmvr1Eq4srbAIPS4t+PmuQV9vV0G808Q3xDsAhHA2XygpvHuv3NJRZTquDyDrB5Ecga4NI6+Sk/4bCGQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.8";
        hash = "sha512-yHie172TlKeihK19ZAWZXtu011zxETdrkHaHzzM4O7l5sguMzneLVz4Vzdw6aU8XaS9zLaJlL0OZ9oJdz4MBng==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.8";
        hash = "sha512-5qgBKif3Zc5KIqNULoIl50gaDusoDJSRzrd8DOTEGdog2t/cJMgTXNj4w0fXerPzuW9usM9axFI9Y+Yd/fcxOA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.8";
        hash = "sha512-5MITdny43Jw4izO5MF1s8m9d+Ro4/dVnP5uYnqYwGEQscyaGELMlOkZ6gt9jwq9BvqM/8pBsMgJL/xWDJbP8YQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.8";
        hash = "sha512-p4HjGhEhYP3A7Bm4YWYUWbrMsZIJwr5MzprNkRiYs23nMI3AVNoWSkvPA6HbVFcjYLHRNcfVT1kPwfrQye8BvA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.8";
        hash = "sha512-TNvc5kidsZI73fHP5dByJI8Es4/xFIxjUgSS1Yui75H3q2QaBJg27pu7YYwCHom3o7I0FSKwWwN8HLH6+kumFg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.8";
        hash = "sha512-DAbtdRyMCku5H8sO0rV7Fx+K49LXzlkmdcmi5WcD/taznl9OEcHKLy15WXJAQkbx57ibbJ35A8D800sOAhvqwQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.8";
        hash = "sha512-Q1FX7O7NG1nrLZRtqwTnFy/DQ2a4GRvi/KX2qjo7ScOt5lT47zx4cDlp+RZI/9BGWKjPNI6iC8ucRml5JdmX3Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.8";
        hash = "sha512-airwSV6GYTr1CCbm0ckrA7Tw/mPFaikpkIjQsQ2lHSBZkxDYQapVbZUSy2HW28idWMczY/6DNBpukZ+4aM+3JA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.8";
        hash = "sha512-f456nLQPCZdank1hFJ9Ms2PjCTHrb2P3ujP3KoIPEB+UomqgbZmoNMcIcaPuWunOuAinJI7Z+2V4EZqo32poFQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.8";
        hash = "sha512-NV8n8/HhgYcyEVxrGoJp4Zr06nVReMeRP7/813A8oLQzJ2/VMqTk3FlFIEnAYaGcMQ59u7NnsvPmXL3M5hFdTg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.8";
        hash = "sha512-uH/Tz9QQu+nfsYCpI9C0/eMUrY27j2NBAVOXgCXXYzHVnlimlsSa1LCS3I+ICSJ0u4h4VGnRBXvL/7pLXE4AcQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.8";
        hash = "sha512-2ao34NfylyQTAsK8t3rnAC8gcs4mPxyZm95Ilke0uMU74nio2YHqp9HOdccJIoS4YOhb43mly9nUH7+0PORNCw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.8";
        hash = "sha512-psq+56x4fcdSiVDrOSguvyo2Ho36tff+XT2w3NOQ/nhHrvLINSBOp9DzybXTBpn9iTbFyqHuWQ7kWh/0i/G/5w==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.8";
        hash = "sha512-IC6Cvafvq3lY1og8QjrCk8gjggrmYzqGyDMxwZP1xpcfg7jQJoSWPP5kmJJfW8NsbyXwCY10Gr/vmbQSdI1Yzw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.8";
        hash = "sha512-1b3lfJzLH3atQrh2/P5ADd9u29dOt3tiuzfwGAydHJ0mCbfOG5fElC5WD3/iiwkrxKJebx8ilgfzSwM6OM/e9g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.8";
        hash = "sha512-yR1lfM0ZeSOmI80HRySy+8Wa0X/79TZ/9gqvjMjibxdhf+pjijn7yPCW7/IRtimGHcjYm4qFmsCMKoMa+RYFoA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.8";
        hash = "sha512-uqwoRJflVDwj1Z4bMJ1gfzFqxC6WWvKII75EKyAoAWhrzvzZpE0ERmeYIhneQIUs72XgxxV2nLjELUthVwTQcw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.8";
        hash = "sha512-VFqimfrmSsdkD9iY8SZ4+6kLj/jwSDpdrPL5/s//zvEWQ0oxYPu64fOBJMXCyh8ZPiu2rlnlSCSzHqod9SYEgw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.8";
        hash = "sha512-DdEVs4sQUmirRPTzMVxF4Stg8JpaDIoAI9i9CJo53DiCbSH2/WymjA3uK03AjUwzkbNsOSnNXeN/fmuEWXKggQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.8";
        hash = "sha512-tixfgcS67cNHzitWskw7Zoq34yXIDjYkqbtogXI+uDarCyNmKcOtUUIoEnQgvFPaIQIT3S6bddUGAuXC+0nxGQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.8";
        hash = "sha512-x+ccA8ooQZMnSgkfyuMvKq9fMw8HlLtS0DFQpKswLpb8CNvwy3TXRQkbnryqE2JE3lmCBFnIzyjWnhiRiMrSfA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.8";
        hash = "sha512-t8Eq4jUPg4iamRRpfd9sYFiOFwGdEkCRiKUZ4CJNpiiB/rJ1kqyLQJC6MoEyNYM+bzmq67izn45w8eZQxmJ0/g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.8";
        hash = "sha512-042DX+ETG7KS+su9jOnm6HsTnblHPK7NQDL9UEbY088wo9DUkLdUaIz8FUkFrGVCmg8piRQ5hf+CynVm0sPCSw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.8";
        hash = "sha512-J67/wX1yjJYGUXHGCO7zKLAWB9NtTVkysSWExDeGsXp2ytsKi32AxSafayDAGp2NmDvB2UJ7Un9TOtbQ5GWrUQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.8";
        hash = "sha512-3S3pcCTbdRqXbNusHcOGoXTRe9U9oAEuICKxyCUV6GSVGxwWaS/DiDD/H/NH4qNe7FXuqZM7acx96wzgg19uKA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.8";
        hash = "sha512-StuqQKnYTVCKlxGc/wRiTmDWIPKFdkR/m5L31RKmw7NoUS2ueTWvBGcIxbSJ2MG6VKWB5wqpAD+yqJCaaNhsMA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.8";
        hash = "sha512-Sgrh/Ud52Xbh1Uxu6bWVmgu1qrQzyQMWE8/nYamjiJEvwO/PGiLxARtORyhMFTSrzgTN1l5EqibdNh1Cr4+74A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.8";
        hash = "sha512-dOrEDACkshAh3lnF8CgWzkqk636eX5PAv2JBhnfmqHZJiaOsAI1KxmAs8toVShTFxxmJYmW+XeANKqdyQBtkSg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.8";
        hash = "sha512-CaZbXCxBP1vRSvXxiDC06ioZNLii+1qmDvAcw9x3o3MctJaTw29HFR3dcOh34HQDE7WcxIF601JD+6ECiP/wYw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.8";
        hash = "sha512-XXpeRZIy+BF8VawZvXva/Vr5RyFsxHu02NABrsDb26TUmjHbAvwegir76EHJc5+PE8yOs9lbTc25EMzvy2G2Ag==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.8";
        hash = "sha512-pyDnS9j4ibCSSYmqRGIYPZ0YC+btqRB/MloOZW2oWM7m1Tc3nz226FZObkVdVez9YTwcVcCh7o6VfNJD7ps1mQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.8";
        hash = "sha512-Aaotx7E7JvD727QOqpvzNDgyrZ5hGJKmIWjJ8Mxezm8aQbNZbSqcMgy4qYaud4dHwR20gi2QleBWJbDR2dPkuw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.8";
        hash = "sha512-s4E1DoGP+x+Ec80VoG1rqY89Uyf9E9kGS/lV86TRfGqzPLGVBCslBkL2KKwK5lIg5tJ8OKC9HjRZnj8BiGwe1g==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.8";
        hash = "sha512-2PGJJE/fLUlRRzpBtKoDtOFKhscJr3keit1Gx68UbpzFxMA03vwyMGBO97rTMr5tfrGDLOhNVWeYPvGhOgi9fQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.8";
        hash = "sha512-dXQ+rq6SWqojHAHqHswlkF57A5+dobsSFID6/K60s3S4BP2SlEc14Lcbu4xR4Kc3o+PnlKUVYw5n75BTYtekfg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.8";
        hash = "sha512-kKN9O6ouUivXmUZqSGX+oRNWNXyptu/OVBtIL55M2DMaI0Nx2cyjk5stWgzLMKc7QAXESU9XWcgNuSe63Qoxtw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.8";
        hash = "sha512-/QfYtqQjMbrfFUhkAyyDXtWW6POUtDt3pzOMz3L2ELTTwBDsB069ZGwjNDE4Pj4BIPmXwTJ4xE8zLVLut6fS/A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.8";
        hash = "sha512-/mNnecl1zw75L+RR4U6vZ1aKXpNjk09UfWlq9FT770VMimtVLhXlHyf9P1G5kTuLQayxhWPG+6KlPfaxv3jbAg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.8";
        hash = "sha512-o/gqEv5laFihSLfRgruIdyzAAKViqSmYKozJK7YzGEzfkbRGDbm5cCI0k//B27O4om3EX7pY2P9EpVw1CPrfpw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.8";
        hash = "sha512-sOaoHQfZUtOcLpjskzwdX5d9Lf293K8wdIqFbO1gsTm4+bkFNmOm6Az2HVVw31rxqjswhlIcmhmrJaSbWafiBg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.8";
        hash = "sha512-IJsdsMngU8E367VanwCLLjNxRg88VuYMs4S2HAtZQaltPm+M2OJTgZ308M1Le6H8Fn572usNLCGdqHphUFs0bg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.8";
        hash = "sha512-5j+Bpqqpo0mnqclZBw8ZtKcKecucvIuQuNeytYToi8nf6oFVsdGv4uyDBZyYvgnyTu0+SaCt2LxZ7rOflqt1jA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.8";
        hash = "sha512-wHp4ZcdbeRyeXQkGSqdoXWFNf3FktUPysWvY6lJAqaL58BhhFirrE1yKHCfdqb+m6lJ4+vJRf7MR2rrjFyvo+g==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.8";
        hash = "sha512-u6tJT5sTRpwQhehJnvHdqFuxdPGR5jkVdargHs01DARtx+xlURoGcnr3DVbhnZT+1tXyL/3wGSdFHk8gNN9JOw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.8";
        hash = "sha512-f86+/NdR1ZXT/fp+GiQqAS4sW5XusFp3ILXl4fQBGTvuzoJp4bYB15NTG+pOXu89nSjunSd+lJ23Y9cpfvhaOw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.8";
        hash = "sha512-hA60zCyy+9Widq0zDJmhvMwbuE42Fsv05X0gLSd8ur5ukQFZHnNDq9ewCsYsEc2SxCEhKQiVnD5amRmYXXQ+4g==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.8";
        hash = "sha512-LJZV2OR+8yINbALSkvFM2eUTotC+nAAVH+EtXaAxh9zXcbFIEKPSrjpzVTu/VKovNxysuCjcB20DAohi4QQ8jw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.8";
        hash = "sha512-ZN9K6mWVXEwudiMRxdOTJIym3lkn3Tr6dDg/PFYskKAMtzye0TPmG77HJYo0kyrarBc1HhtaK3rEJpwEl6x6oQ==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.8";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.8";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.8/aspnetcore-runtime-10.0.8-linux-arm.tar.gz";
        hash = "sha512-g1b/9oR2OKh4aTsfe9ffICneex1H0FwV2PV5ReBINeH8ltko/nJ/3xF/KWjg3ALSlHX5IPCpnzrTJ9Up0zvN8Q==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.8/aspnetcore-runtime-10.0.8-linux-arm64.tar.gz";
        hash = "sha512-S73AWGsbGS2kNgYGm5KYkn0GUnzcXWG/T8QBv9Xgv0MDYH3LCdgi35Tcx/lEdIbrs5kFk8Lly+3sw1/i3jdFfQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.8/aspnetcore-runtime-10.0.8-linux-x64.tar.gz";
        hash = "sha512-45f+hSKveUs3yzEwR/t4bAYIUKEZHQ7Aoa4kiUOzz1FbJWUKrwcXmB2s2nhR5Bjz/ZDEwoJ7e2SV09tL6/HXVg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.8/aspnetcore-runtime-10.0.8-linux-musl-arm.tar.gz";
        hash = "sha512-FdT9/h1zM0bu9jtlDRfloG2tqGDfpJfwTYxka99+L+nT1T5wAmZ0X/68sPA3yCTIu0LZqft9f+0VPgp2lxVwCg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.8/aspnetcore-runtime-10.0.8-linux-musl-arm64.tar.gz";
        hash = "sha512-jv8BTE8AFx3IX2EFaDE0KxV42IpS+sBXcPyFXhEgUd5x89TYn1/WAbwblYTB3YPDiofWx3D3e5cYuyvCWCE5IQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.8/aspnetcore-runtime-10.0.8-linux-musl-x64.tar.gz";
        hash = "sha512-Jl3wHFdk8OnaLeyNVbmBS7IwzhtAQBaqDcVs2xVtWZn8T2e4srQ5sBRMu9KP8+ubEqPEL6imoDITIK59NVnmfw==";
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
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.8/dotnet-runtime-10.0.8-linux-arm.tar.gz";
        hash = "sha512-IcNl5MCKedSKObRDfL0gN05gjNxPHeLeNfdrcn1aOdaGYFgQ7EeIytesj1ZBc0XrJlyvOxWTNaffHAhVB+OYmA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.8/dotnet-runtime-10.0.8-linux-arm64.tar.gz";
        hash = "sha512-FrItoZpunhtzG/FNHYKtvE7vFtPOBoIulEWWSQXzjoIrym/UEGquMcloi/emCbuF86Iphe4emb2qVtVPqom1wg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.8/dotnet-runtime-10.0.8-linux-x64.tar.gz";
        hash = "sha512-5e0v8jJs6DMmnsqPNcKwURxJ+Vhb018rLDNUhL7sg0j/TvX7SwEzW3jwDR0XrZz9dWkJ2Efsbq7w33ids2Ggrg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.8/dotnet-runtime-10.0.8-linux-musl-arm.tar.gz";
        hash = "sha512-oS5gHgVwYNh1ELBT0GtYRIZ5y9X1BNnkQsF9znvc6k9ZrRJZk1507Tvfr9dCYK8p6px1/08na5bXio2ahnpxmQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.8/dotnet-runtime-10.0.8-linux-musl-arm64.tar.gz";
        hash = "sha512-sENNus55F36i6b5mnooEryPiQ8gdr4z6dKkFeTqhftkepyXyPfUHJlRqXz3wi18G2Nv2KfCPMsdD2XnhtA7Okg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.8/dotnet-runtime-10.0.8-linux-musl-x64.tar.gz";
        hash = "sha512-A54AMtJQj66R8ILfe06JIRJ+I70BwP1NVBvKPWEux1LkexXbwvOiMAohwS4sdVz1xLE0UX92tMJNe1aq2U8u3w==";
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

  sdk_10_0_3xx = buildNetSdk {
    version = "10.0.300";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.300/dotnet-sdk-10.0.300-linux-arm.tar.gz";
        hash = "sha512-JBHfZmClYCn5mVrvoLK7ZsXkkoInti6frP6OIy7+qUTEJPowD21fBWM+sqpSpxazF2xC+byJ809NKln6SoC4vA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.300/dotnet-sdk-10.0.300-linux-arm64.tar.gz";
        hash = "sha512-tQP+DKyPh0jRrmevQLyRV0VswPk8gmTjvFLMUqEvu7w6FukF2FKCFPKTN9c0mFm7CN6ZseFAbaknI7Bxs/Rc5Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.300/dotnet-sdk-10.0.300-linux-x64.tar.gz";
        hash = "sha512-oMQEwaL4XXDjI5LOKX6ziMAxDFGVIbU4oDGolUaURMZ/NH1PnKH4RB9SWWeonJt14s0WdtpIb5URjPQCXDjZBA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.300/dotnet-sdk-10.0.300-linux-musl-arm.tar.gz";
        hash = "sha512-4zF9GB39Tg+jdPVtn/MQytMR4/ONmW285LI1T3jHAKb0C2MJogTaSHBTCzwU26UTOyVJRGFQpQO3Vt2ULly+0A==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.300/dotnet-sdk-10.0.300-linux-musl-arm64.tar.gz";
        hash = "sha512-DKcqTxtn9CIulwYv4aXNcrGT+hUjYDJNx+4No04NPicPnZ2yp2+ev2PbMegs2Cpg22m/YYLeEY8bDqDy0YDUwQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.300/dotnet-sdk-10.0.300-linux-musl-x64.tar.gz";
        hash = "sha512-s80bxWST7ho6X+q9gw+BfGRDNuzogj5iR3rmsBJK+LzTb3UX5Qq+NmusqbFOl0+JosBxzEpUrj1NOTUa8z1BGA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.300/dotnet-sdk-10.0.300-osx-arm64.tar.gz";
        hash = "sha512-azuGrxfoM/kAaUYeRj118ZI8xi9Ov3nNYFCXsVXc/qIlejIcGunSD3X3WSDFvrgjK2jOWymTrtwzMStB/wmr9Q==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.300/dotnet-sdk-10.0.300-osx-x64.tar.gz";
        hash = "sha512-1KXNaKldA7s4dtQEkqTVOvBZWy18ewB75U5JgZjr4mkqvefv0a2FabLsW7oalzyRKmhRCzJZb1fLbsT129YDew==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0_2xx = buildNetSdk {
    version = "10.0.204";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.204/dotnet-sdk-10.0.204-linux-arm.tar.gz";
        hash = "sha512-sjcjuc0H0opxuCBcPAgp0DIcukoP59QWCHOlWrAfaD815rqHTG0tA84R9bWYO3ONkDGPyCvEIWBctZ6O2MA8gw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.204/dotnet-sdk-10.0.204-linux-arm64.tar.gz";
        hash = "sha512-QCMoTp/lpKBlON0kS7r5bM/DwwpLLwwQgSn1IO68Icsu1fkefBwEqqJ9X0RcziiAMhmdLs233nrhVwJI3gN2IQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.204/dotnet-sdk-10.0.204-linux-x64.tar.gz";
        hash = "sha512-VIIrFduTw+plSqSFOXEmsZdTQU2zjbqskC1EZnMHfFZ6TX7jSItetu7wdH6bVX+I3P3JzOVXhMQ5MOjggQ9YxA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.204/dotnet-sdk-10.0.204-linux-musl-arm.tar.gz";
        hash = "sha512-CMRgi2f8FQE3EX2sFGd1lL5WFABOWnNQ89Qw+WEi1ww/NCjhrKzy28Ye7pnqnVZMGwpzxQFhsTA5cC6PX6Awgg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.204/dotnet-sdk-10.0.204-linux-musl-arm64.tar.gz";
        hash = "sha512-tfyLQtIvkECUt3s3Q+7EEN14FazJIQ4j6oByDhbPhgR2kmYz/18FDNGgJ1Yxai3+dFMiFzdol49/otgYlox26g==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.204/dotnet-sdk-10.0.204-linux-musl-x64.tar.gz";
        hash = "sha512-9n8YgREZpdD+47Ag5TtaFoVx2RSDDxkZ+g9mQh8OrMIzwPP2zWR3hm774o92XoBWD/2ScZuD1GLTI4qkpYBulA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.204/dotnet-sdk-10.0.204-osx-arm64.tar.gz";
        hash = "sha512-9Kua3ojSjwXz+J8GS8Lgt9nqDFefl0zuUUBZcQz8qzkeHMGRNDIKqHgaWhpRLUuQGMWwziPgat+S1MgNZ/pTXA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.204/dotnet-sdk-10.0.204-osx-x64.tar.gz";
        hash = "sha512-htg086NtW27haMXMgxMN6qD+YWG4z21jHBaCO0yvLolEBt6Frlb8KhLv2iXXVb2s75kLonvK7EAjZbdq98RvDg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.108";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.108/dotnet-sdk-10.0.108-linux-arm.tar.gz";
        hash = "sha512-89FWOUu5vhmO21bLSNe0qVi8hS/YvUu12HJHptDyqqOHylGXmXYY+vNyJXVswBl3dODA+v8W/ZXVkzVKKXLaBg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.108/dotnet-sdk-10.0.108-linux-arm64.tar.gz";
        hash = "sha512-bEhUby10OOxnMwtUFLtlzTPbNiPWQA+Nl9LEc6EcOdQJCUOwfL75LLrd+HO4behy5dsHbEFUCFM5BFHsQ9fyhQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.108/dotnet-sdk-10.0.108-linux-x64.tar.gz";
        hash = "sha512-4y92t2gBdxiqWjpR/KxLYXq0QoxfLRCxsw8H3X8eo9rU35F99I2FXXijR9Y15Izg7DCXh4mcU6MsTBDdIWtrGQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.108/dotnet-sdk-10.0.108-linux-musl-arm.tar.gz";
        hash = "sha512-NFthHiGF40ZMruPrKFb/IQSyVr+qw0DgQiL2G0js5HUFom5O3dSy/Jx9gBJqxJ8tvlKffhRpwu5rJv7WWilzAw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.108/dotnet-sdk-10.0.108-linux-musl-arm64.tar.gz";
        hash = "sha512-XeqyACfcovuxYjxPVA6BG4KBUKHR0oOeQEBLtdHrlXHDIEJy7FblZuYXCtBMGAz0gmhT7ZhhrHf3mIfM3yGGKA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.108/dotnet-sdk-10.0.108-linux-musl-x64.tar.gz";
        hash = "sha512-eIBLEbeVQ/HhK38ZPyF1bl0Fm571tkpz4Fg2eI2R8FSBJgpqp7zW81hNexhPMmZ3ccVoYAccqm0iajdTMliccg==";
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

  sdk_10_0 = sdk_10_0_3xx;
}
