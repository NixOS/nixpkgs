{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "8.0.27";
      hash = "sha512-mNGzyA04RQxdH9F2FRe0GCfUTbHIY+TjYvoiIQbwNS1sMJYpozexMTvnt3PjBoQi8r5ZNrmcPSsjKGfTxwm8CQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.27";
      hash = "sha512-VzZEJQ2QpkGo2e6JpjY16oxqWQcT6v/6bDiX09RheUMUZKtk3X1sTXLDVRer/oSd5SkNMmQecvEWHjOKu+I8YA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.27";
      hash = "sha512-COIDOLI+iRD4U6FeQ1AVdD7CExSXBZfca+EM0Cn46CcWsLdgjcpgMpyfHUqouCkEXkWbX/r7yVw8PNuEj9Lb8A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.27";
      hash = "sha512-KpDdnTkOsJIxo6cAJigTGrlzgYY1CX1F7QKAvpRqIs+cD/W3Jpj/BO9kDgAa1bVPJ8iyMpq2fEGhaSCFXffgZA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.27";
      hash = "sha512-Acw/FiXMfAy4VM0VVU7f79Q948O/wDKw6CMhZ7dMp8h3I/eAAtI0fd8TS8+EEn0JflJz4oRBTZyXdkfwCDjKZQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.27";
      hash = "sha512-VbRPzxB29H0YKyZM5ETyPshZv61UsNlx//FWmP/xppyVCzf23YSToaV60QQZbakOLZ2+A0DRhLm1iGsqcr6NgA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.27";
      hash = "sha512-0+LSFct/q6HujGECSufmu7M8SYQ/wXMiEQqcNWS87nEFOeoNFLoyX2ohhgi3t7OtmGDTIxRo2gi/XI9CBdLYxQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.27";
      hash = "sha512-WndxmklJY4EjecTSMbfO+oAdO2nHLGUoVSlb+Lv853sNxQnwxDDl2Ff+G04S6jT2AfqsCh6WX3b56ewOwVKRyQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.27";
        hash = "sha512-rtyGO3EHVUP07fTn/vi3aQONUxtvRH/2ov2YkeP/TqiN58Ti97cg4IZ71+yEB2xkULbpFnDK1c1DeHzn3n8a8g==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.27";
        hash = "sha512-bErrdAIQR855a8in/TGCReskuIS16VvWWQpWROznmLellb8ClL6MyrCrRxDeqRH781JCr7Se4eq36tD5KSpSxg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.27";
        hash = "sha512-8/Ny9R5vsByZ9MFhkP/rVQ5kerg2zCwa6pyF6fde0lalWKAny5hfvis7QR+DjJDtWpb/mVP/lAvDoEGN+DkxjA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.27";
        hash = "sha512-i2LdD5Tt4B2JSaD/hegIHq/0WFc/KCWBCpn7HrGqp3r1g903txcxmT+rJbrBzI6CGRgXoOjnq75kqvGEZ8M3KQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.27";
        hash = "sha512-cu5rpNjE2yMAvs4ONze0IhSLrctkYGk1EUsyVvBC0BUqLtrbhY3Rp3rTE4prTOq65/4GgOk+KyoLQIttKlvFyQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.27";
        hash = "sha512-suSFGwmNNDC8FWMT0Nyjz7BEBFbFDZodpvD+1bfEsLKeEk3sgrAfwHEokPN1sX111RZnsYDaK7u8f4Rgdrf4Uw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.27";
        hash = "sha512-j/hKslSOJ+m+AfLqF6g4sdFHJG3yg2p6r10OGIgi8eCsm+rd5BJC5EGUm5QInRHwjyzhe/YhvuLNPk5gy9hg7Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.27";
        hash = "sha512-xpD6dzvEUSqQiKLyctC6jNqrLyCJLofngY15W0es8OJO8aEdsHqqL9HLGbDL4FSmBjsMZaSEfY/Fh7J9Lwd5RQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.27";
        hash = "sha512-nTiOFTTbUoDhwzDmkyJCOcH2xf5Kr/EHwUEK+S38ZdgUe+IUURqpTmrx4kUxDaxJJgWX6W1s3+QUvIy5PD9Lwg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.27";
        hash = "sha512-03Mu1821X10zB0MzVCdgyDDKTSA42WEACAm8HXVKUwsoc3F8pmfT1KYLpWbt0Ob/LWcStuGriDjkco+ANcQrNg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.27";
        hash = "sha512-2p6hfoIr7cn09mCTZoRTzVKpXqLo669BINHJOafB3pe1X9uoFkeB5dCtLJrOBj0ZPoKMIwG63aZB5vQ+5EF/0w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.27";
        hash = "sha512-kUE2bZEpCXZuXJ75QBmNezHO+p+g2T0+A/VxwiuphH7IFUmTSfkShGL7TnL7/xLhEEYqj6AvM7zNkx2npfusjg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.27";
        hash = "sha512-c53DhZ/hMq9FIMUCjP+4bd78ABzcPzt8SDbjYwf0lkTqJTrb12OdafiN28decGEy7IVRMMUge7tkRhYu/7Bxyw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.27";
        hash = "sha512-OU4t21a2vv6V3EkO+C7oP5AkyxCCE7KpSS6cMzkx6A8wYobasj+zJbm65Pp78iYMc62eHk5DckeoPpFe3C0+Rw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.27";
        hash = "sha512-YQ+grIOTcd3syDT/R2KWA2ImtcqmzjQD+rxNGXOTt29m5MEXKUPR1QXidYbJ2rKwIqPz7nqSnqdvXBJ+hCqe9g==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.27";
        hash = "sha512-ahezSf731qAlgFA1HDDmBXpBBOZafJLtz7NTzA/qLiUhl2x5CqUAAj0mU9C3GjX+GFVtNfsWML0sEdDI4mL+Lg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.27";
        hash = "sha512-cceU89zN5TLbjNrCIC9RDjnTTMaN9q5yVANrjmV5AThO4pIlGI8NcXXBblh1FvVlzKVQe0z0UWlFwwo5LGpPQg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.27";
        hash = "sha512-vM/UUSU6kIaLyN7r8/wdlRs5ukHswOknlB/UtT+/gUu4TVa6xmrMiGI5l+mUHxpvRJ8r0mTt9N3pY56xuYUKnQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.27";
        hash = "sha512-w1toyv6+mzzQ1gfIdcIU1OS626YUZxLcc7/VK4+oeWY4z6zw3dgWidKudceNmXEv0s62YDkhIsEoV/FSZLthzA==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.27";
        hash = "sha512-b2RoXyzhrt00kQpT1hsJAUGJxU3Yqsc71PHI0YNdblTL2YKEHd5ExA/fNHl4IX5qG+aAkxT9SMzDPOwzoYtmzw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.27";
        hash = "sha512-hvdw0On6bVhb0rRupUq5GxWLVbnilOYCTYYbEHv5F0JY3TRHqETcELJzv79M+N6ARwZ1qq2MMlCFRmsro3eqMA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.27";
        hash = "sha512-agbHqa/5g7coLfJTZ9MYmOHc87lyiKuZ+s9oo1VAu5DmgIJBByXbJHaUth+zc39Fc0g79kfzSoco7P9Vchnrog==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.27";
        hash = "sha512-smUc32ADyaw3MZBX8FI4gNXS8JbkfBzGxtEjiNGs5EGLmkRISeTyZYuoIDKZop2OirOVRuef4RKsvp0bjS+yRw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.27";
        hash = "sha512-6k29rB2PlB7E859ln0WdvPRVVcGxKNL1wTa+RgDHX/uUsFBUyzL7vj7GB79hnZomeZF6nFxwl2GcWEtw4rWp6A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.27";
        hash = "sha512-zaGRq5/hvBT9Iu+7RfEPk0YSHI0yEYbK8gABkbW3QoTO76vibAciN9xoIRLMfjkaGjAkMETknBmzo2jepjRuPg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.27";
        hash = "sha512-hwHSzedBHkFYoVgclChNw+p127C7hNgOgDhjv4KZNdxd6HFiKXLrNlPLSLvxbp5y16WDQlWX6hwMnHxPXPU2/A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.27";
        hash = "sha512-fBmZ1oc3uKTcvqDAigwkn4lQoBEsgfYTGAAXIVfSSLhDb2X6F8+VNq357vw1owAEikGGeSCTDm2xYBjq+G9zTg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.27";
        hash = "sha512-MsxhBKxafcCgvzxyojeTclpec3NjRiXFJrR00/BdLIqJHTeF8J5ZiBeDRBIbn3ZYZzB+mj8MMUiEYcK0Wpqxpg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.27";
        hash = "sha512-Jo4RD34awTTpGF3y0RmQHo+G7GM2vlXgsXfC2FsHFqexwoLYQJHn93EBMTh6PB7Ucrws3ztYOAtxqpR12hnNYg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.27";
        hash = "sha512-Vlwfi89vSKQf0p4kYCYbOVQo0S+fmgkCzp/1L34H+zHJYP2T2W9uWzNmFV7M2/cv7AHBzl3AwiyiZkdlrsbfOA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.27";
        hash = "sha512-8dompbDPU5Ve8Ja7Aom22HU+vCHPPNB2+2G7GoPG50IQGriD99JsTFo5EUPNIDohFgSNChgSUAbOD2Wo9KD+YQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.27";
        hash = "sha512-vv4I2cZb4u9tawBMXTqpg0oxwkX2BtcWQ8BOojBNu+assh9+o//i9GcePNnUaRTzCnfB85V87/iDCzKCAMgO4w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.27";
        hash = "sha512-r89AWUMvP+oNKglzx+GBs6UbGR2iE5ohlil/7iosX5EMRfwfjryYrywuVHnT9ar0Rdfkx81jdoqBaQIBZwQtDQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.27";
        hash = "sha512-qUJT638UMcMyM7lQQ4Tk+dgS3QQfu2FNlzQ/Hrnd60SjSE1GQLiL8DUJCot/dS4lHok6L5PZhBdw6xHW0H+EMw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.27";
        hash = "sha512-4LMBU6UTxqm19+oeKdNHdJ6LTDQzzvefuGDeklFwJAS6KYZVUo7mM5O49We5MbWL/77uErXxFlv7xXLMwk/gSw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.27";
        hash = "sha512-t1BGOmN7AAqzHUzHK9peyGhats+fo/6wwnyh0JAodPi8aq1YZIAqWPKyCU7qqMh1AQR33VvI0qR5ZrmybjwdiA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.27";
        hash = "sha512-mAVXHbKtlxiWCNPpkOUwG0F6+ghqKFEHB8KPY5q1nJh4am75vCapn/Qlozf4DqbXYGH0MSbjkhDZ0Gc891PC6g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.27";
        hash = "sha512-FnI3egtVAblHpS8463WvLmGAY1lTNM2YcaoMcShtY4b95Ofi2oTKdMkMdaYlBqI9RxcSw+dbOi2dpC9d1Q2Bzg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.27";
        hash = "sha512-NrsvwjrpVZ4sbHpxn30+6othR+mz7TspO6knw0uIfZUOj+FuGYWcuatw8VZo+S6sgCy4MvFdQoGHNrewIE67jQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.27";
        hash = "sha512-bJb2ox35+yT8eV6erDQC1glSsejP47qBVfSK25wf6Tm36nCDxB1sCaC8BuAQT8NNA1lIWSVz19Iw3QUFQDnN3g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.27";
        hash = "sha512-MxsQgSLHd6Tb12oUyM2EYFAdYONeporu/YfxfTXNQ2v/eO/2e5j4v2gVpJJTEhk2YcPARKh/8LuvZby30g1Icw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.27";
        hash = "sha512-UAlWz/66iCXXBIkmEOMKZeDAd9NdtJCmYrk1ZhmnntxqAb109Z/K0yCmUrex/jPOIumU8ugyrUbSNrH2BxfyqA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.27";
        hash = "sha512-XJ1m0DymAZyx+VHGAu6pKACdqIEu70XVmumfvXTwFmIX6txXlOQfErY0NPsDBZFMBq5xFyAP1u5L2HeAh7H70g==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.27";
        hash = "sha512-hWtl+vhk/PTLhyu9ptzff2pilf8EAIewqEvsre7M95vXi47K9GpoNBp219zT6L5vG/aSpWXOYYfJvk+UtFl0jQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.27";
        hash = "sha512-l276n9igfKG/8Mk4yTTuNFCWY476+bGWC2MyfRfIPfnoFMGLCIPpHdv2UuVuHI5pV5n2oiFCXCJlxyroXnadLg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.27";
        hash = "sha512-4/THNkcqI+f2IjGJ9EdU8Gn/onP0ifqq9r+gOZ90jpltsMdmDFVxeIJersAMBHei4Sudf6BIvvv8psdxlNqemA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.27";
        hash = "sha512-4wnZK3emfFTpc43NjqPDR4ShViNRjmk8vip8LuNGPzms4zzkov2Nct1K4vIAItixf4cqXZTM1vvo25AtvWGLDg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.27";
        hash = "sha512-ndVX7raYUIcQoBsWaCxG+aXTZZyr9mdUChaesVTrrM/5b/FSfavzkXA6HTFNjj+fuKNmmG9Fq83KjryvTktuZw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.27";
        hash = "sha512-XvkKKHwLw4zEx6DMnPs8Wfl1/7fjPPiJZkBLxVUqajM0FCv2Gjfs7X6mQcidHjf4O/OVp0Gjp2RjADPoWwGlFQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.27";
        hash = "sha512-lpzYrrzFhGUD0lYm8f9I0xoOSZyGZEBWBNyNssSPcIdO2/6gCF+lTMM4w6PVcds31S/6VqPe0CMZQdruJiEx7Q==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.27";
        hash = "sha512-+fpOf9Kogo2MmC5QxUnYwa2T2DgpS0BwLtivMD56SYMY87lDko5wBi+UThc65LKIZLSagi7BkV20Q6ASvMLNKw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.27";
        hash = "sha512-jN8gjSjpDFFPh1fh9+7u/cD+HTmBKE6gDhVL2aJxKJwfAyan9+2G3zkRaUhxjsIYsxrweHUr6RTMjNVbgyAf4Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.27";
        hash = "sha512-y6OK9Ozk+KeeL/xJWd4Nt9BnPIq2ZaJYUxNf7P5Sv3x+sLGSqJTROIAO5tYVBs0x4N5MQRoct5vGWjWn6XGB/A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.27";
        hash = "sha512-OeLuZImxnzJucMFOAnOIEhJCeS+KYkvV38ZmkYCoTipgWeYwNK7wTtQEz+2A+MYMuL9NOprB/16eiXcDcY1+oA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.27";
        hash = "sha512-gfB7/8J8I3jdbymQK/qLYzDyv60D8fp1aITNzpTmkBbFzW/7NGfbUt5a0a0jibop/bM2E1BLa8DKKfegBfD2Kg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.27";
        hash = "sha512-wbIhj5JuDC87kcZx2XwUxVpZCq1Kva7HuzmkRRdB2wirW4hh8xlk/iEL2WnB1U+bLzddaIoni64dnXXJ2a+LCQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.27";
        hash = "sha512-nslNMNt97RHvlGNdpSeV0I9jD75lEINCYMTY/F0ZwbsHHrzK3ONIILS0YUp1uaaObJCuO90M8u251EtGIFE9aw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.27";
        hash = "sha512-H4k2cdAN1djumU8wolzXfzLA6HW8SkS68UKBdwYLLjj0euX0TSA5xdGT3uUn17UrmhnBvJKdIC/1/ddn3HOiZw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.27";
        hash = "sha512-Ed+9XPIavpImxrWXmsYpbQPQJavfKGfJUX2KsV98Ai4sQ4vB3Zqm0u4jmi9Q6NErT4T0t2nIqCkbe4dPP43s0A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.27";
        hash = "sha512-CveWfaOxl5gPPKH4ja2zdr+FOsNP/T/zBtvWUcgwxFiivs8TthvJKzZmNbSh6xtIehWE83BCpZrTJ5d9bKGNgg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.27";
        hash = "sha512-v0401FVCQ0F9fGOkGz2eBrNVO+BMOv2GwrfIgo9C/lglRH/UIQj5GpwWLXxePILyan8lTVe6ndoUoxAHp/jDqQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.27";
        hash = "sha512-6Z9ajf0zw8fHAj9AKwZ3VIldmuO57mxjRhGS5y5WNUdofvoAyLjboeF+WQvIlf44hn2D6lkBVZHULSooh+kipw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.27";
        hash = "sha512-MiIekoPBS0BfzAxPltYAv4vrGZFs4kRKwjyRyegxaMdCi2d6OLodMl07XjYNQQ9wNkslRnjHTWnQ3b1ZRNb9kQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.27";
        hash = "sha512-GROYTo1Q1h30jZ+n83Ktqs0+rTTZHO8X0lh9w+wa87j+cRcnPcKTQK0oet8J3Zzy2YFKRC9AhqNGbPhnsxBbMA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.27";
        hash = "sha512-jJHutjo07M8SSLlLOXBLH5uHdGSHLxIvuIqOTV1RLRX48hLTvN42VGSjyPLktcnrhn76tCgxWL3JW/02ost44g==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.27";
        hash = "sha512-vlT/OPJEstLZ/yEq371tZuQrWzDFZZSHqtj/JoenV5U18e1zdQivnDGHDZ6x5JNzDcTEeMk122yEAaBp3+nfhA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.27";
        hash = "sha512-fA4NKbTxjfknYNqXvr6npni8WYJS4o6SFeHVWP3lj0qMqfOlOsCco5jXxJO10N3u49325T5jug/V6IGOiugjJg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.27";
        hash = "sha512-Je7H4Unx9bF1hef5kcudKl45w5QB4v2G1Oc386QUC00QMrOmM74yzTLSpNEUUlcs2XQ9FmBj1WXcxSbgZgxmeA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.27";
        hash = "sha512-bUNQzMCu1VPbS8ZrTjl/LNXqxblbTRXw6jHI9S4BReZXLa87+raAK+svXpdS2VePjqjTUkvZLEJYGqsoA9ZNdg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.27";
        hash = "sha512-Fw6K2pUzQ2Ct1L+3BKjhqw8MRL3Xxqu/CrXyk66kHFq3TU0Xdrp2aBeIFmUWandPkVrtxorruTwT0KfvZ9mVwg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.27";
        hash = "sha512-yjaQjtoOegJHlCxI01eUuqv1oY5tLKNGcIu9K/RfqnqSM6gwBbIexaEPqwDntB+zF3ZHISozlx0BgLuawpk3vw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.27";
        hash = "sha512-pJFeniseubJtq2gUuHJxnIRs06PJFjmBnoN1Mw2a4+6wT5YWnStcJYKpg6vF/5TcO7h21/8NeKAArQ4PfMdzhQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.27";
        hash = "sha512-aCYEySRJEXM1x2WaOuRFGqd8hARxMyRT1/UPDC/FPQy8pcAws5o9S6g8m/DTOjeooNsX3UfRxFZKPabAk2fVkQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.27";
        hash = "sha512-DrHPM/204IfDE+tWSPSMnduvzOSoivEJS9DPw/ssmLjhutqyrlqasChfc+Yy4M8r+QMD256ydDw13AN80gi9xQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.27";
        hash = "sha512-pli5Iw/aJjLe3fdXF/1ZERaPLTxWMb56HOHzWyQcTW4HDFKVE9uZc62mYld5Uz719kih2OKafDp+GlXEt79VRg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.27";
        hash = "sha512-hdtBM8bYISs9ryqPiZG1U1ltt4c1jr1Co6MG08Mam0HObhJ9dTzRu5TYdaarEwOarMswdcWeKxOWzC+4w26xgA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.27";
        hash = "sha512-T6AoZqdSTn+P2Xfn7AQF6485J2jZl3IBVdD0W5GjZknXUH2B6o9cuVniqIRzfw0ULvvcICQ+SF154WYW1mb0TA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.27";
        hash = "sha512-s5kcrtZW64p727GYCyEc/EP6nPOiPkj3OLlMEEGEZPbYLqnxKpsUCrckyKh7/X6cftx4j4mYExmqOK8Gb16y+Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.27";
        hash = "sha512-9aTmhV/OBAClrHEqui5ucXgh9uAswKIZDO6b/yaV7bz03LaduGRCdU1HwCKiq5I8hpUhpnjBOWl8zzH4zsYm+w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.27";
        hash = "sha512-NdpjUHzyQqnk7eU+Ov5YC/372ZOkeJsD4ha6Qglz7GXuMjZ7s8asBpJCurG2sZTUT4T8c+cewGuOY6CZTxOp3w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.27";
        hash = "sha512-i99jBtEhFPX0BgrIsgifMLnps3aJgOB5RVv6UAuxKGkKJPTP+WCVSE2ggOK+BO3Rek5qRJ0pHKFf64TUZMz1vQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.27";
        hash = "sha512-fhQMlIlCWUje/Jes9qgXmivzP8maU9wvscDtHt6SMcRsgZujY9Bf6NRIwc9fkJvn18wUQB91888D6FgGcaUWJA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.27";
        hash = "sha512-ebzYgEMuOuCwFGc1L37DnUAgO3RE2sl0SSsFDNZGPxA11xMoNz04mdSBGkLT7/SgfK8T21Zzknu7SuGYNAM+kg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.27";
        hash = "sha512-sT4VGf7zlQVAwMyEB8l95n1u/mbH1EGo+Isr0Oa7ImIJ0KeS6csRrOKX2I0CEXTpIEyzW5l6AaySBOZNCjtOSA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.27";
        hash = "sha512-QjDaXOgDjjtOvn3PmT09+EWJMlu+S3stShpRZBa8VCk6Ux44+q9yaKpLQLFn+2cPIbdMC3Ir45dmQ9nC/BViOg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.27";
        hash = "sha512-9HURY/uBs+tizO6H7iz9deC9u0F3KFgnpDkNSopXexaE8QkYmIASrM+oVDTMCi9hbjo/O/XXcXGjmoI+zOF5mw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.27";
        hash = "sha512-0wrucC6gMM7af+QW0UKir/RvSQljaueTupVbHqupIS+wdSuwrj+heV9sH6OJZMinag9jH4q5GgaPLq3lAkz6lQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.27";
        hash = "sha512-fDR3AU5LOA6OmhNAqYm7DvCQ1kfBgLXZ4bkTzud/0exSlY0pwcpEHzJ+kQKqQSnxWrhT2C5HWpg8Szx7sKv+RQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.27";
        hash = "sha512-cgp1qIWd8PztBN7ktF6gawfXIQVO2O00tlG14B/ZbB3zTES1laY7xjQ73VMQsU2uB2RWgo+G+dYX0Bj97yJn6Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.27";
        hash = "sha512-3CV1X/eIZ1dFsrmm6vwj4rqlbHtxBa9QPfbE5H87WxWdPYd64nxQLbd/f/p6uV9Bn11yaOD9U0QcK5DRl21TUw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.27";
        hash = "sha512-c/RZotnGwPLnKPQy14s+vT2F9K6Wh4xfa4SRxgK3Ki/ocA2lFRnelR02MKyCTlwvAGSKNIEArif/j04RA5xSIw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.27";
        hash = "sha512-OnJwifprbc/BPTDRezE//nHh9IrQjlubZgMf1b7CJppAjkBqHjFS/2iMcVPuyki2RifU6VGBSaN2JIu3WYPcfw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.27";
        hash = "sha512-41AM8LXKcj9ARmTSUCFJUCwGSwkA1gW5GP6ASImrP60Lx6D2U2lqlKAY9+/MJYefglQ6yMM6Q1NL545OJsj8lw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.27";
        hash = "sha512-maVQsOxHJC3mNpKVaUDSJnM+HZl17L1yr8tEBRBPqAQtPGMxT5DKnak6OFs2wx4qHly6wBqXnbN1+rawRgtctw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.27";
        hash = "sha512-8cKi/fr15wWY0rXAeCy9vRKvmRO2oTGC33+2kq0NxxvWT9FCur+xC3rCp0hD+49jyLpeyM45DYUhVjsX55Ql6A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.27";
        hash = "sha512-UCO+MXKlPrWFnLMTvh+P1BOQT0AjRp5qa9NlxKd7c1YyOXn0sXY3AXx5Adan07goOlu6eeEBqzcJKvHyWVxNHA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.27";
        hash = "sha512-cvtxz6Tnnc9J5Zb997wMopq5pzqNS/qcXPPDzyJAmQTGCN8nft5dGCedB7Co1+SUqx0ofQIcG9VGA3bikPqHJw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.27";
        hash = "sha512-pS8rJDcDfy9w13QFp377HDMTWiNKRRgC9E/IRHaHL7M312DiQYsXXPshH7xA4KUSsAGmB5mq9CMuIogmKfdqwg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.27";
        hash = "sha512-2RenRLgxahJjKPZQullGEy9c2CYAZgRoUX+t6Jw4JTscBT3k+ZKU8WbAHZRZTUzzKwX6Izusls5HIgSFYdrujA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.27";
        hash = "sha512-GtnaJ/m0tOcO7UfTNbpn61+nsltZUPvcPixmIo+f3PhObSSzYJW5sFj7IjUCSzLXSyLiOxfZXC3Hi/2ghMwhxw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.27";
        hash = "sha512-hQHE7Jc59E4LxQvoubZGsQG4YJOVrTF6t7N4BLB+jmdxd+OyFOxK+C6AHjFNPxW43YVFsH27gUnHFr0bS9ixOA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.27";
        hash = "sha512-xPKIr8eBJ7TjzX24eSoAfwJObBymFhcnJeXfWWD4rSc+Y51wy4pBY8YMl3juCWKSa2XEflHB0noi33wShsedgg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.27";
        hash = "sha512-NRk3Z7uqDegJ0+V7lGRWbMw4Dq9h8T4lkfDzSqSSUuSFg88s/V9khYdUz8VMJkQx3apViTW4goepDlKVZxlPJQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.27";
        hash = "sha512-v1p5Sp+8HVR6usnULFRpvC0/BCTgdv4rR8gu/p79b3Owj2akPqb6onVXJ8cdr30m68jg8oRen6b2AFgRaR8pew==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.27";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.27";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.27/aspnetcore-runtime-8.0.27-linux-arm.tar.gz";
        hash = "sha512-9JVzU+ulJNSJDhKCSII3i0yYt/x9T+G5jtrC2NU43eKUFr0AIuPDXHJA7/rt8uDksg3XXW0dRbbzGRr1++GDMg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.27/aspnetcore-runtime-8.0.27-linux-arm64.tar.gz";
        hash = "sha512-X3bWGD5NXZD4Zyq8hlQ2YG7VUVk6dXceVrNSF5ekja3W9t4f+TwmJGYqxZeVp86KzXKYxd6ImxmLEG16ebjBFA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.27/aspnetcore-runtime-8.0.27-linux-x64.tar.gz";
        hash = "sha512-T5SK+RQjY2yKi72a0vnitZl7hOhO82cH4+MlDutPANC8mO0UQhUdGRO6IbsEdboq2y1tYyipPb5xBfLAvKKryQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.27/aspnetcore-runtime-8.0.27-linux-musl-arm.tar.gz";
        hash = "sha512-vRgCmQ+UtivBqZTuljI2pqv/eCk40/yqJ+nKvk0tqyhcyqwKFJBaPa+dD+GsEnN5A6n/u49tEJReu8TgJRTJLA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.27/aspnetcore-runtime-8.0.27-linux-musl-arm64.tar.gz";
        hash = "sha512-aU3oQWKt+1G+6OG6z/BlCwA8Lg2djruee8HtqqCyw/VoLilJ+Vk77snnFbKkItv4JsoQ2Ok/ldWhk4GAordtOw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.27/aspnetcore-runtime-8.0.27-linux-musl-x64.tar.gz";
        hash = "sha512-MwhSFqSrwfdw5UiNIGwIdpbJ1AUzP2ZcLch5hv37+dVJsQ1n7aiOsB5ifFSk/QV1Z2HjX0K/V2ria3ICnx1zYw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.27/aspnetcore-runtime-8.0.27-osx-arm64.tar.gz";
        hash = "sha512-PfVOaBw06GGqApF3RaEmvfawZo1NyQnK6SDRxLcl6ISxqhFVQlGjIruo51Lua2y7Gfa17anoMMQmtZBE4ywphA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.27/aspnetcore-runtime-8.0.27-osx-x64.tar.gz";
        hash = "sha512-pl4qysIVdbSPS+jU1PDxL8TFlw4X4lJ3+jacXHm8Jj/pyLidlHm4lCw1YcIipBin6e3ab4m60u+hRzgPoystRA==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.27";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.27/dotnet-runtime-8.0.27-linux-arm.tar.gz";
        hash = "sha512-SHMZ0zjfkBuCH6eBqiFZrpPRaV5KjUNblX9vudUXpK0L9Z87S5UE+zAROjjZQKlqGel/YZ0gQtk2yWV73Q5uhw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.27/dotnet-runtime-8.0.27-linux-arm64.tar.gz";
        hash = "sha512-nsMzIjbHXRy2r7DyiVA+ARqSV4v67NQT4IQqoo8Z5IbbW5popFswCN9g1VrXXWXsY27TlUPBGCuoFkM3jUs/hw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.27/dotnet-runtime-8.0.27-linux-x64.tar.gz";
        hash = "sha512-y+/+OhPS2MjG6kG4p2mJe0o8L0LY4L7AQoEL+k6anDsg+lOac5Rd4yTR35r6p0eeaW5KR/VI9CbiMQXhoDvoSw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.27/dotnet-runtime-8.0.27-linux-musl-arm.tar.gz";
        hash = "sha512-jLgdoR8cwR4Ejr15ttq3NGtLxLLwQKvXH8R61uDEf2rDDZtJV1VKSN+CVXlXmThbFfb3pHU/868QqNQAUcr2eA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.27/dotnet-runtime-8.0.27-linux-musl-arm64.tar.gz";
        hash = "sha512-M4UhvnVW2NA7gBfz5z1ODaxyl+6UbB5neda/lmatG2CmYjm8ZDjPYNZcOZFZG2OmYdxJZS6ieVJzWQsuyVMo4A==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.27/dotnet-runtime-8.0.27-linux-musl-x64.tar.gz";
        hash = "sha512-LnXfMCo0e5hjz7+iTBFTiw21hC78BrPbN9LDwuc32TuC0LDAOJofid+xBQq2o2h7jHOZzEhW5fSZBhbTlvMAOA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.27/dotnet-runtime-8.0.27-osx-arm64.tar.gz";
        hash = "sha512-aVqXB6HYts5ygjDFB1MmJto3pZpXIyplf9jOA/AqwXckb/vk9TnUxUUfqARgkBRxj9cjacpc+p3H8aDwvby0Zw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.27/dotnet-runtime-8.0.27-osx-x64.tar.gz";
        hash = "sha512-mkp7flXtvqtpfeurmXKBOJGX1IRc3JFsCvO9XKH53D1Em3abKwdLnJWuJzttYADj7iwaVRhV54m7io5DssCNBg==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.421";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.421/dotnet-sdk-8.0.421-linux-arm.tar.gz";
        hash = "sha512-JedfOT1jEWrhWkdgLFt3Pg7m4WJLFBRNmJnC/Rp6o2E2ieMmKm7sRnibZwONl0+eILWaSGSShOg341c3eu4O1Q==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.421/dotnet-sdk-8.0.421-linux-arm64.tar.gz";
        hash = "sha512-vPdHIZU0GdZ0gptbNoFU7eGdopYEE8JIXDjpxYeHScBVGiiC2JeboX0isFh7FRanj29laLSAaVRBknAYcd5/cw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.421/dotnet-sdk-8.0.421-linux-x64.tar.gz";
        hash = "sha512-O+4YqHBvFpF4omCczn0xpOw+Ia4HWMI4e5oHVtvCZzQrYM8AAkx2/pFRjklheyQfjr8eUss/pWRNpZZrdlibIg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.421/dotnet-sdk-8.0.421-linux-musl-arm.tar.gz";
        hash = "sha512-a4IRjxAusphSR2w57SyOl1wncYiIehWHj+YDFQ9LKgoyBglsn6j7J0R2Bb5n9Ius6jxJHWecNjU1xWY6L7So4Q==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.421/dotnet-sdk-8.0.421-linux-musl-arm64.tar.gz";
        hash = "sha512-+q1Z7WCcUCvQe4yuhXliY0XCGEwhdCYBQ2EqtO47qI0SEkK8I2KY8DZU834U9fD8xYX/R1r7VDbxr3JUkHbYqQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.421/dotnet-sdk-8.0.421-linux-musl-x64.tar.gz";
        hash = "sha512-5E9GtOmsRfduRpWUeEq0Z5QORrwVwMNwya9hwjmVu82l5sYpltJs3SA0p7f3GGgAkTyHZhGt6DQOp0HR9lp+Og==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.421/dotnet-sdk-8.0.421-osx-arm64.tar.gz";
        hash = "sha512-coGLrEFFmuEI3PnW/o8trbPzNEVN5sQOA8hOyWU8Xk98+tZMCzsIl7cgfOLTqKamhZE08ZK8lkFnnKbRvjlrZw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.421/dotnet-sdk-8.0.421-osx-x64.tar.gz";
        hash = "sha512-7LRNXs25w6q03ObngsKM1IWU5wFIJunfZhp4Axwv1aFitiJcdznNdWXsKbFKv2hEuFNdgP0E+lBvp9IS/ls3/w==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.127";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.127/dotnet-sdk-8.0.127-linux-arm.tar.gz";
        hash = "sha512-6aRNvsFENlZRjl4xQIZ0r4jkrIX9QSYy8duCeFOj+o/g9SU1YXQoqdMrELHtmlMkgIJAIMs3TbTD95d88Do7Ag==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.127/dotnet-sdk-8.0.127-linux-arm64.tar.gz";
        hash = "sha512-iLYKbh+GI4R4SOkx1JomKSjyoCxpyvu5oQE85p0Jv1iiNJ8JUnImDlnMsIAgzyFIEdhtBTWty3fPXWYOGVG7Rw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.127/dotnet-sdk-8.0.127-linux-x64.tar.gz";
        hash = "sha512-sZ2GGd0D5RasZnHgNR638ACTADlj7u9bs/BxY6TGZrFkHqWv1MFG3cpKOF8fxql8NxHgfwAjG34nrR/b1QL91Q==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.127/dotnet-sdk-8.0.127-linux-musl-arm.tar.gz";
        hash = "sha512-YIunZubRb3dl2cJuXbl9b3DJ5SOJdROMKgkMqbVr4kEPYT4FfdJcJ2qVcs60XVcXBOJn8pBcqyuba6MzbBkPQw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.127/dotnet-sdk-8.0.127-linux-musl-arm64.tar.gz";
        hash = "sha512-yAb5d6FOMIWRmUCIfkCba04qKq/vYxip76w78vx4g0PtXiJLuhBXvgEjt9QlpOFUDPnJ31QcSdlJ+BWNXs7mcA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.127/dotnet-sdk-8.0.127-linux-musl-x64.tar.gz";
        hash = "sha512-dnCGXZtKbE5GHpMtHwG8zul7yzHiul+7FAFYxPjio0wpWnI9DB62OW4vi+6/juJAtIzC6YKXN7zqZUXDx3+Pog==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.127/dotnet-sdk-8.0.127-osx-arm64.tar.gz";
        hash = "sha512-Da//WTe6RLlDX44ohM0cJxhUAMjVY5B+hLMbMdknDUviAplNZ9c3iC+DptGX8/zE3YuT0dLvd7FGlBj7rE74AA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.127/dotnet-sdk-8.0.127-osx-x64.tar.gz";
        hash = "sha512-ItkkWweADUn9Yg9T8gxQvG9wldlIVSy7kRK/BT0CONauiUtZnBgsq3rgqwAXaS/FbzsGLXkgeEdYOweJZ0RpEQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
