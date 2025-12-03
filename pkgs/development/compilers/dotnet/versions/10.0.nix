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
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.0";
        hash = "sha512-jlcG3SsEkcWQn7xUWuEU3uscK6rLQSCPNWO43k+enQHf/7mmsvAAu3DRHl2STsZclB/KrhQm0qgK/FiEhD9j3g==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.0";
        hash = "sha512-UkVobkMgbeFCpcgTV0TvMUTzWlI5G4Ha1OlS26HKDzdY+AEhJ7UcymZ7SR16W3mw6mRunKiQtXuwtN+fZ/jE1w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0";
        hash = "sha512-fKoXVn60Ct8JOazjDuwpzGZSGqVHBXboJeyCWJQj6w2B2x0p3mOJkR0/kOifxT+E2NMX2Zx12VELKK9hAAOt2w==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.0";
        hash = "sha512-+jM9DkV8UdrLkm6PyfbUpRJLOC1pVfDHlKD9gXU/1fDkFpy7q8RSnQ5GCbxL5o5U7q6lfh4rQ5FsCD0fJC+zYw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0";
        hash = "sha512-RfDDFGwkXvXes6pzq+Fl8RNweoSOwrQsjL++Zp1+DLY9uwAoKeDYjTai2Rin29MjmD5t854ZivDKP3X5HXYRRg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.0";
        hash = "sha512-ZBdYFk/Myia1U4r2tFfidqRUCfMrW9mC+D9xHoDCDELpmysFcIdNfPIAdXa3jXwv+EfNbh1D2+l/pSASHSx0Jw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.0";
        hash = "sha512-THBCdaGd2SWs4ECp5ZGPi1vB1SiIiTEsCYSAegJayw2Ic9Ky0RdaWSA+Q0yfI2sfnSsd97Vk2dhHuzvFBgPFbQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0";
        hash = "sha512-YjvVt1y61529YYJzPuFbeFxBgekq8sDg01yudN6zKcDmacQhUtfx16xijd/9bcixH4HWCjB7tjEHLuDptm5m+Q==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.0";
        hash = "sha512-fE0I9SJDBxOX+OTzbA1rg4omn21xp08dzm7+zHX/U1wZxy1TO/bRhcLlEMs5f+nNXN6/8f0b4eqsglqtZz45uQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0";
        hash = "sha512-Gubgq6b9GOrD/q+eXHW14RrxcYeWsQ2bl9jL8HZaR6kXYVWd1CAF1TjKbqFLLuG01pqvDIdu8R6pMxGgsWWKFA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.0";
        hash = "sha512-lno9hyxtY9nPVBi/VUZeLS7ARDEMBJDI2gTp6VlnbPIJuYTyUYOD/tyo6bwHG62Ie0Tifm5gzR856jgiMvV6Pg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0";
        hash = "sha512-C2VAFhG7JYz5QEkZGkiPgoJTiERvR/bwVWfEdTyijHcUqeryjm0u89qx5Iz5AOR6U5wQNej+2Pp5BdlEd/MKPw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.0";
        hash = "sha512-A8Zm2HoUc2fV03HqemG6BProBJYIa87mzjbBvKIDXMshispBmeVfbsEQGoJEst8KKi2vLttDX42qJdEB419eTQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0";
        hash = "sha512-gbyYz6R9QJJZ5j6XtkG5asyKRcW6IvnXLwklvAvk4bkU0+kP7USIn+EtXyDqFKuiohPRzD+sHi04LmDqc+FRiA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.0";
        hash = "sha512-/h0qoO2NaKn3nyYXFiXJwUFvcrAJgZVmkK9dam1UFaDHwkPSufBsTx+wsO6YFtCgtfsDM0K2yNlsiIi2LflNIA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0";
        hash = "sha512-PtkF0VBMXdPyavJUUaCp6OBEhc1SeCz7oaYTn8y+TqczP75cqDXIUk7X6DL20UorQ0VmXBAXLVHv9ey6LP8Mbg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.0";
        hash = "sha512-uJ/dGjqaFz9YEEe5trIQk7dktkVgs1KWHsd42zdoPX+POC5JIp/aS8JFNECQK9tQQEZfgNeUT0lqfPJyGpP5aA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0";
        hash = "sha512-XHtJ+LmFsV0RRD1H8zpRp3+yzOstV/TaRwAg38b+8PvgXn+VEIVVHzlqWu/eB8AMPoVbC7b+OnOTTlBPf3R7+g==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.0";
        hash = "sha512-GGEi3CB8BqkuKKGxaz+UURu8mBOkdiE9rd4CqQGL/cvHVFCRxNMXeSESLChfhy1S6Sdh3lnwGS+h2WgJpynTgg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
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
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
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
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
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
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
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
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
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
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
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
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
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
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
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
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
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
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
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
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
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
      })
    ];
  };

in
rec {
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
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
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
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
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
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0 = sdk_10_0_1xx;
}
