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
<<<<<<< HEAD
      version = "10.0.0";
      hash = "sha512-HcTzMfT74z2wx5virCUA8AgviXAfP9LO3ToUmCIg9AMGK4ohrUwhfQWHK4EE2egpEk1jKvDe1ZPPlX9csgCMlw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.0";
      hash = "sha512-CDUeukQ6yClE0KQvgsUJyegl7w2ORz3c3L9kBlqhOiNwhg8liiwA12HDGqYwrQQPY/oFSzLp4XpjwDZ4mVAWMg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.0";
      hash = "sha512-DM2V40+lgsHLg7cUd7TWxRhdSwb5HgpHzImq4npVg3hAyh6xwKAZ9j/y+3nWG0qSLHc3t5FVLeR4bJO0PN3tsA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.0";
      hash = "sha512-XXkdkHkgVPvAmXDeP3HIpDlNTswlsK9fuIkPHVDYcmxRuFnEEc/1yEg+MikjA7+fw6TSy1AqkNdcyrjJjag48w==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.0";
      hash = "sha512-nmdgBAyTi4gyuP18U9I7JhVSC31+mZyyQQzmldKxkaVQCB5mcPjgvnfkJCQjN84VRFE++hXW0xBqPSbUuny0QQ==";
=======
      version = "10.0.0-rc.2.25502.107";
      hash = "sha512-hz7scU+GeR8opmEoYFby2mIzR6Q/4/XqKrb4XsusXHFrIFNnGiyuO6pYVEAy/AmUZ97YCy6m41ybzAuKLL7m3w==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.0-rc.2.25502.107";
      hash = "sha512-9qeh8T+LChz+UZYhAJcf/POP7WeLhRtyb4Z0+bmRnv0Xm5HPPmLqEy6zADiVU9aZyjPu9Ft0NtvLdcfzXT50+A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.0-rc.2.25502.107";
      hash = "sha512-a9Ul0tE8XV7ipMMHlbkhQPi6qpqiaYiGNZ9wTHJlQhDoD0AsKycbiYjWnsITXsuccOjAXGIPjnX4mwTNcD/VSA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.0-rc.2.25502.107";
      hash = "sha512-lXNTcDjyw9E47AZE0w0AoCRIls+nBtOWb5t/QTbrNX+OgawCGKJn5oHTjyOrZ38wR6YdWQbr8wi1/B/pwR7gow==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.0-rc.2.25502.107";
      hash = "sha512-KgEeHi54wovjvzjW6Ma4chuj20ux1s3dbuo2pvCAKjisOyc6hHS0Xr/LvAcnCKjafa0Q+HZ2IRZ+HS+O9VWA+g==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-jlcG3SsEkcWQn7xUWuEU3uscK6rLQSCPNWO43k+enQHf/7mmsvAAu3DRHl2STsZclB/KrhQm0qgK/FiEhD9j3g==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-pYS9JBkV7rUMaHEESpR2rahJ2ZvaJNsdt4oa8f1WuPFG45XJ/2u12IdV1vsuaU+9f9rYMVfhj0iux+2F8LYqFQ==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-UkVobkMgbeFCpcgTV0TvMUTzWlI5G4Ha1OlS26HKDzdY+AEhJ7UcymZ7SR16W3mw6mRunKiQtXuwtN+fZ/jE1w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0";
        hash = "sha512-fKoXVn60Ct8JOazjDuwpzGZSGqVHBXboJeyCWJQj6w2B2x0p3mOJkR0/kOifxT+E2NMX2Zx12VELKK9hAAOt2w==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-O6kG5AngtMsrdyVCNqlpBUDcmeq3od7Ucg2xN43pyZOcwmLO7AHl49SKqniW5JyoZP4ZqWt4KwYM5mmw0XV3LA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-hYNGcBFVkmmJRVAryuSKJges5+CKfI459ksjbIkPAhUHGwfOQIpKcX+TppfE3jJmCSl+eQL+2lbZl1jiGHXtlw==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-+jM9DkV8UdrLkm6PyfbUpRJLOC1pVfDHlKD9gXU/1fDkFpy7q8RSnQ5GCbxL5o5U7q6lfh4rQ5FsCD0fJC+zYw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0";
        hash = "sha512-RfDDFGwkXvXes6pzq+Fl8RNweoSOwrQsjL++Zp1+DLY9uwAoKeDYjTai2Rin29MjmD5t854ZivDKP3X5HXYRRg==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-hIWTBNODFZiqZLtHrs9hMTkXIDIcacrcF9B05YvzeJp9+0dFJiZYH1knXpDoTos3O5KwDObfb2nq5YirPBAPXw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-GR4jPLadQCCaS+1DD2v+/MQrSC+hFk0G1yEw2BbhcgQtYgxM2GtEPNEUPoIIss3YmeCM2vjXZBgLZtS6yUkZdw==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-ZBdYFk/Myia1U4r2tFfidqRUCfMrW9mC+D9xHoDCDELpmysFcIdNfPIAdXa3jXwv+EfNbh1D2+l/pSASHSx0Jw==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-YnnezTFKvLbmSjJSKxNU+JZDiz++ku2ZSNeTP0KYxuMKKXx0C86dR4xvbSqmB4aHd8SZk5Ka4UH6PUTDrEVT3g==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-THBCdaGd2SWs4ECp5ZGPi1vB1SiIiTEsCYSAegJayw2Ic9Ky0RdaWSA+Q0yfI2sfnSsd97Vk2dhHuzvFBgPFbQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0";
        hash = "sha512-YjvVt1y61529YYJzPuFbeFxBgekq8sDg01yudN6zKcDmacQhUtfx16xijd/9bcixH4HWCjB7tjEHLuDptm5m+Q==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-F+jX7XP8Fs4E3Tt/HekmuL864IUgH5aN72Gt8uEEtThjn7kl26c/gu05R7pk+57GOinv5Ob/bkTTXOcCb3S+gA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-Ki53xQRuNgmsZ1sUaV41PMVABQKepRFEKsfUYBvyZy0e9hGDCV50wEcbCRhJj07WahcP7aMf7hK0s+yCtbp8Ow==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-fE0I9SJDBxOX+OTzbA1rg4omn21xp08dzm7+zHX/U1wZxy1TO/bRhcLlEMs5f+nNXN6/8f0b4eqsglqtZz45uQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0";
        hash = "sha512-Gubgq6b9GOrD/q+eXHW14RrxcYeWsQ2bl9jL8HZaR6kXYVWd1CAF1TjKbqFLLuG01pqvDIdu8R6pMxGgsWWKFA==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-V9tGJ2/s5CYJeu2kCJAImHrJ6/a7k+1GgFgAjbUXcPghEhQyqBaVkekeDQbEiNBQCqv2eWJ5gRAxZn57LHEGHQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-IYdAy1GSZcd5i9c8PPotMhdCnExU1AwLHn12WQ0UmGg3bjTvtgVuFen7dkFTISqJn5T/3AU+89QG/d0oJTlIaQ==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-lno9hyxtY9nPVBi/VUZeLS7ARDEMBJDI2gTp6VlnbPIJuYTyUYOD/tyo6bwHG62Ie0Tifm5gzR856jgiMvV6Pg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0";
        hash = "sha512-C2VAFhG7JYz5QEkZGkiPgoJTiERvR/bwVWfEdTyijHcUqeryjm0u89qx5Iz5AOR6U5wQNej+2Pp5BdlEd/MKPw==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-iXSGPUT4HxCO0wxmNM2dE2phDcC4W5BSJkjn2RnA/FC/tAVZD6O1T6SuMtgeA8m9vVVrSy7sA708J+j6zzyOfg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-NOy0zl+gyoS8h1qUmNYxm/KSRWCd2sLAATH5KhFatV9GwGc/JHhJfWuN8oXaIWuHkXklWpsCgIE+BuEYpKUkhw==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-A8Zm2HoUc2fV03HqemG6BProBJYIa87mzjbBvKIDXMshispBmeVfbsEQGoJEst8KKi2vLttDX42qJdEB419eTQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0";
        hash = "sha512-gbyYz6R9QJJZ5j6XtkG5asyKRcW6IvnXLwklvAvk4bkU0+kP7USIn+EtXyDqFKuiohPRzD+sHi04LmDqc+FRiA==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-XlncsgNGIi18zQe0A3ANBDa+KG1tB/s2Dmn0jfLsPMjbyYTJuUpmVZvNgOequimdiM+pBWX4tvVqRfsV5hImww==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-Xl4KiHx8RuL/DSAAcxMUh1fNtaRYIKwzqoUxN6qrjsE9A5mlWlsWQ3CXP/DFkP1ooWoQEH/Cyk71IHQCHCKZ7A==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-/h0qoO2NaKn3nyYXFiXJwUFvcrAJgZVmkK9dam1UFaDHwkPSufBsTx+wsO6YFtCgtfsDM0K2yNlsiIi2LflNIA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0";
        hash = "sha512-PtkF0VBMXdPyavJUUaCp6OBEhc1SeCz7oaYTn8y+TqczP75cqDXIUk7X6DL20UorQ0VmXBAXLVHv9ey6LP8Mbg==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-cTSKXdydpMJx2AC8n0wvrHSx0aoHI0QSxo81D9w7O8wrxrpv9B7gPKU2j8/gpe5n6gSmdjuYFTT9GTbt40wpTA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-gWcOAXM1iT4NkVnftI3njn5aqLRgn4DXnpbW5BtRBcsqkHHlamc+sSdWXltVweKIsz/jZbCrEiMjl8sYOS3qmQ==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-uJ/dGjqaFz9YEEe5trIQk7dktkVgs1KWHsd42zdoPX+POC5JIp/aS8JFNECQK9tQQEZfgNeUT0lqfPJyGpP5aA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0";
        hash = "sha512-XHtJ+LmFsV0RRD1H8zpRp3+yzOstV/TaRwAg38b+8PvgXn+VEIVVHzlqWu/eB8AMPoVbC7b+OnOTTlBPf3R7+g==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-+itZL0t/HjXzRhKVFIvysPjiLRov9TY8U9SsuRE6JH47x2T7JR6u01z3zhYf6CF1N+omN4NqnxnUBTw+E9ubsQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-xxLmFZWpqUqIF5eSGlcJLFPTMclNWvPASqPdvLaiu8HtjtopoFC5u5Y2B9529XXJS3TZmaPQXkeiOscz6ux1fA==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-GGEi3CB8BqkuKKGxaz+UURu8mBOkdiE9rd4CqQGL/cvHVFCRxNMXeSESLChfhy1S6Sdh3lnwGS+h2WgJpynTgg==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-uMUck4T50qnHf97xwLxsy6MR93BN6g8BvXFXfILFwPeN/8GhmXBJMOqRf1c7Lobt7+jHlQ3DYj0/z1jVwjnJlw==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-EbPfMeafoSi4K2jmhzbiZx1WhwKdugSfXqAk/6WnsmWIVCJw197V4qTIBkBEJLLpGbQaziP9SsAxk79MOSPwyQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.0";
        hash = "sha512-hH/j5x8f1hqMCqETcCvG6tQ57WCJkXI3sZlEOrw6RZpFeOpMpGIEwM4B0KutZxr5jZchfIcTL+ldJBgd3gOGDw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.0";
        hash = "sha512-pqX0SUxgLA+StfLlXg7P6y7WkeYkjnaR0aTEu9B3NysInOlOq8LnjQMu2OhMIGSVjzPSU4oMr+YRiZUdtS7tfQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0";
        hash = "sha512-PtWoGQJ5cxT03OEw98ZKhKQZTAko/aERH3C4LfWTajVfAJPpqR0Qv+55DWOnRO/r7qU/dleWzBP82A1FYeheLQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.0";
        hash = "sha512-wkVQ8tk4CAF8fXfmieaDDSGiCRFuq+C1C1wtTPR8H3ZRZfCPdgj1Yhf/4npckbF51wsyraPPT/OBqTxyhqQZdw==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-mbrXpbknOjIMa8YNqzHO1HRP0V3lgHPGzFNYh+/VMmer1IqVt4FmlR4BjMeU+jfSW31gtfvaDFqu6YfKhobstg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-bjlIIxeoCrqrnEjsk0wbzGTSv+BhdUR5SnFC33Ar5/CwMH33p/X+WWAe3Ac6hQLVdxeIuRrbxgceDsf3Hn2zIQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-j2y4ZAy0wnEAoOsteO4CpOao9Hz0zcvyeqENoGG4HMrYivzYQmXDkM8gGuKO2c2+77sSNYa/TjUiU3oE6bCmxQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-G9AQlTjJJlOoqC+IZzaSzg6k0GAdXXeywa7rcMRHxtSuLeWoVakM5gBYwvJnWfSJ1kqJlIo67neV2vvBqwjpWQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-cIucCZIOGtVkjsvyQYuhPBBonOHwD2oGGSJNkizjXXHJ1Gp1/sIrAXPEg62k3uyKWPsiFqBSgsn1Wes0Wd0mSw==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-uBPQl1tUd5cQKN9UdCUnJ0VG/iY8bI8WeTMprmqC+mBA0hgylsZjLUJfBc4I9EPMxNFOBQJwRjQ/uzt1s5FQSA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.0";
        hash = "sha512-JlSAx7QpIcdz3iOT1NCBybZ0+R4MxV2vkRtyfsGBzIzVYqEDjrroo4A7BfxN4H4xplf4w7l/AeQRsaeTR2M2yg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.0";
        hash = "sha512-yo//xWJuO0JpmZO0RaT5QIa6nvqB1MM0MieAtXuDXM4SZd4YJ8Dybz185Yo1NUexobapeIrKNLX002ceh7KBEw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0";
        hash = "sha512-/JnFo/nqmlFagNW7zCWaXXfq1L6uuoA27KDRrvVsDEduS++fUdimCWPWFeO/vFIzCSnYv+ImyjZVu831zHn1YQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.0";
        hash = "sha512-Q2eKWNI659wTKYT/WntFSeA6DtTQLoFFOtn4EfVEug5oDxnJKwXfylptcw2cXF1UHmbnr3fjn41fmHF+lJ32Rw==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-2VertB1ttEHJARtDySmH8Knon1/C1ZKho060g0Dqj0I2opdm6bPglHm7fwmVZLZNzWPUzk6j4OEs+0kdHEDSsw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-tQ6OaYTMlWXON+cBPGC1IVnveaF7Ctwc0SdoQzKN16icMNdYTD8ZHMlkcMYWV1GrPHXH/Dew63IeP6bpt6nYXw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-rjTcmCMvPOqxLpNWP5lot7tnK8Gk3LkWCkC1xhUJj0WWnCIkbrpa8hlusirRIiR2olKJAo/z2vzdcrSqkQe61w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-hRN3Uh0q9iu23qVFrPeOch3DdgkFDYRoGd+ApvmRv7p5w+lX9Fkxfu2m0BMV2o0QgbWDIlLZOKZq+AU64/3Dvw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-zemzdje8OMIrKzAePlCytq2akcdHs5YevVqedUSLp45z8SC6+058i/vI5/WeM28hQumAjFdWQz0jtEUC62u3xA==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-X8NccILKj/aEVjz1Gt50zGlRplIHbI+H6uRv2yFY9KioM+sKMgdbNTAsRp9QG4aw5RGA9IhZYxcHCQb8ATc+XQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.0";
        hash = "sha512-cw4mF+MgWPuVHWX4obxmRa7Zkp7ULDS6R3MlB21d6+x5WuDrEbunt/vCPou5LML3RBEFpKYqFhjxL1M9D3QJMA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.0";
        hash = "sha512-WJMtkEZM2JbiS7VZc/R2+3qUVxiCR+G3JepQwczM0qWBrsRpeVoXGJu/ZpDbUwr7AqzwJm6iD+aCbYpxK8Jlng==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0";
        hash = "sha512-TBpxxlFyfNVcshnh9euvsLRW7/n1/Sti7CtDIBbOcyhP/STj9OOo/AWv5ZSqe/3KNhlM+G5+ncOP0G0hN39nxw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.0";
        hash = "sha512-DJwKMfGknpBwSQ/FiKbN3W4n0XIF/XFtwH6hxoD/2fRjqc6GZbOnoB/qfK5VOpgnIIMpZuCb599ftPtiO8aLog==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-i6xet9EgM3zw4UcH6OzlIc4FaqODYS1hBf1LBvdKmIbFGp79pkCVT/s60eV1fu1eTQk4/cH4u6CCNdA/+jTDAw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-2s/iuHKVirb0v2UV9v0D2AzmJS35VM3x7nB98Aur2MTq9gK1Y9CfklQErsZApPclBdzThIXUKdFYVHOZY8as9g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-5lbYjjFzasjYa2NgNTFR5OExu6xDOjBteaUUv1efVC1acJYa6F7Sv8y9Duzq/GHB2SCnFr5e2RG4duzVKUkqkw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-Rxo9qZOaGprb6qXsLWzM09CHk5YiG5LwuuRLTA5r+ZymZnyDpo7VsmT2p97Hr9abmFe04inezbeItoqfTat7kA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-gfO0It9AMdlFTffP5g+ZJrbyI8Ul6aS8MKwb+xNrVg/0WculnWhsFL+r6hIeSo+0XvScIK/rj6ukg9bF91yGXQ==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-ZVmFe111GC5/EVm3SO/dbTUyhl511rjO1dpD0QNu1o4og+IRI9VH+5ZsgJFbhJZXiynKYzoVLWdOJt3fiSIrcg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.0";
        hash = "sha512-2FAwGl8huDfIp072/pQIQ08VqGGY1oGMSb57tbjG18fXLLPIzssWrfZVqOLFaBzgtDm8CbOaQ6HLmuctySxdFw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.0";
        hash = "sha512-lCkhhpyENYogBOXUBJWiO2DHsB/+vPHNDGSqhTttbk+2tET+IuVCafKphJDBrFoSj+3RUPz2oQpMaC4oJM6RdA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0";
        hash = "sha512-zS1TuIG3Lm+DLV7Qc8tQ4gkDYPGzkzjXTGyWhgYdgjKPR+D0qAGMCGbB7OxXgB64Gkakt/cZKG+5+AUA9HVVbA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.0";
        hash = "sha512-JlsRhCKRKA6rMqlsz5D4TT/VeY+wQCzCFTQS+cIP7934vSVfWekG1FFokXRnPNvZ9wGDCquqHscQr5URgK6aVA==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-2y1TmuKQeUeHIl35WTb8liWu8m2LD+HQq1HSSvmB6Mp/BCJjleO2TCnWPuuAh3P0FVKn0uK60CdgUJ9MOJqrDQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-MoImFJInSf4NYK3dpOIRgV0GYHLm69d1jXvNodphn6iV+PdsXX1KuGKtKhG4AVeO8Yw3Fl7pgxHnxsR9c5eqmg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-7wr08dBr7MK/SXrWzt83fwdT7xyH14SJXwsa5/Mwse2k91zu43QJu1S+t7ahgwn95pVsx35pzZpkGD78ZXO9OQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-l8xBHbdF+yDgIiljNCMJGSqhFITeB2OiUdkaxkeSVRcMEAKpz6aBOtMgvbD7VswH3zKX6nA+kdpjWyXXtdIP1w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-zXMQ4rzOYjdBPKLSi2YagXPMylYbusxZR6s/6NuGfgCnUNiaJqSmHv7SUsusDoRaR4kaurHVoHKn7P1/ZwNDXQ==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-jwynqne1410/fXvhegoJxfjq9JcPxvYqpS9OePp8yVsjnCd2x9IHaik/iAHQmqFbIKgVCpAPH9/i8hfMGumnow==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.0";
        hash = "sha512-buX4rr2ZZUjUfvoF3wlCSLUHEKpaFsSkx6+vAbG4uVNJANnUZM/1pc2nl9jg8THFIvIPfCQI3siK54nWsFnBkw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0";
        hash = "sha512-FmU8A9e/gY+LGGqVgr6fbk3swgzO5xTMVCUpcbYid/CUw80T+KbYWFeaSIn3zuTGIdjP9zOvJsUYiuBdgN4GbQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0";
        hash = "sha512-eocUfeHF8PwhbrOfzSYXuKVMwCZ2T3VFoW2mRX77buB8G24sfQ+LXtppBN2+EQbkd9mT5QZNR5gqV6rqfVFeAQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.0";
        hash = "sha512-WwVSD1gSgf73RE6tHGuoD5kDMqmYd5mIu6B3Ay2jO8MgejtfRO1qNoa6EHcq0ouVS3EIDRO/oi4lWtgzHqLHdg==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-+OILb/rE2p6IlAE+2kd2fi+aowKz11Ydn/2e5HUmCOkGl2JPs/fx1WNGaFtFLzPGeL3NnRn9FDfii/wC7SWAoQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-Vl5f7lYlYbLd42Ivc+rcSpqXsTkdSVB2PIjl60zISBZ3pkC5zo9K2WEb5SreT9HJzS0Gccn4MWa8CtBINJg62Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-IBScSHBaist1VDe55jf0DI9FXnCs5sLz+gzznK5Da4AP4IJm3ouqp3JPkuwxVIManPfXKpTcFGb61G6n/zl3/g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-Ng5H5Hepl6+6I/qLFGCYnHwlr9t4UAk7zjksAmK2PIVO2dz60AHY8jijDHPtZ/VF/C5YtUi7qOos6KUu3rHyiQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-9kfX46cD/zco4hUhEYEesn2zhqq6cTqKGYcNLiwQVUp5XJl5wwcsIGqQ2lA55YC+ZcecFCicWeJu5bgTNn1k+Q==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-4m7+jTuPtHvA5EGAWArBHUvRyNyLT59DRSMZbnKmA+Okz+B+WyiJDf81NefDfbCxuVRdsaoaM0NYj1BHQ1Z2HQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.0";
        hash = "sha512-KlfgMF/55W4r33hu1KykghyeqLV0uSrBId4ax/Rrxpj8yelJ9E4iviSiLARrbNK0uDtcZk70hTKsQyrjpCMWcw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.0";
        hash = "sha512-eTF3DTUCRfvUseH012DsX2B78VEn9Yq1q2t3X0RVYzP0ueuvkjJzSBelHc0VDtYEoyNMIkK7pwAb+d9FSAtgHg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0";
        hash = "sha512-MW5+A2iatX6vjD2XjW7RlOJLBbOtZxFTYb4mlPHnG+N6NE6cvarXyAgR1+dQhWSc2W/kL7SFNnSF5GrtfV9pTw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.0";
        hash = "sha512-4ar4h4IHFuZXo4uDArhDRWG10/M4rNLLkilexfEDVHiDxsWKdQKn3brLAU5QDbk6zAr2u7xwWyQ8toZLA3jQ9w==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-mpE/aLq3eo9B6MX+EGWEt/bSFfB1ZImIIj0i1fMsHjaVRwLTB5E5xDbQzjJWVEHr74F2FJISz2dJ0qC/wNbjtA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-TknoBknlA9KSB3GbabdjxGHX8xNCtuKM+hA/dhwUSyUN/0aDwLuuF5/pOb3q33AxPAMcaubKHcqpjPSiyuFKZA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-fPUXXXvAGqmwme+EnEhx0koHPx/nIgZLDjw9wLOQTOOt8HdQboKebk77z31/mM5lDgmruUEwfOEP35ZnzpEdKA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-ZMmkniq9nGb6HmzdHgrYqUh4KAWqPS3LQZXe0c/TL1U2AYaM+go+05kkWYSD85phnmERUHDmgMEDo1zipqOFVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-UHHIErnjcdbTe4ZSGoJtDZ6PrErZCLpwRBDtE6/wARb5jBl39jXzS8Ol+MCpZ9sXjyPvuv8sTt7LVmHkdriRgA==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-tn0bDgKsgZOCHkkpIRfO1yzM080LcPxMUhtaHEXcOpWNtZqmqRmyC7zfiaQPmzdKDgJU+urZOJWq+HvL9CCJjg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.0";
        hash = "sha512-YmmSCR5t2MB0IJ558DLHg4pA9mhm0GVbO/eWBo0Gp32qwG32e7BiMHaPz6LxMkVNjS6kIxO0YpvRtnEpMnHBHw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.0";
        hash = "sha512-axo6Yu6u/tHfPe/Gtv4eo3/L9ROYcmAaxWm8w6Y3ak3JhgkuHZYexCyXKdnrKiMXb7LDS2x1967gm6gmkg45/A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0";
        hash = "sha512-pydxAJPjEDsEBXqW05fYoabondN7ReHzAiCERQhsrOCEHGTg6F2VrHOGMEkLFdi3/8NJnzSmCqdLMjvoxhk34A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.0";
        hash = "sha512-MNtC4Vnbgwmb8KFfsdp+Xu4yQghA/cOjXYRBx0Imk+2xPgBkWExCFwbtyX3g/t4dYf8VR/uXGJc6/FFTMhcgvQ==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-K0a2aLkcdAzrnHZa0OXcKu8i6Vpw4BYLqF0jK56228M6pT6W1wiDQbolSo0a2tU2omjQTAS/Zpxt+BeH8W+6Jw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-l6ue5zHQwXVQeFTO+knYTZdfdaMMaK4k3wHidQUQ3foIA6y6RSdBx7/UvkVfQMNJijyGgOK/oliNa79BItBV/A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-G0rQT5lSuWK0gQXzEdwHU/Xs1Aa1xF8VNsvSpb0o/CUYqI6oO02HVHA04+cYCh/l9lBMrqb6uPSfUqDzhu2I8w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-CaTNddVLNUsBB32zjgkGUl7V9nlaIzp03PF7FhM4bIprWoZZ8RqYJB7Nte52W1XTiGqc1ss/0CvRFCaGnTK8sg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-mWxo7u0R0Hl7D9E/SNp9Uw1AiojSojv1j0aaDp3OEIHKoGi3iuzYu8Nsts/9D08Ec4vk87TY0jrreKxyHlvJKA==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-xasWHsXTFRyUCMa6t22nfqwNeEh5hwLvLcXNXDAt0EGbYrV2YlehkaHRwsAJLqyA7XwTrUmyqMk0wUCCGlUJmw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.0";
        hash = "sha512-OYxudIkO3yIJqwn0y2h85UI4WgNyB9kLx9CAvTDweN5o91iUs1Dq9ZNPCBKfQsp7xKKN/5uGgJyn+PPMGFq/lg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.0";
        hash = "sha512-z+Bsoq0132LKbcpA8dHIOwu5OHerJHShJGHd/UdIXfJZaohwFSId73kZhRdGPl2m05R+u78EjUzsQXhyqkUjEg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0";
        hash = "sha512-xWNVQRYqGLRo5g4T7CVy4U9n1bzYVxdOzQhMIUlRAK/y3Yj7Cs6OIb0frSw3utwME5ewU3LAkWtzMAPEGuPzJA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.0";
        hash = "sha512-JCrbiueBGasaUfvwTiKKj/4pzWzdp30vIzOYcUmbfCX8jtR40Ey8aHtt3P+LFKKeZJAOpOOv22gk0B48P7Ah7A==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-bWUtvQ9r4yN9q+yT9EQUWUyo/KnStkvCEo1sfmVZily0aAjcH4ZT1B8qg1KG5IjOdHE9l9orqD/tY0QA7a1/Vw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-he8tZSRxjBEYYFD5BCmjkb8AGIiE+34TPMX9d6BmSHTR9Z8hSjWR2FBSxLo+1+ePBvnWJj4+Mgt+bg07tGU9pQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-+WUulk3XUCVctkBZg2sU5DTN+94xDu0KZoZjotxu7y8o0QDDzbc0l89QobAXv+HkH/5VPL+03hbTW43V7zyVgQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-bjIe19Dvrr1zm9YjOfu1XUxgZCFuEDs42oRfo7Wp6gUQWO3VMSz7MyG9hNWCsa/ZTZDUi6AJjpwIRyCXqEH0QQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-k6/cqrVhhdxR9+xWomz3kbmBR5gbzrpfckUEofY+Ohj59MNdmVXmPCECz9myA+XAkFAY0vQ1MViqaf+TuEEuoQ==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-GdcFzW7htuHsledWiqNj8MYUCUpnbOtcze0jVDnfFzYny8jmTAKk4SH9UB+r/TTFqGI45dzrSb6Jqx8Hj+W0ww==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.0";
        hash = "sha512-8BzG1X4h7fsvb0G+1fzeV56jgbI6OG8rf5iNqGFytCPbipYyQGVd+kJ26MwmhrW71wfdcSMw9W6vQVnHXGXwPQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.0";
        hash = "sha512-I1LC2hpV2Z+At2MMFdzMd91L96UFMOH10++IQqZqDASBsIYdgPHPSigamndBSzZzHmT+xyXLls3D/7ZD0rsTlQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0";
        hash = "sha512-tGH9kq8v79nKjYDmNMgMcmpfS75eQXBakfIc8cgz2kh0+u+QO9r6YWhkXOPlRB48B/vVLxj9hY8c3kUY6iwBcg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.0";
        hash = "sha512-pBU/rw1TcVxKoLctkrHcWpGHVi61ZMJwaFXTWRO5Wayp3EVu6buWTXew8PmgFnVwqw9GvCBiqTvCeabTh2kVgA==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-ldyfSWeDI4RkCY6Mcj/N1KcPAMZKlAcEryoXnmTj7oh587JM/usoVNDe+a9EwQMA69mPga5d9XMkRk6zCsGNDA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-CYQAD3jv1uXiNLxd5aNVONW5Jsg3pILM1d4hSnPNTT58cUpJBM85ad8CiJJQOWnCOIuynthIRZEazf1zs10AAA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-K4eYnEoap+fFlDmPVpHQ35vKj8JAuAzBst8EQkAxRpnMYkdH6PXpUB6VMLfs/RT25fiESgEoFJjmVcJ8LpngOg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-/ffNVsL1eWoQB8I2O2Ehiz/e6B3KwesNAvima4B1gHgrZxjwH8HOdUCx1jl+OAt9A8IJckseCWlvATy0MRBugA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-JM3SUjoC0qYmZjhqPE/9PuitA9uYHMZIGgGYL42DEvpb3HnPz2j795bITCW0O9Yi+OWCsaWEK9B4l2pmMY1W8A==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-sFadl/LMITcaxnci2Vrvjezfhd8bOh/2Nseu7oU3uVKxfVAS05V9iV1m2QEDslcd1Zg2DS+HlhEWgxnud8l5Kw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.0";
        hash = "sha512-stRyFS09mf1ozhRbS9bLTP9/8gmnWw0haRBzfqrkdqdghbu2uArih2SPuJEN5d3gTEsszbHToGk7sCjKw0zRhA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.0";
        hash = "sha512-UcUlPpehQPt77/Zs/JwyENXtjnOU7YdwM7Kcft12Iai5pofK4DMC4kQLBjKQiCG8Q4RElUnEW+DQHmEGR0fz/Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0";
        hash = "sha512-KodAts7298I91d/RCZh7i7SbS097npbbunNKOga01IxPtOh48n5Nr8fdEuZX6X7wT4FuUTX1O3glVmCf5uWX/g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.0";
        hash = "sha512-W0TkFiCX18X42x/7yLigJz4dFJypJshxdjAkSdOBC7UIN10EIqecXuid8/xXF/GHfn5T01o5W7OXlDm5RTXodA==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-zlguqkKffJpKnIVBe0ofS87mkD951sUxRlCzr7isu1IjvKDHriwsIx7wxLhsjZELXDuI1HlkV/7Xhi4cludhyQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-MagJHz4q0OewlKxt6KAl2Qtzq2IegXeMWtk3bAIE8WFoDtLl1LwkOF3xnfEp+F4gIkv46jrbVNPMYqbQ7/yq+Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-vDvBho8UNgWnLDKjOeKjAG+2a7kGJNO2XSF4vqOFTetEduXE/U9bFA0mCV+oDborDg6toHaFqctmW2WhbSQ/cA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-z+WtgZVatzoNkznwoffuv8tKjy8Nz7WA9fIYnxYne6EQ+ptOR8RppYJgIAixPB3tQ0+BpO2l+YtpI6kbDSXXbg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-9VW7n8wkmweyp/87tyRSL0Abmc7FIZrbLIyrH6LiOgALNPkaFIfSJgxmDqur3MUTsQAAx50iM/YA0+lNALIq6w==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
<<<<<<< HEAD
        version = "10.0.0";
        hash = "sha512-FgeLN8BzZ+gCGB+ozt5uxVzwFyknYNCXEJfwTEEgJa/oUBaIgtpq1rsah/wp9CQmJTZPp+lS9lPR7DvSuhcL7A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.0";
        hash = "sha512-/Q0UxPmdQvB4/GqMlQl61tUvhczN1ZdS71U7bErK3V/LRX/AFWhN+pT5TS60EC8jn2JKBis9XzFJjElg3DilPA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.0";
        hash = "sha512-d+l9pyTsQ68aO4tg3bL9v65tmjdMYRbqBdcjf5xrVQolac/EuR6ur9Ht5d0YVcOjoPaiBZMwwJq0e4h6rBhUsg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0";
        hash = "sha512-vwi715pWIe1EMVJW85Cp6YLWDDcuSu5XVqNsTu7J6+NpuYkdGxqocI+780SJ3grRRwJ2DARXTCzKQyF2J1ZRDQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.0";
        hash = "sha512-IC5RonQHDTRAjs4hShcljsrZuaIHypR3gb0iF5AT6OWv9ZbspPKs8yEtWTWpkZOp5SDdIujOsYG2872NjLjnGw==";
=======
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-kjRe/NXF4CPbYAtPfng7zVkwIvvRSqzzylUMiZvxrotuXHUpDD5K8qXM4F6+XUQrzxLlZRZUg+OKuxswpFYU1w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-nYinKgx3/v4XcxNUmS3xyzF7LZbunqGCa0311lMC4KAVuP4fXqcUpBeV1HenBMVKnmsKMNa6blHVRebTNDqT2Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-qQnhXCUI8A5yD3w7ElDubv6GNI+FDutjWvWqB4fxXnGAcPmu+SNEWfmSgYVRq4LnL5Nnj5ZSsBePOeXirv9HXg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-wmvYzbEsKYDFAeWBsfJebIAuLtolrkDDToxqO8BW7KEt9zoeqVKeR91uAWcW5kyd6GSc4WpTyU7oXCW8jMx9bA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.0-rc.2.25502.107";
        hash = "sha512-2j+ONnDhOIcS75JLL4OGZj4NJnha5si4D8ylnHWsJi5nZ5jGfHnuABpUMOn2T5yaw6vUPyQc6+e1qYWUW7NuQQ==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      })
    ];
  };

in
rec {
<<<<<<< HEAD
  release_10_0 = "10.0.0";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.0";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0/aspnetcore-runtime-10.0.0-linux-arm.tar.gz";
        hash = "sha512-UIO5wgVxY5zJNZDoY8Ac9rN5/EyxKdHrdJh4jnGUsNohs4oYTkmt9R3sgBPEVxr6pnEeNPs85jmc7U1yzpcsIw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0/aspnetcore-runtime-10.0.0-linux-arm64.tar.gz";
        hash = "sha512-DtAi96eivwZgstTNy5SlREubns6H8ipgogKRN2MP2ROFxhoZsTAegb7zY7W4kJJNU6fIJOWL1O3TJ3I6pyxvtQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0/aspnetcore-runtime-10.0.0-linux-x64.tar.gz";
        hash = "sha512-czFM9IFfVR7m+YAnODZWjGYCD95+h7f+J/giS7bs5ednvyqA5CvFqtOD3LOMgj9LKyXQ//y7D71z+oLyDmbozw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0/aspnetcore-runtime-10.0.0-linux-musl-arm.tar.gz";
        hash = "sha512-fBYkDoRVRPx5OHfjmYcWujkACEbUUJNwZfw/Rn35pv9Ugs6/4odXtx4eUZq/kkWepIFvVUlXf6mk4ljKPKfkAQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0/aspnetcore-runtime-10.0.0-linux-musl-arm64.tar.gz";
        hash = "sha512-oKAL1Ru7E9QO3ecHbffwTlhtkurZedieiIF32NgW5nVqyA2UkddOikztceQlx1MOntjZROwN+xi/JczCHSrFAg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0/aspnetcore-runtime-10.0.0-linux-musl-x64.tar.gz";
        hash = "sha512-Txi3/RJiEjZLfKaMo/Pw1jNYzIcXL9cv533iVniNk0CBRCHBYwMXIkjwxyl7m5a8BpQXXEHveM4iG3vQLPlMpA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0/aspnetcore-runtime-10.0.0-osx-arm64.tar.gz";
        hash = "sha512-T7Fx/53sxhuazoI6HBZcUKbTz3URjqxCpCKQmzd0apz9CaKAF9cBwpMZ3kKnWnds9jhGugTV4PfalkuoHFMiTQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0/aspnetcore-runtime-10.0.0-osx-x64.tar.gz";
        hash = "sha512-NnZGSVgijMmjjZbacxfJWVM7cyV1LxDBo7JhZg+geHmc451AQVOsweRgo4C0ImPSs2nOUbO15p5+GdhBTcTE9w==";
=======
  release_10_0 = "10.0.0-rc.2";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.0-rc.2.25502.107";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.2.25502.107/aspnetcore-runtime-10.0.0-rc.2.25502.107-linux-arm.tar.gz";
        hash = "sha512-RXOXwcFuMTHcNkKezwQUwnjnbnqwVhNill3BUplT8zQBzMnivYJApuPQlxG5k0Ye6h+JI5AeE4qeGyZ7hCMclg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.2.25502.107/aspnetcore-runtime-10.0.0-rc.2.25502.107-linux-arm64.tar.gz";
        hash = "sha512-4HXBe9WZLPaqsfi1mGRaCXa6Qfz8dBTn9z8l/pZk2bFF1KYa31DCF0GPJJUTE3GvBejfTaeFjHKsSxOmeRB2EA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.2.25502.107/aspnetcore-runtime-10.0.0-rc.2.25502.107-linux-x64.tar.gz";
        hash = "sha512-FAO6wy9LQ3DWZ4QaOkyr0R4zDrClSRiUSR08QYxf2c53ndYpgAlHqx6gGOWnJg/O538gLij6jBiW16AXfQOMfw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.2.25502.107/aspnetcore-runtime-10.0.0-rc.2.25502.107-linux-musl-arm.tar.gz";
        hash = "sha512-ahZGywTD2ZEUT2FfFsyszICvtaBX+dlmIPmr24qvkXC3MZOWRVsRk6b793U4UWurEVVF6ZrpWY5qXY7FD2ZeXQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.2.25502.107/aspnetcore-runtime-10.0.0-rc.2.25502.107-linux-musl-arm64.tar.gz";
        hash = "sha512-ax3VcSTsMrKWKOzfrBMjf/pO3y+fKwT+w75qfFgRNmDgHlSr4qR50AJs6GX13lPFmM0yhL3crByBjo35vx0XCA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.2.25502.107/aspnetcore-runtime-10.0.0-rc.2.25502.107-linux-musl-x64.tar.gz";
        hash = "sha512-vrVCuMUmveGoriyyKGwJlmpS00KJomVpjDJgAQCoNzq4hYqEVBqEP43xl5YEhURcaAk+sDvctiwjmOKe146HUQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.2.25502.107/aspnetcore-runtime-10.0.0-rc.2.25502.107-osx-arm64.tar.gz";
        hash = "sha512-nydHh5ePwdcun6BZDdQY0yIDUqODqQmFTQvbgqfDIxZU4hSW7661kCiS3Mo/JvEz7B3yY38+hXj7mcjClQkBXA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-rc.2.25502.107/aspnetcore-runtime-10.0.0-rc.2.25502.107-osx-x64.tar.gz";
        hash = "sha512-lVKMR713KOs6wRK6VD64X18QEgU+WGxT+VKbo/7phAmA29Hl9+0xTaTh2gXQrz/HsXVKpx3Bq4s+53/mO8gVCA==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
<<<<<<< HEAD
    version = "10.0.0";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0/dotnet-runtime-10.0.0-linux-arm.tar.gz";
        hash = "sha512-QwFryp+QAr6Ks0cwEkL+8Dt7vQDtNPt7mmkIcZuD0PLol77jlUAmzCcUuCFF5kpJv/OG9MBK57YCQUNNyH4fhA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0/dotnet-runtime-10.0.0-linux-arm64.tar.gz";
        hash = "sha512-hvK1vLnVbCqjUxTz7tq3FbvCHzPGb1xF/OP3PCKsFwHppEQVoG9wMezof0+4SBqbj6m+bwMAmDGe5W0pWoAV1w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0/dotnet-runtime-10.0.0-linux-x64.tar.gz";
        hash = "sha512-CuiWaDRehaPEl3zXLpRIDgVYuupJS//q9pi7W+QAuMp4trWPihAk59Ihy8375oEDcucu22Ec08UATJeS6olAsg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0/dotnet-runtime-10.0.0-linux-musl-arm.tar.gz";
        hash = "sha512-2/5QzZLDXLS43yllErFZzeZxOLnzJT7x8T3EbxgYWepLl1OVmpb5pPCFHAFwvvoxilD74+KBk9GFwViqgFndJg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0/dotnet-runtime-10.0.0-linux-musl-arm64.tar.gz";
        hash = "sha512-QqCC260s+X6+BK1wtULTug5/3ldtE3zGNxRkH64tzOT77+VqEnccSfyuQY1Kc+BHnEIPODEWn8mRXBmcoyykAA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0/dotnet-runtime-10.0.0-linux-musl-x64.tar.gz";
        hash = "sha512-ZNCAY9izOVzxAQw1LwM94sPN56VAkhnpgSuecFP15+Fp2IyIaQJUw5/qch2agy3NPHTdmv8GRjB4RFdUvNnkMg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0/dotnet-runtime-10.0.0-osx-arm64.tar.gz";
        hash = "sha512-r44gDjHbURrr5QygLR/GNNe32HaZQP0E9fv5mZQW9Iqf/uWFjpGEdRVSKYTGeBXOYYmh/RH1VAsT8r1sf+bDew==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0/dotnet-runtime-10.0.0-osx-x64.tar.gz";
        hash = "sha512-vAgFlrbpLQdbQ/WQknazbb3Nrjr6eUE/c1RVQLeaflpAOzdRqXYlpOBvEKLhZuGhBZgHbP47PNbkiPWS7hrF+Q==";
=======
    version = "10.0.0-rc.2.25502.107";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.2.25502.107/dotnet-runtime-10.0.0-rc.2.25502.107-linux-arm.tar.gz";
        hash = "sha512-DJXv15WufpXB20TlEJvX/BdIelELi+i+HwB5uAZmxa+qPtqAN0gWA9Cqz/0l9pH7z6OItLlXc0aQHGMffgN6EQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.2.25502.107/dotnet-runtime-10.0.0-rc.2.25502.107-linux-arm64.tar.gz";
        hash = "sha512-5Fua/p7gZFDY0mNmJdCiJX5ABdn0RIQ2Xcsxs2K7tq9Q7VqSQq210tlzoyWeRE3CF/reJbqZ36B+wCFd/qwvLw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.2.25502.107/dotnet-runtime-10.0.0-rc.2.25502.107-linux-x64.tar.gz";
        hash = "sha512-hqcTeMqtJmJuVbT0fLDqEFRK+lqt29DzPZuIsf2fpTJuKsZPnf5BaYS6E8GJNpDP4Ek94D7uAdqGXEtVGT8RwQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.2.25502.107/dotnet-runtime-10.0.0-rc.2.25502.107-linux-musl-arm.tar.gz";
        hash = "sha512-ozCEpKgdIi8lrnOWZHGOXGdo69vWKsFM0eD1cOfF5MWB9ou67WUyHE4G3Jp9hf9gwNWf1VW++RqRTzM+o5Nt3Q==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.2.25502.107/dotnet-runtime-10.0.0-rc.2.25502.107-linux-musl-arm64.tar.gz";
        hash = "sha512-I81zfdNIDK/ZBhWiLzbwrK0rpXgNhNDke45jE6SUvYK4fCrROr99kQ26jkTv6zZWgJ1U3MRsIwhmgtYWk3fdBQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.2.25502.107/dotnet-runtime-10.0.0-rc.2.25502.107-linux-musl-x64.tar.gz";
        hash = "sha512-eplb4vU0ro3ZzuzXq7q6WyJ5ujbdkAcUHx7dbfQSFK4WNrLIxaqtYCoStN69o+oVzocWljHoiGiy7DiHBNnIxg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.2.25502.107/dotnet-runtime-10.0.0-rc.2.25502.107-osx-arm64.tar.gz";
        hash = "sha512-e4Z16OTkJMXqpnUVO32Tx43tSu34R7EWt6d8/itpKoxi6Lwegqhg+FAG/ZBHN5GmHtN9Cep+m4SMcmT8ma0mMg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-rc.2.25502.107/dotnet-runtime-10.0.0-rc.2.25502.107-osx-x64.tar.gz";
        hash = "sha512-gEKnCKZlrfDgSDftoUM/zKBzycAIYZbdHPYMMQyBjs0sJXU+HoEHfJv7KvNkgxj8fRABfXnJG0j0KcE/vfeTHA==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
<<<<<<< HEAD
    version = "10.0.100";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100/dotnet-sdk-10.0.100-linux-arm.tar.gz";
        hash = "sha512-RfLX/QVnCloU+kgIieRZIHgid1ddug2kTCWZl9BZ1kBwtArHqunww6MHbZ/tW3h4VKir3C39tHg7RJwFwcm0nA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100/dotnet-sdk-10.0.100-linux-arm64.tar.gz";
        hash = "sha512-JPwrEFq4SEw0IT71esTmo2plkyQfDrxs8KQOwvX+otdt6FxLh7KlOBTRlOMuwSiN1QU81vUnaNec0KyUjL+E6g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100/dotnet-sdk-10.0.100-linux-x64.tar.gz";
        hash = "sha512-9426wwya8iMNZ/9cIk3jpdv2P4p40cIGWU3tuA5pCdLMip2GXVEFxywv0qomb8DGx33trGBAjLzPJysRa9EbBw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100/dotnet-sdk-10.0.100-linux-musl-arm.tar.gz";
        hash = "sha512-WlQ3WEUQGcKcncMiDDCVvlI0qa3G/l3Mw2eIaxYKkHstaoG+j9PA9Sfp7IMnA7JUbeyBqN8oAtn271YUCC4TsA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100/dotnet-sdk-10.0.100-linux-musl-arm64.tar.gz";
        hash = "sha512-X7lEIc5Ylvs2tkvQ+XWoPRk4ZBIF2J9EciyOpEoD+1hE2f7m1y+SrFY9EEC3buPx5j4vc4RntDKdLqvtDFsEyg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100/dotnet-sdk-10.0.100-linux-musl-x64.tar.gz";
        hash = "sha512-L7fdybIypn9pJiuL7rtfoiPahskxTwdO15sVGnu9CxtcNr5UgNNj2CcJrmn9kPempFHvaAJuBAZYFDTtKIsg7A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100/dotnet-sdk-10.0.100-osx-arm64.tar.gz";
        hash = "sha512-DunHdPnGNgGERhm2fWyoKdcPomuZSbgI6AE4DDXtsS5MlBi6+OLvi6HcbcfTB9v1gw+w9Pl2ZgMqORxcCX7mBw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100/dotnet-sdk-10.0.100-osx-x64.tar.gz";
        hash = "sha512-WVw8ZhpwWiVvUuA+Ou64Z1Otb5qj1Z9IcwTNu7dEo59OP6ZEWmDN7WvHjhL1HVLtWhg+pwoFYLlr7WH7g5WPgQ==";
=======
    version = "10.0.100-rc.2.25502.107";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.2.25502.107/dotnet-sdk-10.0.100-rc.2.25502.107-linux-arm.tar.gz";
        hash = "sha512-eiIncogEsBXQse0KJrkAQrbqcR6nxEMAsA0reWwBSalfX78wPMzBXQVKI44Cm9ANetxzSvA2FLAGv8eCk8moOQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.2.25502.107/dotnet-sdk-10.0.100-rc.2.25502.107-linux-arm64.tar.gz";
        hash = "sha512-pEEEWfBX9/h0DLH31pZSe7pIuoZLUZ51e4jIYitPwxK6ZFN3Rjdw9y0aslLd6Y8Hi+3wzVmv3gxRm4I67ijmww==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.2.25502.107/dotnet-sdk-10.0.100-rc.2.25502.107-linux-x64.tar.gz";
        hash = "sha512-EgD/M9fCqDRJlZDgX0bAZdD33B91IPNUA7XU/B+wC937fEquIwKA6NxokP5fxcpzjepHiQVmFO0CqE0ehtBo6Q==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.2.25502.107/dotnet-sdk-10.0.100-rc.2.25502.107-linux-musl-arm.tar.gz";
        hash = "sha512-tNgUQhCt+jwefr9wmNgUP/IjN0wjHjqcO5UjBg+P4CpaAkBJVEjRl95sm5fKta954Ofhnl8p7FSp31WvFeUQ5A==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.2.25502.107/dotnet-sdk-10.0.100-rc.2.25502.107-linux-musl-arm64.tar.gz";
        hash = "sha512-73pA0+ULVFYs+gUrCxXOTE0we0dYdAHtSgshPKEstFX6YO2hR1pAgBtVblMP5GF3Cjf4EPskZ9MLVOkmKvzNDQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.2.25502.107/dotnet-sdk-10.0.100-rc.2.25502.107-linux-musl-x64.tar.gz";
        hash = "sha512-oxvqxFB36unAENrLA/UvZ82A9wvzrssCy0pdAN9HfGDSKeOU6cWwknHyMRlyEW8cKgmrwEBARSB0giys1mhLdQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.2.25502.107/dotnet-sdk-10.0.100-rc.2.25502.107-osx-arm64.tar.gz";
        hash = "sha512-4qjERriGb97WCmbhT4kW5bbUcnBxPT+b/dUIvo8B0D+EoldgQob3Oq47T8t9KJVk3Rvc6E4HoDz6HkO2KuXdvw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-rc.2.25502.107/dotnet-sdk-10.0.100-rc.2.25502.107-osx-x64.tar.gz";
        hash = "sha512-kZVpQU9HhCxahNlq+WXPg41YgwvOW4f2dHez9N8OYL7O3Rz7PPUeBKZLl4PDlE3yjuTe4uSRi9TIFFICVMo58g==";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk = sdk_10_0;

  sdk_10_0 = sdk_10_0_1xx;
}
