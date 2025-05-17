{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "9.0.4";
      hash = "sha512-3PtHQSZxBCCvfmDGGZi5ksZCpZRdYbtu3LrkeBi3SLIqH355CawHjAAjXJKZWHdIzvbjU57iRAjFReSZVyUKmA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.4";
      hash = "sha512-9652qoJznQPLtcYKcRiuQ+5Dtwan0GiWPUnbsMmMwJvyjW/6SdBH+o3UaqOxqNpB2G3SKjJOhhw3N5SFWn6l3g==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.4";
      hash = "sha512-ESpNNBaKWwr1erNvVDgK2vA2I+zFbiMehC67VceL7kR6mLMWxN8oqZlQqAfgvJYnCLZkH7fzO7Zxb9qevQTRZw==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.4";
      hash = "sha512-lcUUZSXo2LltmwwGGguxLb/nbV593pxPfMAZu2khUEVPDIlaibGhpoDec310mRzmUPaAB6YW5TCiwXVMkzvL3Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.4";
      hash = "sha512-M4qamLjJiYkDJCgSuMzo4fSpOkTVP1GXOornRjb9hXM6gQ21kpsCODmQN4KL52dJnUDWQ/iadeMDfYbcnRR9BQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.4";
        hash = "sha512-rNmjYBMPRwPf1doT9lroKtMl2oXNAlzTswoR5qmNQYb3ex9vEwST/7jw/uLdFnkrxZq61miCX6zulWqiCDBvTQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.4";
        hash = "sha512-6Qot5GbyZ71VKIjXQWZ788C0eNdeQ2k52/iowLZMALvM7LlwJmnZNtf+Y5fOJ4DUMxdtNLuQnQFixl9RsoWBtA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.4";
        hash = "sha512-amO7zt96OGrM0WoU0WfJ3u33zrfJTzW9b7+8otzwkw2eSWHdZQ2YzG+tfAl1apn1teVo57dmyk62GXPSds/ZDA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.4";
        hash = "sha512-UGP/y+jRzQXL6yFQz+M6bWncnfyswcOzW3Ucgt9j0lsICBD0yY33gs0D2/ylUNUIF1Nt0tw+Npsa39+9JtUqlQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.4";
        hash = "sha512-RJOJcMf4cnjCdEYZDjrbdB1mzo3lQ5EO5px/h//Yw4hgfCCC4o3LlXZjwGs9TrhxjCLOyvLDUTaL7hiiwHu98g==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.4";
        hash = "sha512-3E0/4Lv5WsOlUg1ZnSGU85d3gKZht7bqYUt1iLMoB+8MgQzQ0eC0dbX42R9e1/cFKD5fKV8CeRY1btiB01MY8A==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.4";
        hash = "sha512-IjirV0j89JOs05q+cVhHNB07Jkocmfr3ovsP6MHJSQ4Y/j8/qnwuuyYWkq/T0R3jzR9AJNW1RbEWTTYgtkXpaA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.4";
        hash = "sha512-w+VA1zUGa1zEzeAvbA52TWuHhNNeXdzvAUtsROJirqZOxSBkeEJJ4wCCR7f1gbNT9xRsXrt5zr5w12GYWOiePQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.4";
        hash = "sha512-9g8ciWAj0YfdPZ2p1EwPNWe9lw5QBS1g/wz6fwfrT5Gv2am+jFRSycSjNgmMJBGl4r56T9BU66+wpCe1n04TOw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.4";
        hash = "sha512-w5Nv7R5RfW8VAhXlnvN4aLwyP90zATGAoHBq3sdF7dBXeUjmAa4i1dWFFi48wpXt4pz8WqGCagC1lrOZN2ehrw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.4";
        hash = "sha512-70I57to1fSmmxUR4/x2933gYT/KWC5uDvMbmm6UFsd9luuB6exMQ2r7nGszjPNTpIE7r7T5Nab7MxxHa3VVj4g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.4";
        hash = "sha512-qFXy+6HwCF9+e98d74IIuSIbQQ+SxcYS9+G7WiI/mlqVwCf2himA9rns2i3h0Sd1yoWCQNpWufZX75XcwqUKdA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.4";
        hash = "sha512-vn3eNLZU0vHGep2lJJJODP88ZJeUs16uR3JAmBPcrACCm1wKS5TLirKnzfABaAnyG9BZhUj+HnrEed9k2J2NsA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.4";
        hash = "sha512-bUz1iGmI6QgbUu6LU/fYOxrXLjZ7mi6UJprNkyvK25XwWu/pgz9B/h1aweVlYUsbqGzc77+X7sal3n6Tk9T63w==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.4";
        hash = "sha512-oZrkhwt3bcUEPm/4GZofUoCnP65wUUS2iebQMMEyZ5D4EDyvh+XUaoLEFALuR8jTI4FZagEJOmraT5mh9vItDg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.4";
        hash = "sha512-IgZKzsTEKr58aJQusmVbL9fgBJgvd4N0AL7na3upkvaaqyJilbZWH9LwTDop4IFBU5YsU+6eFPmSzH0+wCnvHA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.4";
        hash = "sha512-t4G5IaInNgvUVDBgzBaoXEgck5pkVznoMKDvGi/Mg12Gaq7oiny/h08uxP8TIgEV4gxauNmkVSwNPjm6YMafOg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.4";
        hash = "sha512-/qSCUmX8PrqF07YmNmVQAp06ZskYWgSuVNEsBtG0AUK8JubUNwuUXgOQBUwlnmes90SmSoXSOTtFOeKQWTEU4Q==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.4";
        hash = "sha512-7PP+4qxaIvxx8FCUv/VRyiwQUD+RQLauRCcPp6q8g8OIPctopRAx5ehyp9knsCM74TsO7Z8r03QIjQCd78iy5g==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.4";
        hash = "sha512-HESugR3kRiscJYecjfbn4WbXTkTx6cvfmbl3m31gtpbEfib1IGuTJoR1wZBwikDq5AMaPQ8ttKjUL7UjYfL/Hg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.4";
        hash = "sha512-qWlxpKfPrEmiCN/wko6dyqUWOnYT+17l/03OfGTMCnXjEc3Fuya1gt2TUgA3xb1T4zEB/36PpfM/0gQWcqK/5w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.4";
        hash = "sha512-AyrCHxVZrf0sN/BX2zveZ59Rc++2ri0ULr5s53/BnpXZByRcVi2SYA6HJpzuvgkPdFk1Wibnwr2SUkG4nq0Vgw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.4";
        hash = "sha512-Tjf1IDWU+KzSQOtuNlK6rspCZB/r4tRYdlbq8CrBD9NVmeX/pgZJimR5vAAb8LPVmYP6PFzLk6TlNbwTqLtjxg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.4";
        hash = "sha512-hFMJ19RX8ANd2tbx8I43VGCLZjiqijd5TrNrZwLhfGL7s+oP9si1zypP58R8QJXv/C5QQi1CZwajPL2onM2D1A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.4";
        hash = "sha512-IkuEOan9M20Ledywqy5yVvdC9VaiEcONRVANYaLCipOFwMm9zZ0agjfH/vMPtWciZEM2LVlIFqkKxZ6T3zvB8w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.4";
        hash = "sha512-wIiquDAgWYZHOntjbtRR5cF4UyrfEhiGg5u0NmLWdq1QuH1ELNo7L7MxvY3RnGToKHzX2qNKeKqrRhAF4IF5Uw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.4";
        hash = "sha512-YK2CKWvhg+xjinZ3GSsLUw5mpbj6Tfjs2QuXPCIMjomPBr/uAyRRlgNS0OZFCpNzgYr/qaEHmnPXH7Q64f8wJg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.4";
        hash = "sha512-UaWTHUD518NWUtwkKNtWdvO8QNs6CCfyXHnRlJvKAC4erqN3UOuJEeWArjhkgE8a/CRfpSIhKwOTdV/tnn+gug==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.4";
        hash = "sha512-4RUi49WQAI4Baw8mQLlsC48fn7XmJJ6Z0IvGmuHdpgy+4oMfMBJ3QwqvRJu0KwsGChRXNwc70RrjVngcZYJIVw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.4";
        hash = "sha512-y9bCkG0PrncIg+j4j0LXkdkYFE3guOcpnqbbmrEruVNrvWnSSDIrtPNI3FgKlcMobevz5lrIoB7QaQYhQTm20w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.4";
        hash = "sha512-ygb6uFrTXttJ966dV63qrYYTuttq/3lZHa8QJjel6PN6aTGtFb+PPvDU4/g/ugOYph7QRIBPfus9UoE6Zc3VHQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.4";
        hash = "sha512-0DFgLJViv36p69rfAdG8vT2OTeuVAUBwXOKujxEjciMJw3A8WhxJY/8f8liqjGOEJGlEdLGlbJn55DUjAK94Gw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.4";
        hash = "sha512-d1da+SUJ1gpDmjiSldu0pEXViPBMk3Ca3Xeu/k9nIAhj9K9a2mQKML0BvAxhvOMSWPFjFzzfTvg09j6fHXM+lQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.4";
        hash = "sha512-/hLWgU+Vco9EmCfZLvnuVpq3E981xv4flqgvefdUWusnwEvWGscqsxgERA71RQuzDJmY/pdMI/wpA9RZh1m1tg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.4";
        hash = "sha512-ejSiC8i0V9Sxy0CQwyB6iNW7BSJp5Wm94TD3QlH85jREQQ3jBACJtggj0HbceSWQTJraZo4/I1M80i4lJjqPlg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.4";
        hash = "sha512-vSwJYo4NMFbSU0v7S1T066+J04v36dh/f4dZdp2wWAAoH4CODuaHGEN4GO/hK+2CDB0SiSkl6Gi4W2GT8Ys03Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.4";
        hash = "sha512-24cIBRjSl8OULJ5YVc7EN35wQnjHHDXYLArn8NqMD05jciGxgGzAhYpv/HIwX/nq3D5fLd/Fd5K6OVWxHvvUIA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.4";
        hash = "sha512-VJyu6oPNHO2x9lhe5d4SiPgLtTnDPuQITMlVryEI7DMCvA611cixvaIGY58mV1EZqk/vZnWWSY+7RVq4zTlVvA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.4";
        hash = "sha512-or3Ze+3tz57tzRstcRkEIYJ9/U3OUQJyml6LuJWXKSx1V5328xRspvcc00ayMWb7fNebHsWpRUe1GPXB+UmHNg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.4";
        hash = "sha512-rKftT4/EuA6Ve5e7+2Vp8/IOs82s0LtnvLtyNA9GB3B9Q39YMLXjVsfZrudXFmETKe6/yTKicXImGe3fEFjWDQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.4";
        hash = "sha512-IMXsCInKmMkBwiGOkVtkRDnBTWADdWbrqlfqaarjxVohdmsJFLTjmBxN3mRWvU6xBpewTYmd5vdXw8T+O1jKJg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.4";
        hash = "sha512-2DaodFMppQaC3JDUaz6jlZh0r7LkckbY6lIQv+v6hFrUyM5sR6taSYpJGpp+8eHUtQc1jZwM73VXPG/Vbqdb5g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.4";
        hash = "sha512-pt3WTD0ftT4y+4I40Awuke4G88KVC43qXed4buWRsMbZDoiYz+yfzJDkgpyhgjAGez0IH4QcKhyk2H8SaOiv1w==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.4";
        hash = "sha512-Ndx07hwie7lCoCK/JT5lgFPl1HuYrbFWa4bSSzVOZsy69OwKpMbRz7AHqnZI7vzaHccPFg4vdTdkZY8EncjN3Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.4";
        hash = "sha512-OSrryyWs30KjYNHtlhr2msXblECpTGWQleB8h+e5XezHGNLPPJvE+ydmUOj+D5raF3JAkBsEN924OggV5lWsCA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.4";
        hash = "sha512-Ekwx+b2IW0yjRToJSk1beUeBWh4wiMzfdRVxprhUu5ruBnPa/jP/DbHMUcZJLLtFKh60kkMlyvJ5rl0pSAJ1Lg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.4";
        hash = "sha512-7az/z2i10Uk6z9i9qsikCoRvA6X3DKaxpC3i9KZe/xdA2BvWP+pDv7JKLdUvAmiIDWR2J0vs6mXsneOxe73a/g==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.4";
        hash = "sha512-QxDbubYGVL3pGjOYWYCmjWAgnbJwEj/dcNeCs4Xh4IvUK8R8g8x75gErQZ22OMxS/zqOAOL6NE/sDo2QHU8jaw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.4";
        hash = "sha512-BGGZsy+OGa8F99UIBsWfCuLGGRYrQWmBw4smUttKeGoN3/EC/m7TfJSGvhxIbtJPXlXn8Xb2x9H3oxT3WWrFYw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.4";
        hash = "sha512-Dm7ROGPP08OnNas5zQFSX7aoFrKafGN3JB5RS/Dnf4+RmevGyQNl4LsBZSeAt0fOVSBLJzx+ncA4rnHPsXzVlw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.4";
        hash = "sha512-f98Sf0kzZphvV8yVVsOX1wBCUe8W2fBc07uPzgubcpV26thTfqeq8X8URKyFvn0cget2LbRwUxkkCQaR5WV+Vg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.4";
        hash = "sha512-grhMIUJoKPEwy5TSSwwWecnqjx7eW1GQC61Y/yp6sxeONEDbL5ZNap6kohoot1pQt4NNKf+UroVliPOGAHTVsQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.4";
        hash = "sha512-FelsHdfHzb4g50fIeP1KHuAfiO2C81c02sJzCPiuKKWbAj3s8e3zecnMtowyjir7Qm/kncDpjd7DH35YiBrTPg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.4";
        hash = "sha512-2y4Hj4DEARgjEBZWlPA1NpPreAurxWNUVTQ3Bm0d4dk4MN3aWgxb/hcLiQRZLMtdeqwOU7K8bl978BokvgFmHA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.4";
        hash = "sha512-MoMJjEK69XZ0z+1x8+WmJcfSILixWlZTEzFIlBm82Mt19KaWo8hCWiDIH/mP1dpXTNsJQ85Kq+vxE/Rj9iEvdw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.4";
        hash = "sha512-ltuezYYS3mO6dsexDw3S+81BN+4YQRkUtxyUOvkNKEowTXhmgWji/R4oGg3z13ZoOgiCgGISbfalBZDUoU1Btw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.4";
        hash = "sha512-aGqnUAharSnmYWmxglbKJD20a4gv4jk6fOhc7iIuqtF3OdiMoScXHECn2UKDUm6cr8obbpgyrjhBXIk2JDq+jA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.4";
        hash = "sha512-IqJ12B7BxW5L6ZLaHO37g+1jN8GwGThJUOJgpJ9A5suK7mRh4R4GxqH4ubXFucVkFGIZEsJoUxO22BI/hjFOYQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.4";
        hash = "sha512-dUPDP4B3AloQ1qbDdkaNEwOp/lbD7I+ZcAOANLAVfEvpZbpT6PJOlAwNsWGOj50Qn8v5s2C3nn85t5qwXRkaYg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.4";
        hash = "sha512-KfaK87LcwhkkyEOj1PF7C+COqTZkInp0b/SQruYU3LvsuY65avecknqxFEQOHu35KuT4HJODq+WrLU3NYQFVXw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.4";
        hash = "sha512-w/7QxkxLeYlTjfGDXDWTSl/JdVpOlqBBrLsdAG/yRBsyq1ApTIKJBNNO8/DxrFfvVznF517dSdkzFnJn0oAnJg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.4";
        hash = "sha512-+Ln1y3l/IsRlIrS8WsTF3TSHN6OzeJn0gokPIsHwZYFp/4P6cSMQWxIRBJQrW/0GBM136Cu2kcm82TT9nI6HCw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.4";
        hash = "sha512-ZL+E6+SUiHXJuRoV+ZdyoxS2Ato6QnMmrfai7LLzKDyc6qK1+5aTUzGqe0RLSRoGn8zfZUrN+z6Ny7HuqGVsBA==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.4";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.4";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.4/aspnetcore-runtime-9.0.4-linux-arm.tar.gz";
        hash = "sha512-azwcWvEvsJkQln1khWA9BMijxHqea7Ecc3Wlrht2F1sBOvtJI8rdmaeiK3gspLi4JAcL9SUsVIEySsAj/nLOpA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.4/aspnetcore-runtime-9.0.4-linux-arm64.tar.gz";
        hash = "sha512-fMpAhDQcLpeObXXgnK4wijXefNhMWyfVJGudGz5qr/IAuujeWiW4FuMMO6NUvvF7hLrgzhUUSJVRhmHlOvGDMQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.4/aspnetcore-runtime-9.0.4-linux-x64.tar.gz";
        hash = "sha512-8+rohjY0oFC5C2crFNRmpExiPKBsZQGjpw7+qT5UCZXi+jSK5e96PyeBEKm6JAQ6ZRFQo3jk5ahMJWkLczZBMg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.4/aspnetcore-runtime-9.0.4-linux-musl-arm.tar.gz";
        hash = "sha512-Ec6guRrlQrxNL8RRJHWVBx7rAfgB0zBfnJzNp8BLSxwyfudaIUUqwbWEpQpjnm1iInL8ernLt0Sou2kbRbrywg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.4/aspnetcore-runtime-9.0.4-linux-musl-arm64.tar.gz";
        hash = "sha512-Z/4Sw0xIWd2MULVxReL++7kp2+KnKaWov7GlNEFon2gpXP9NkxlP87lhEhLxNnTHDhQrLP479qV3EP1CBnIomA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.4/aspnetcore-runtime-9.0.4-linux-musl-x64.tar.gz";
        hash = "sha512-idigXGX4huFwjb+k6pe6r2QCnsoq7puIPJ5RYSkFjFY2wxNVTwW961KAEzmrTjJuvrcI4U3Op1481w3bxfgcrw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.4/aspnetcore-runtime-9.0.4-osx-arm64.tar.gz";
        hash = "sha512-NEYfEiBMYcfyP/0Pibx2mEbeiukCwV40imcrm/J5GDsm8so1028cEqYFKbwpH0IlPhJ+w0ZGIdDP7aoOml2a3w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.4/aspnetcore-runtime-9.0.4-osx-x64.tar.gz";
        hash = "sha512-sH0r72Bb2zb5x937XBg7pJZeb8s7TwDBSPvc1i/t4fHrQFVT0u+E9X4FdVjGQ7hxAoFszvoosusIUA/WtQtJDA==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.4";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.4/dotnet-runtime-9.0.4-linux-arm.tar.gz";
        hash = "sha512-qs3pciRG43yL7eYMw9bcFNgQTKl3LLLXsF8/ePIhavLtZC+X3NTy8RwLdWfzQC1q4IwyYMD7EF9mS0qSoCTvGA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.4/dotnet-runtime-9.0.4-linux-arm64.tar.gz";
        hash = "sha512-kIZZAv0bq8SdKI77Yc14ymP0PPubvZND8ocf8NoCP4ASmzqcJu3JWD+7+KkZMu+608gjrYYi/jibILU/hyVPGw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.4/dotnet-runtime-9.0.4-linux-x64.tar.gz";
        hash = "sha512-+0If3YesK0FDtXRqBJ+ALRFDC3cEIr9gMQ7k6OLmoslD/4hw1N32icbg8Fv1lH/Uud/rVng+eWu09PAZGlq7LA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.4/dotnet-runtime-9.0.4-linux-musl-arm.tar.gz";
        hash = "sha512-FSMVutTbYfbeIORxA+CAT2Tp28Otu4z4dMPpeaDRm0sm9frAfxzSJKiIH0r97bPCRPlwp9ZH6uGqRKwmBMQ1Jg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.4/dotnet-runtime-9.0.4-linux-musl-arm64.tar.gz";
        hash = "sha512-+Ry0IgBcZMksgEsCZwUmSSRGy+NoYzV52/ZwpKbWecdO8BK47nP+pnLM2F8KpExxZO0gh2dyrxUFL6dEfBDiVQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.4/dotnet-runtime-9.0.4-linux-musl-x64.tar.gz";
        hash = "sha512-peWXZD3q4lqZh1m9mw6xm5M/E6NrHX8uRpYGipqeAyS/1DSQ6N7CIhaLjAY7aCf77oAYHkcAu0cSVQrMGAEEjA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.4/dotnet-runtime-9.0.4-osx-arm64.tar.gz";
        hash = "sha512-zkp8lJGmMevBm6x1kj6NlLpdaZ8HMYWAQIuxvb1ny4pCv26HOX8mgDWAMmxHw9BIObx2LsnYQzIBmaFYfqB4vQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.4/dotnet-runtime-9.0.4-osx-x64.tar.gz";
        hash = "sha512-oieQXqhpPU5q8wzURCTChJgEllzi2OWAfN6QDU6Esj/yY3lcos9oN2OChjsLteaqJ+z9VQMNKsUBK1/BGM4PzA==";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.105";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.105/dotnet-sdk-9.0.105-linux-arm.tar.gz";
        hash = "sha512-kErt7rmk7InVpqnlxcBg8gua2aLmewHG8Quvz3WzM+eXgnrlXD4PLz3z8acmXrMb1nioZ0u0Z9ceh8+x4GDDMQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.105/dotnet-sdk-9.0.105-linux-arm64.tar.gz";
        hash = "sha512-bhhKa/f2toAJlvNJdv6DzgiRcQqVQHIhzfU99xhfIdzpiT76/Izx5xBPBaAqxV/iGuw7G20WHXt+CG1ylFgFbw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.105/dotnet-sdk-9.0.105-linux-x64.tar.gz";
        hash = "sha512-95W7NfQytx+UDrYr+kyj311wj0l0Z64Wpn0tGYF6j36M9eb6p5FBLrDaAXvln/k6KtcjZ1s/MVLzm/9k1UX0wA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.105/dotnet-sdk-9.0.105-linux-musl-arm.tar.gz";
        hash = "sha512-bmywuP3HHvOUXBc0vIXTGpYcBJKFanYoAvGlr0NZComPkvcX6N8p8LWF3r5+E6+hHtSCthGCERbAUTokbyOb1A==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.105/dotnet-sdk-9.0.105-linux-musl-arm64.tar.gz";
        hash = "sha512-4itX/8pLWxepeQLoz6gb47yVdel2J2Wy+TyefxVvmoiMdveWHg+JQggAdsysJc/s8XE44BakV1ik/9jF1/IWUQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.105/dotnet-sdk-9.0.105-linux-musl-x64.tar.gz";
        hash = "sha512-cSkXCbwN78Rh8pHZb1fwYmVAx3I9gtMA0UAdej/NFQts547UtLKZaxxGiN6y913bD9Kw7yIas9Vrws+OhSx95w==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.105/dotnet-sdk-9.0.105-osx-arm64.tar.gz";
        hash = "sha512-dfvcxi0TWW0XgekKRKqDFH9w0V9wsXPliKASOT7k2ymdU0LxMXbZUxTPJMQb2tsy0XsnEDKDw/QSr7h3iYDxqg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.105/dotnet-sdk-9.0.105-osx-x64.tar.gz";
        hash = "sha512-DwzNjDWdN9AmzojA4SHLaen46b5h1+KAMtUivwRuVRfsDzHqKDDQQFY27lhtstq1SuabNtUxH5m8stySnc5Iuw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk = sdk_9_0;

  sdk_9_0 = sdk_9_0_1xx;
}
