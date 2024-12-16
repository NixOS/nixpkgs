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
      version = "8.0.11";
      hash = "sha512-0ow+3BClZm2xlEXC7g+vr7vxmBkXnNwxjCSqhxCcPqRHkXYNW1rdHmzrCLmGYRzGFxk7wktqOUkRV0ipgSQXOw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.11";
      hash = "sha512-hRfXvd55c2xE9g3qOegrES0SkqFFKFid/wScWpANLT/yf6wEV6bn7c7cPrE/fyuw6MiaT86noYsGzj4WWezYuA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.11";
      hash = "sha512-oMIPTmsRuaFIosXYWzEHFCu2pQK0JdtkuQdT4j1szfZ8BVTHtYsBqWdjGV3u9uaWiJld6V7FanVVU+Z8HWFQ6Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.11";
      hash = "sha512-bknpGqBWIN0R0hiUU6VhrrCEY4T0P2F953t1AyPlt2LfzRij921w+I+zPhAlA3CRWDgq8ppX5iJTPhabnjrBSg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.11";
      hash = "sha512-QRSkkJ5ECtxL/pOBwqS2h+WY01Z5SYOLnL82cP6li8jpeP/h9TnClUjovMa5hk/ny3FM79J1cwIIwuSTGgv6kA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.11";
      hash = "sha512-mOgsZb1/yibFbb4nwVCvPk7KCa7S671zqjKdQGvwBxwr2vF20SW4Yw9me7bo9XMXHgR+25GlMnf3nKXkO/jgaw==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.11";
      hash = "sha512-MrWOJYbQCVUn4yAcAfRBekLNhAs/UPNlPOUCXq/HwTX0wLqT4Rcgg5MIlzA6w3QIGmLWHMh60QOmEFdUXjwghw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.11";
      hash = "sha512-BDUnx2LSv8CWK3WAbPnNWt7deVdLBn4VZ5ZNUSRg4WN/Wi1x+M4WQgd2yrW+qnSSR5ll9AKhWNUsiGVWf+OsaQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.11";
        hash = "sha512-vNLg/on8vgsoDhsYxvU724nX9g1vmD8/GaaTHpNr9953L3/hkmoyuXU6V4BL0iZsz/IDcRNs1cFlMqVHaDWzSw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.11";
        hash = "sha512-Fwm4IFjRnNtoHDEhwHcK5esu8kxznT+aZYRe7T5/7HHwaHOZYwnwVAb+1yG9zmpWsQAwVCy2Dy98T/KuraxY2Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.11";
        hash = "sha512-HCYA8CKNlcAdvJ7xJYPVMFyG2ZklrC/j7HJA5iNm0yI7IOtsBbrWbYbz8glc8h6gT4FrOAPu71IUot9Iika0EQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.11";
        hash = "sha512-JuZSeAmow4Xx9+VUnm7TYfSUU/p7l/SjSVoQKdoLdpOHSMm/pnSEOjHc4pKmAr4G6OS3dUgVY/IZyGxtS5g9VA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.11";
        hash = "sha512-9epOV/0PK9EYPPXLif6YwQo4O51muFM5iMVZOvOtTDYKN3MYlZcvwKMirJaAkvAhp5o71oRcfQcZc5srkvy4ZA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.11";
        hash = "sha512-Cm/rntnyMTnImcRzuL5VRpgN5AaoRElhyVi9Q+askyi0GnKX0Y6YPX/xmUIQcCCTOOzz6+i8xLBb85+oemUvGA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.11";
        hash = "sha512-BSaP3Yvv5DGh/fuoefbPtstxzyz0meQ6F3p33+3HO8YJwX34hSpuINdzUVsRKNoqWbCm4pHy8DmFh0dftCEwyQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.11";
        hash = "sha512-XJDQvhTRCV/7UTck+0WHM/YdGuXqvfYXBKv6pvvy7fOqrgv96ozy6XhkAZB1FT/ernqM7C4tBviPKg6u9sWfMw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.11";
        hash = "sha512-uOEs8EvkUOrCae/OGKy4Ek6zeY6HrjN0ppOK2VmcMsiwogP3XkkLjg6/grLiGvhMXbEpXUReSSGPd1wo48W/cg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.11";
        hash = "sha512-AjkGqrKxLuz0v+29koSdfx8l+9g8l7GCAe45nLvno1BWQaRJp0YZ0watG3Cs5UBQuOHz6QBTpxrtv21ABCn5AQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.11";
        hash = "sha512-+ONYpLs/Awwr0JhKj0uTlzV7Dz/w8JDcMWZn/IaODTyboFafxTcQx9zBvZGs2U8pAuDig5jA19tihfZfxtqPSg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.11";
        hash = "sha512-ICRHCPlohKZNi2Kxdy7VfHVDcY8GaWg9zapIvVwPbp8y+LIjEHSYBx920gftF+3+eNlOi0Vw4WIYGkBAKhgwzA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.11";
        hash = "sha512-9UR5zvygPAvdP92H+iGKqWRyUu1xawnnDo8p1N58mUpt67y6kPdDW4lHZzZg1nn61bgDvS/Wp+jQjmb2+x7ybQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.11";
        hash = "sha512-sOg03F0H7CjWTTFGDNfTsPq5pkziy6GcsAqdaANeh4sGRsRAeANFBp11ewAfk8P0fZVeWoRTaPtGjCZQ9dRpoQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.11";
        hash = "sha512-NXHH++Pg3fpeFWTISDya9f8JZIvxqdfE3Ebj6tWxmBu/pR5OpDiD6mEwyK6BKuANMYpEAD/mzo/tFzc51IOZEQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.11";
        hash = "sha512-NALt9Nbl6bu/f5ke11Cmc5tF8e3JkUXEzkJAfClel5zW6462xe/0WeqRrTg4MaaiDTga+ve/GYB7AXGrenyB/w==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.11";
        hash = "sha512-d+8q1xYCNc1PNYfHHzJJXRNHCRM/LnQlfs36LzxeaJzgx2LbBFRzxO/mUKSnDWMAP4i1P4BqqjZ7idjcIxV7uQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.11";
        hash = "sha512-ZDOVXgkXU+RSEV7lB/WSXkUpdczXANpMGuFToyVZJCuA41DwQwCZoJfVI9cXHStQUaEGn81HOfS6GQsRmEdjGg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.11";
        hash = "sha512-uEV87iNIuLAont7ESYEPOoF42ZmAlhmU20U3Lx5mwH7iaKt11VjuLeqvhxZKuSkL/ds1+ZzvLHhzAn0c2Z6JPA==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.11";
        hash = "sha512-qiP7GkxUqsROiAZ4NCgYbxP1PrvsTEyiNZZ1WC/MEexzj95xwTioAMbihGOzaB5neB3byZ1aZn9KZ8NA4wn6hQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.11";
        hash = "sha512-ukSAJJxyz+arYNuzXsP2om0or3f+d2cu1kHvWfe79JmaBzAmT3kBObCa3tYVsrtNZ4ck2g9fN4JnV8zsFvw/bg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.11";
        hash = "sha512-nATBKJ9/Suku621bOi+AVmQTRcVyyjGFOZattJROHnv3FsvrhY4hmuZXf8jNbKAgSgqYdHxLvgLX2bqBqzwKHQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.11";
        hash = "sha512-TI00Komhy29vOUv8/UC8RJNnSro7/X7rQ2J/8b4cCaVyRCYr7URV3cuuJYANasSV/lkjSoEuhpRXtnDCIUIYPQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.11";
        hash = "sha512-eLPVwuPLnr4PZagAVBlVJOH/P5QYCdb0nwbq+Y8N6pePLzeexQmKs8FrXjdWEdtDQOtsgm5Rvw/2Y9eWCXUYFA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.11";
        hash = "sha512-FqZlpdIhuhfAgzy7VC/r7xtiMML3hERUGXQ2rWxPgTArAo7puYXfPBjROmU1JYCXiaTd7uXBbrkSaFIbl9srwQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.11";
        hash = "sha512-rs+Z0i4ZMj/9oacyL3hyKgNm/2qRtC6NfAciF+vdaG9HxmAdGTooCOYZEJutKs8KByZn80eVKtxwtPNuRV/5wQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.11";
        hash = "sha512-TEN2ZHFkIvbQwl/tu7cskgdRzzrqEvhzB1zhkmtN3FKO9h2KvtQqEuOc3+sEZj2RHGqUYGFvT5JyiEp2jfK0xA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.11";
        hash = "sha512-z6lwljPpEYS90GGVG/SA5m2oYXU4Tjo1zMnrvHaPIHeFgHvEhij9QQHs9jNqlJX7ycsCrqPAuVQ8Auc/uW+0+A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.11";
        hash = "sha512-YpkUhlr8il3zMSVx/7Q9ZFl7CS3x/tcgdSI2wAXyoKxIw6NOj1l7ilEBdq2qJ1nPZFbgc5JfTUJTBMG6ahSzsA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.11";
        hash = "sha512-1A65EZfcbAjJ4sxycI+rke3saNMiWglG6NTxhZ5TEDRhlHy4l8Ft/GPnwofFBD5y8sDs5Hbs318q5XVbpqEL2A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.11";
        hash = "sha512-J2Yd5bSkcY7V1wRXmkR8pDxbiZBoPp9NOs1j9TJbJ0fDKaGxCq0pAneU7OXt+F57BM+4ZGbF9VaYCYw9M8h1dw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.11";
        hash = "sha512-k4fuLpGJEZF/X3kuUffTXMOUeq0JyANojJn63IpTeODTkXg17UhFgPy4CpnpHqfL+7PJYn5JHRY5WI5DZqG9vQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.11";
        hash = "sha512-RSuEuq0f1sjyXMQLoCykoFakvuztp0XsVwp1r5xTSvtUq1e5sYEIN5DK7hqFhVXCfb0TM7GkwsaHCmIAjgW7dQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.11";
        hash = "sha512-Uro1N0GVumpdj0SLieARjzuvnw+94i1TVK6jOmRZd4EZx3eJlHPD+d/HXjT4FOanVRg3LqlzjLZuMk5nNfJzHQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.11";
        hash = "sha512-qB2NfZk+EYPkLCRSXhVh6xnVsTAsXGBXcB55e7nKxB8d3+LDYOcYWy0L/njBZi/3oBbEFPhwTrTfVpiHLrmigA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.11";
        hash = "sha512-U3PF933HdVRLctSZQQHKwGGMqIVRikS5KM2IgIb5KH9zoXrzZCprAXJCvrZQDoOtaKOn+euyF+gy69CveB+gOw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.11";
        hash = "sha512-CYyQU33vn02h5xowEBEfRXIcLYm6GyXGhLmrDUJiHjJOZkAca1mbJZ39Fal/pEhzosnSN53Ld+HRGxe+9yijWg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.11";
        hash = "sha512-gQyj1KtYGgFJWTn4tTM1bH4xvTyVyk5pLCYZHlkYmfXwo1oDVvLrXiOC3rKdHxA+c8tRePJsNDIQKIAlJlmgAg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.11";
        hash = "sha512-bH0iaT0WlU2WXpStLFzqv2BsG8kVt5znYQ5S+7PGzZjTN8OSo9VfacgwL+NrP4yGZEir/RCqx5YRymm/ttKZUA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.11";
        hash = "sha512-RUhpon8Kanv+g0dP7DvXMIbJbxcQCrxgZZA8C4w/eRHvprvldOW9laat2DdF+c5Yxkz4gs1rarfX5Hys3hLCqw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.11";
        hash = "sha512-J2l2TxZcxtK8dHPdT0BZVlsf2dkPUvfq/PnkzprQBrePbvtTbpaGv6HYfShUHzUS6lAb8oPx8E36fj25T2TzYg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.11";
        hash = "sha512-Z8yrkHD415e1ZTpXvPTG19DkfR9DBafXwx2Bqmy6adx6maWlzZqrppk7IgfmCobas4nNnI1INBKXvDxxYm4Ziw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.11";
        hash = "sha512-rDMKYcBghoj2gWaUeWYZXNuNuO1HWbu9vEaHjyl6Y0o/OSIy2T3em3NZdc38OfG9dykCz4pgT9tdD6BZ7Ivwhw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.11";
        hash = "sha512-ensFnmyolPu1SHBFsxfnxrI+ldHqN6n62eS0+MXZ+kaMAfnyQtYT3u3NXWanHZHgXKdlV8+9+T2KvOpQUXdu3g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.11";
        hash = "sha512-DioWImEMGjRM4UN+7on+2VK7D/kv3vVGGaPAIoLNw3JYhJylj1Y2AqSd1uwQ9a3WGU/7amRAcTMX2p1/NMxWCQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.11";
        hash = "sha512-AB/BBjg1QmNjKix97nGsnyYALk3ABZAtqbkLTxKlC/GVuITZ05cQOKfKbbHLgYAiKZQtDPG/XMiEt7UTpm8BFQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.11";
        hash = "sha512-znw0LiorYDW0fCWwYQHiEwTRx5JrKrBfbPlwAKURJWq1YaLDy2eygO3hXlMdSLdMWkJlDPZpjcbqt5+mx7dBnQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.11";
        hash = "sha512-4lNoHmvKzqUpCZhUofSMITLANHj1UrAHtMHzUtcA9rHUuqi8WKOG6hAyVXp7qhNPaWTPWlwkwG1vyp89fhsqAg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.11";
        hash = "sha512-7wyt+/TT0T2EoPpqdLUbjvoVzGyzDtArThboeX7hYdx2J0Wh2O7821XIo/1XZoGUVI72wEVxX/mvylUgsNyrWQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.11";
        hash = "sha512-O1Kw599sjBL7neUB2rQU5fNveeFLm0QbBTIvzupfmKSPpON7MI9Ir28LJqwjFbSqhdO/9SYmpeTUzAJqsbGQjw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.11";
        hash = "sha512-KvNikPRuWtyDgZkbneySfA6MjX5VUfOwfq22GK5tRKc8xOtlsv08he6zx33Q8SW4ldu8f4K4uzMkO71EdQQmkQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.11";
        hash = "sha512-lPAmNTIsRdMcvaN7rjnkvVc9a56RuNrDMi3H6rKo0ZS06Njoee1BFDeQ5wuUDWnvaMxnAwxZH5wPKAvt6LdT3Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.11";
        hash = "sha512-+lz9eo9eSsaPNisaAeaUM7GtSaBilFyXnOFsVqt8nIn3tR/azvXAgzNj00Zy4QLJLiDMcr27eeNp8E7LKVI1mQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.11";
        hash = "sha512-9faK+Tt1Lh0cttVCwWxL3KTW8gPyi6uGBRGtEuexwB1HlyPuiHDlXXOWMCzDKTg4Bsj2NkkgZQ6R7KlWB/0xGQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.11";
        hash = "sha512-WpEunjmasr6EtDwl/Pts5pWq4XcgdOOX+qPtXrY5h+AnvEbagGGu7yTetroVy1yWkAXfWRxC2jp1KcPq+5b1Qg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.11";
        hash = "sha512-Wjx3q+xYAF1D62cjLodPV8k/i72yTKkQwYAUhXvlfdzddZvnkW18dWlw1twZm8TUx33JRbPAl8jokhEfnwPMQg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.11";
        hash = "sha512-1lU3Ir0DjkJyog5r/JZrFxzhSgQh/Mgt9fA216ixJyB3hwrDoi5H6mM49ORl6Y1K5gsFZFrYgT0ieB9y7B84KQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.11";
        hash = "sha512-SgTHU/z8LNomJAGsKH5HUvx5OizjB1WeqKsMzymgOubaRY7SgwH3mzrkO1ApZriU4UdDqr97pciMbxhlfaw89g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.11";
        hash = "sha512-2H8/Pdrzex0K/3zI1TMciRlgz7Z7od83gC9qk9Fm6UI8cElOjfd1uFP8Fry4hd77cfAFEGLOH08nhSYVnpMFnw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.11";
        hash = "sha512-IH1SXwkdekKugXK6ODphFR1MhQKkrBjFgt4zvCeKqL38sv7pfXLmGQOYBmstdxsSbV47VXcKzoi28E2TbOVi+g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.11";
        hash = "sha512-V4y3EK0FOhOJ0gNCgkH1zb0jajXi3G/1fTRLFjmHYwHJN1xLnEyBFcQxZ/iKXSl8KhDJIoCZhq6PgXxy5FCw6w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.11";
        hash = "sha512-HZojWDGgsYfjMvNvwOqSI7BQrH0nn8CqHNJH29z2kv2Xf95wqAZAxOeWoURYiPINHi9MC2/zgxYOQ/OvBOHhYQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.11";
        hash = "sha512-4ejFZQ55fKOR4efL+0zdjJNJgDsMbdLq/yahNWtaowMpVaIwCkb8crxZ5GnOFJbXm1QQ6iEWfw2n8PfHhXEbDA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.11";
        hash = "sha512-ZsS4BXtP1sl8vT9w4Zg4F1lnukUytSXjHALELUasI7tt5DthDPKfWb0ZPWxPOBIjqicx+fC6DrRlm5bLXxiAcQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.11";
        hash = "sha512-ieQVL36ljos0aLxaEUEZiVcNbpHFI0jXxkN6b5PEgl7FgI23wK21DfKCDjzLmSsq5Sc9KWTsjhGVZ113gRcT6g==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.11";
        hash = "sha512-djBsHftYzC802MFtYmZLn82/XcjKzVY+mV12PrfxrTqcyjw46HlY1ii5uJVQ0Bm4cbX7Oz1dHdzfDnpgAmQkYg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.11";
        hash = "sha512-Z7XeUhut6aToHi/cclEUICL45EdVBHv/rFjSPbz3/SARoDFoKia7wl3H61vKxpodTB2HmzFVmABTrdEF8N5uoA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.11";
        hash = "sha512-O0fvdSX/MwFSsueeQ7pM/jDagmwDi4V+J/utor3emVDtI8xjabav11icQJdM9HE0L62vppg1uT8IMUx9wuH1mg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.11";
        hash = "sha512-gjmmfG6V7HTSaVNvu06+NG+6/rH4Dpj7a4EM57MkRCEy3bNNVJ0S5DO8l6YveX3Ocx2k9XJtf8d2sRd9y+wyFQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.11";
        hash = "sha512-1in90CWWJXmQ25lJs8WLsmLTNqGhCg38qd7n1PcaJ+hGZbJDloeoxvrYgDMib94G7zkMUSCCpNQkLWdS+AZZcg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.11";
        hash = "sha512-rqZJszTVrJ1AKSMLpg8o0lvFeJv9sYlfMWu2VGlsxnVJ7bXhx3zUTdPizpkfXLEkumsJHIyzA0dAU9JxG4aGBw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.11";
        hash = "sha512-54Y0CX4mpsMWF9gybFTYSPlRY0yp5N27pCidIxZwh1QNZRJgRadMS2J6uYKSBP5UNHxX4CZ2bP3mg/VU2YGixQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.11";
        hash = "sha512-5fNhWcWZf6r9dQe/gv1nAxgyBPyXZ8I3ta8C86R3oz2+6tv2hxYDioVgnQ3/pfY2RbaRXz/bv6s3/dK6+rtQ+w==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.11";
        hash = "sha512-XCnfmeGZy/faPQMhAa6ZSm2ij3s7poqYEhGdbWEds1LjqO6WBB0KkqtMiYGotZ9jJRXFbzMBXaTmAFE65iOGYA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.11";
        hash = "sha512-zt3fmvA9clYIVjPsuFXfcB2nDpEkWYU2+5GsNPzTQSiyGfhWkXygGCLpbYvkpbXCH1q57Ax5Bxk/e1FR0Iipig==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.11";
        hash = "sha512-dvh/3bJAzZEwKTxzhLojdmFebW/iu/+AAAJH1FiYlZsT9684etdqWWn9vfuYPwqUBBXUTNLkPMH9iRJNPtPP1g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.11";
        hash = "sha512-IcNYQJJ/wyqMjoib08W0Rgcnk841akaWAwesG28QIElxSNC8z5yh1dSM3QtatbyOALhckoWkI5ymTyzn9SDGrA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.11";
        hash = "sha512-p4QIeC7fy4fjphQIKSQ5+ykhfVE3/b+QS1/UmVqVnU5z7ch9eUjvxlliqwTDjpqCCW0yOXuvNhw/AFPH677LTA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.11";
        hash = "sha512-Q7F6ADk8beaPyGTlVSBIRJLujUmrFOqZ9P4qnnXSUFLiOAZRTHv59KRT1en0P5L+sf0hNjI2ngDkZJ9+BwfHgw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.11";
        hash = "sha512-grFkU1QmSjuqeclCBBPjkw/SHMIHjie0khK010q6E7GpMzmHDNas3sB/hfEeheJ9q0hkuV9eFlGkHp5abHp1kw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.11";
        hash = "sha512-ha4JEhQExJugVmd4qMLi3Oot+NO5u9Vfqg5Cj/ndFoBq+qBQF88rsw0SqbmPbkpDJ9AW14sqgrWs1p4ixMIN6g==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.11";
        hash = "sha512-Z1yy2Lm+mF/pNfun1zTI4WcWfkB5J80pRbRY+Bi3zpVcuTYARaCIqqYCcs+RSsdGZyIsyxY5GCVtNnnS/Mr2gw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.11";
        hash = "sha512-UwOxMcccBMa+nayzQINw98K8TdOe2gtInabbUhAtPglu9mn5KFplImezdd5ZctE1YPuVrsa79abrTnY+eHdsXg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.11";
        hash = "sha512-afq9u/kUUNRlECwgdngwlaCEIJVYzdKzJZfjklHK9UBoK61OpmrIhXYfhSIAr6/yOlkoWeq5Hn7uPoLEDWxwnA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.11";
        hash = "sha512-0HUP7epr4Szr5mgx0UHtU/B5o1PcC4SuJPUrmCFVkua4gZ7liNd5In0GE5Tmbt53+bqT1C3NyD6v3Rqhqzi7EQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.11";
        hash = "sha512-8m49BIg9HtqZLxXt9N8rT/NlcUlLTaQMPHYzs2LbHMrlAXDatTVxZHW9lF312BBWjn1zQfAJqMtyibQtfmVKrg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.11";
        hash = "sha512-rCM/d2VWCY+GpW6nTlFPICc1rMyw+qM+67X7r5yJDOwGrNSqYz3xeqi7ewP+aXYmIoQV71Od+Jb86oqOB2SDXg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.11";
        hash = "sha512-PfwwvgpVmN83swqQhY4feqInM34XqsVbOeiXlKJEOgmwyKUj0cjHVidiu4HYBhy6jcOKla2uK25KTYebKqTx2Q==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.11";
        hash = "sha512-VkSu/oOIMPemlIf5ARuFXmmndocYjub5ut3/5JXAz5sSBKrpeWciGnsUDnnshaWHP3jK4JCj3TBds7heldom3Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.11";
        hash = "sha512-MmTlraMVCA4AWhuhG0ceYMOOjzCFLM5sydkoAUCLh43VoQOgzHMCa6BhxSzdXdcOuJ6VTHukMG72+NEm4TvL5w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.11";
        hash = "sha512-9gYW5whLNQolY5oTcOSv9cQxfHujDOOUXjorA/GMlOhTM1iXvzrBbPuWnDjFywYznZBkE0ZiYc1jVKQUKJ2D7w==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.11";
        hash = "sha512-+rAOixUutqpDATvg/QBxT1Wr5kAG0GOUWR1f3d7QjwTnzz2rQI7I2e+oDa+RYy0yMv0+Ih6AhHFuBC+52H2ZCA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.11";
        hash = "sha512-bhY1zLDtLxQf/DRCLy/V4/tXZGeBI0rWA7epKyItxfvlhEh77GOnmIc9VGyLH4B+WXNJFfWB/rTUhWGaJyzpww==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.11";
        hash = "sha512-NOZYMy4egQP04ohvziFDIRDEm1tHyMme4SCxWKh6y3BVHZ0BoENVryLq2Ko/DqoBuMF4tDjUFPi1bcofEl7Xtg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.11";
        hash = "sha512-wDwiNdA0vNfgwZgCe+a7FpbAiUENRcOoy3CUW7Y/5Kfc25qYWNONz9v2BfyBDLRYExth534ZpILww3QkPmsiaQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.11";
        hash = "sha512-eEgNGyaapr2MeHDmvfJuVPMavmtS7XdBd8xSgKWF64Yuo7mXoCtcgWzagG7BGDg65mW2vyFKE1iidZ9viVNbAQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.11";
        hash = "sha512-OPIUdM0ZFxcAzoVqJIy1qr4X6Tc8jQw8J1rsjrUL5iR24YGPT1kcSyC78G4S5F7kIRykjg8bnMRgLxiJ2B3THA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.11";
        hash = "sha512-KF5x+GlRfAUjPvNz02f4UrwuyWydvu8kSlKpZCxH0EArR1rOX+8jgpEZGJQxl7NzPSpbkPoRcvwTicX+s5jLrQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.11";
        hash = "sha512-BlTSt0qIs80/SxvdNEtiGl+kLn1ThEcKroQtc4gqoK3FPRIOyMFBfp9qEJZnVZdcDHVt7hGN1mPKUup+Qbesxw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.11";
        hash = "sha512-gGiAe5PJBNcmIRevQZnyBBM4KOgR+oLvMPGQxOvb5nGRxCXO41LnBtTQO+iZY8A6C4nBfD5pmis4+kluDbgxuA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.11";
        hash = "sha512-hZJfqP/8rnKc3jKJVLnAvcdsJzFIkFh80eBVatyeAGjUpp1I+lbmqGgnMbsWmA0Av4kBtylpmrv09ZId1g0GjA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.11";
        hash = "sha512-UW/jpK2X+Wvpj/lymy/31jZBQK+Q7oTSeNUxMZxEiv/1sk740ah4kGYsxVSlQmx+D6M2T+Yn/JCYgCBEDaTfug==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.11";
        hash = "sha512-Zxw2Fnc7jzpqT0M36wTYAeqJ1qZKXrStOBfjKY3OYMfGIsLd10dEwiHYcNAKbDlzmOFxU7UlZoxWcBCz1pMFag==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.11";
        hash = "sha512-Kr/G3KP5rXMURU82OJ0jSTCweYg3vnCcUXk6D+SvR64JYEC0DC5x5nDnMLnbTulB4S4NRJvFClVwFUzTJyzc6g==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.11";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.11";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/003f180b-e695-4094-bc3f-ef6473883d43/e861cb56edd58b05b03b5a92cf995f12/aspnetcore-runtime-8.0.11-linux-arm.tar.gz";
        hash = "sha512-dmRfEpRlNGxd58VDvqU4KSKKmRKXHEWa5IJDMXxz9H3sI9e1LX2U/zxwG40t5lHzN13qs4EA+XvoH1d8O4zOHw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/64a9f696-b039-4a73-b705-288fbf9c2e8f/c36bc24d6d359c019408b4f94ee67b59/aspnetcore-runtime-8.0.11-linux-arm64.tar.gz";
        hash = "sha512-dbWIi31lz56XGSXkiWLAgi9jA5Cj8PBM4dhFRpkP7TEuiuhRPILK6toUXCrI3isin9Ha0tLfNsjp2w359lWVrA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6f89757c-3dde-4c3a-96a0-b04b1bde2c92/6a3591b360ed0f9d1118b97560b89625/aspnetcore-runtime-8.0.11-linux-x64.tar.gz";
        hash = "sha512-56z53Fz6Sap+ww27lYa8e+qsnjEWx1MDtRF3DjWXsglznyjHVLIQfAJVrKyQGHzRAAwe53JGP8gok0pN2jX1ww==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/915433cc-c272-42c4-8599-e4dad1f37169/fb50da250331d885f108ef5147a55383/aspnetcore-runtime-8.0.11-linux-musl-arm.tar.gz";
        hash = "sha512-B0gkLqy8R5U2lOGWVUy6FNkfww15f+afkEUEpwUigEXsRssN4ZVFIIzK10JoLUNZIfslMsI7W76CKV/uCAT7qQ==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/52d8da68-2c23-462b-8714-947d9c92f4c1/e57551e568e148dc30c3301382a0076f/aspnetcore-runtime-8.0.11-linux-musl-arm64.tar.gz";
        hash = "sha512-hiynzzSelFQgOhOJq4UoPJGhBNfWtwrmbDm31BOjUd8gde26UgZzFTEQueutFYAbayKE2vsiva+TVVuWQ2ffQA==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2c532eff-49e5-4177-9d37-54e1eabc1a6c/7cd1d4612b9bd15ccb555bc2a3ada721/aspnetcore-runtime-8.0.11-linux-musl-x64.tar.gz";
        hash = "sha512-kSDvDKwgAv7+5KuQD8AIX7VtyuWFZ8+Pj2HwT29WI9yZXPuo9twsYfpNlt2jou4O3IUwtA/bwW0mrvW6MnIcTQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/67a3d635-a541-43c4-88ce-6f7882908693/5701a1609eb7231e65fc4e415cd9f2b8/aspnetcore-runtime-8.0.11-osx-arm64.tar.gz";
        hash = "sha512-ay0+tY13i2P5gqDVdTlzhqbQf8pknxuU3fCPxE6YhN9UdCqguChUzVlBIJhKOcYsecFUYviYTNwEGIVC3LYSwQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2e82f0c0-2d31-4fdf-b289-ae4157be0304/c82a8ccd41f2aa7918c7f888df1a40e5/aspnetcore-runtime-8.0.11-osx-x64.tar.gz";
        hash = "sha512-k+TxKd3fsVPyQYN1kmbQ0kohMefycjYbwF57G1UHHBxqLgN196ogQicSyFySJgfo4jRC65JB7nNgjS8gFcfcVA==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.11";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b4d8f2f3-a0fd-4d48-b584-cae2c3af5c06/97479f98b5746e515d7d99f72b67c852/dotnet-runtime-8.0.11-linux-arm.tar.gz";
        hash = "sha512-J5uTv2tcXC9FQntiDFa/8OIuyPP7mk83SeemoNDQ7oFjhRtb0IHGgUt1gGjfe6G5QByES6WQWyeoMAIIRu9kBg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/501c5677-1a80-4232-9223-2c1ad336a304/867b5afc628837835a409cf4f465211d/dotnet-runtime-8.0.11-linux-arm64.tar.gz";
        hash = "sha512-8n1m3N0kmmovhyQbRgI4lgJA0WP/wIHY57Qr1icCB58aZ4TjUD29Tqj56BbYIUL8gpx1nL+aFoKwNA8M6+FttQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/805cdca8-ac43-4d76-8ce8-efd11f1997f2/17aeb8b0cd34c6f8d80217bf6a4ed3cd/dotnet-runtime-8.0.11-linux-x64.tar.gz";
        hash = "sha512-cepSiQDG/HtU6VFiIpZCHSqWGRhwxH6TcRe4Syj5G/QH0CBG3f7P5Kw33GGCxl0ZQJJ8M+Rfo9bwF5+BaSSQ1g==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a7c1c05c-3295-4564-92d2-896f35807f4c/2eda12f650084627e0430a52477a98b9/dotnet-runtime-8.0.11-linux-musl-arm.tar.gz";
        hash = "sha512-4p7HxMEj3r+xwgqknszby2xJOgvKjUgMET0OQTsrVG7QF2exBW3aSw9YApwUf1E8OvlWadKcsrq9vaTTWLLQ/Q==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/103ae393-f13f-4467-a050-cb437a0fc95d/49e6ee2de95017554e161b7048746a29/dotnet-runtime-8.0.11-linux-musl-arm64.tar.gz";
        hash = "sha512-apTOiI6wYPY6DslVSYUZjEjFxWEld9t8ECBLWLLvNu+WpZcGfXVXSr3KYah0cpFLXfMxK+dHc6wy+nBD1gNw2A==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/38650024-417b-4fe4-b0b3-aff0ad98dee2/a48665c0f7099dd0672e6c277f5e5064/dotnet-runtime-8.0.11-linux-musl-x64.tar.gz";
        hash = "sha512-/wDRnO1+ogTKzMbBHEhOWh7Nuf+prJprjtL398kImq0JjltB0uvlwky7wJVt9kAyti7XJ3+sPTtkt0LFAgm+YQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e5b4d32a-09a7-4028-accb-3b6c51828282/e4ecc94db4507f16a9916dc3be9b6706/dotnet-runtime-8.0.11-osx-arm64.tar.gz";
        hash = "sha512-LhXZOqWVFvLnefDC88e1Dv48RUfVRr/70dryP6ZQPWk2SbKpNV4DiLcIni3gcue4hKsEs4rWZUSuXJfC8gidHA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f32ae8ed-e8e3-4d1b-8425-852696e4dbe6/1f67d82ebd50b27574ccc4a06b2500b8/dotnet-runtime-8.0.11-osx-x64.tar.gz";
        hash = "sha512-wtAIyscrGZnqka1UDARAKqjCxVuZKoUHadOczq61Y09vfwTR27ylG92eEvBF/uMVtla1hTC1etL2FIDsrcyj0w==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.404";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/44135b0f-e6d4-4e48-831b-fcd32c06a17f/b5dd8932aac6655a1ebd99ea9f24cc76/dotnet-sdk-8.0.404-linux-arm.tar.gz";
        hash = "sha512-SJ1h47AuSe9vNBb/4mdeByrn2cP8Q/rAidNz5CvFeAeTfS1qdxfaoh8iWxFE9yDw0V9jJGDfsU0K0q24CI3k0Q==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5ac82fcb-c260-4c46-b62f-8cde2ddfc625/feb12fc704a476ea2227c57c81d18cdf/dotnet-sdk-8.0.404-linux-arm64.tar.gz";
        hash = "sha512-0UfKLmqti8dRtSKukTmeDjhnxC0X+JLiPI3QhqtsywwTMZ2bicAktaYf+ymOlbz8gtklYHTdrOiCFFydWkvgcQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4e3b04aa-c015-4e06-a42e-05f9f3c54ed2/74d1bb68e330eea13ecfc47f7cf9aeb7/dotnet-sdk-8.0.404-linux-x64.tar.gz";
        hash = "sha512-LxZvfzvVCBVNctF4P/rG4OPJICPMwsbeSdIrQR/IuebdA+dXaswbtYcKaVEYESm6d/O/lLtF/pxwEFsbiWubuQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8f5680df-0666-4ec6-a3ca-3ab9897b493a/178bd00a6a8f7ff3e10ffb4e01490e7b/dotnet-sdk-8.0.404-linux-musl-arm.tar.gz";
        hash = "sha512-syuih+oQdbz8S1TPYCffsaV2cbttri+NfUWrWwINQqyIZcU6v2gn3ukQ3LOkHbq/dSjNxoGxp1psTJ/cXcs3CA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e39138a8-4431-4cff-a00f-482c28df9639/9d5c2633624007715fa7312f42155272/dotnet-sdk-8.0.404-linux-musl-arm64.tar.gz";
        hash = "sha512-LCy68XYHU51nZHtHJL1uEfHQD2F8mMRAjslHwfKq5HTdO7AV0Lw5IS7u/p/NvyDmrpVwCKrpDHIL7sDrx3mM6Q==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a42bdfda-e5d6-40ac-93c0-b6899fd39324/59e918476a837f928a5ec3f21efc438f/dotnet-sdk-8.0.404-linux-musl-x64.tar.gz";
        hash = "sha512-5to7QF2GLzHXkPUZcW8IJ6BY41gK/gnREDUivkLlbC4r4egAuU26lAM0WFt4Xqtho4vtAjI2lcpEBwh+bAy59g==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e8f412c0-1701-4096-9aa7-48d65d11ae67/cec57d5bd873f28b6f33da25915cce9c/dotnet-sdk-8.0.404-osx-arm64.tar.gz";
        hash = "sha512-ZHZTGmO/S8x73eL1own6Kykgu2MOCPoKrqvWV4u4HVNLHdO60hRhf3K1VVpJpWuex3BibWQSLacHbfwT8MVsvA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/016c2c95-c728-46ce-b227-d5dcc1c29f43/b4d6d9662623bfef39abf79711793f32/dotnet-sdk-8.0.404-osx-x64.tar.gz";
        hash = "sha512-ImkSnoHWbNDLteGvEYXLWsEyTOia60Ft22ykbGVZzCyiI4ZLyn+IzMa6NPcsl/9H+nzxoXpZCMr8TXx3JUEumQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_3xx = buildNetSdk {
    version = "8.0.307";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b2ea74cf-71db-4938-8e67-0a5ba0e8dde2/77b8bcb3f156cba40b28a6bcda7259d7/dotnet-sdk-8.0.307-linux-arm.tar.gz";
        hash = "sha512-kpgb3Nz9GE215AEgLjfWqoQ4O1I2dADib7JcCLdd6LarCW5XXXMESn1SMMXUeAAavOTa8ooa+zcqwjRlJTgOTg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/78966954-6f88-4240-a857-e88592469928/fa48764c7075b3eae626e5df5b27bcb9/dotnet-sdk-8.0.307-linux-arm64.tar.gz";
        hash = "sha512-XTuZK1JfPvi+X69nN410VyEOuBRSxqQJDcxgVnR3l4SAvhgNBIhhZaSjNFRkIbrFxFoNjW75tA0Md80tXm/N5w==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/645e379a-4222-48c0-b47d-f85719ff91db/2d46079600e454c634eaeca43a54ab31/dotnet-sdk-8.0.307-linux-x64.tar.gz";
        hash = "sha512-lJI6XMIze1Mb073wjJnnFp7NTIGmOiuM4gT7CHxOtSZpUhj8djhg6ikwQmwrMcIyjfEzcNZCF9N1GYuT/fBMnQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4cb9611e-2d70-4721-b76f-7e4af40c1ae8/75a00daccd28df34a5cf7f21287c2c29/dotnet-sdk-8.0.307-linux-musl-arm.tar.gz";
        hash = "sha512-wzz7No1d/2TfqtVIL+21mTUJxkxlnwj59Iq2Vbt2kx7Re88PIFOkYogg5ciC/T+Hbj7wElxoNiXG8op2B+Y7+g==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2cf301af-8fb8-4bf8-a79c-0fd1ad5ba601/b336f2e5a7091c9dbffdf69833ccde58/dotnet-sdk-8.0.307-linux-musl-arm64.tar.gz";
        hash = "sha512-UBos77oTBD8K4dlgm8MpLaIXlA9THi9nJ3wHON52aSJS14E9y6cG7cKiD0ap/naVDHwYAyRm6Oj7SCTnrW/v9Q==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ef349e2c-79f8-4688-a79a-3236e75b2868/fef58217ba703f880cb5ad02e22976b4/dotnet-sdk-8.0.307-linux-musl-x64.tar.gz";
        hash = "sha512-JSVzy31AEopBORQUjDl0wQW6fIueAye0piW3o+MVQXe+vb/UicJJP7FPq8CXwWGrT8mKTyanNKX9DJkj9bPLgA==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6a89189f-3449-4e54-ac20-d07af68b772e/ce34a179d9bb8bb0cb01781afd662bf7/dotnet-sdk-8.0.307-osx-arm64.tar.gz";
        hash = "sha512-xSLZ4iMh0ES7tEfvJIabEldT0iZ6XdU4cFm+CZ031+mBs4EDxN5pUhAnSyxAom7b+GWMg4wm0gtE8x9SG0W11Q==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/7dbf9674-4262-4b44-bd3e-12a962f2831a/b25b3c126ad41eda494855168f8104fe/dotnet-sdk-8.0.307-osx-x64.tar.gz";
        hash = "sha512-yT1+pQXD1+GrAko7ARDr3WgyxYK24/gHkLzBVVTgOfqq9WyaK2R7vNJcEm7tJIcXCLuWQLR5BFLO2Z3Rca0V1Q==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.111";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0aca42a5-6e85-43e4-8fed-0a5af898c82d/0ee32409bad9aec0608e1bcf2f767a32/dotnet-sdk-8.0.111-linux-arm.tar.gz";
        hash = "sha512-Lw32CwWHjgLBaFXElC6PR/CaNWxZi1WEbKO4bppaSQDndP11rWmADaKZDRbm1PFu3MU+X9m7BpmOtKvg2p0shg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c6a51c8e-3dbe-4f8b-a642-6e4be0ea0171/e98afd2817656cd96445fed528776661/dotnet-sdk-8.0.111-linux-arm64.tar.gz";
        hash = "sha512-mtGoNJ1MtlL76Z6ytWsscU8Ju0nswjGNhZch7b0MLB5fM4RE6h7m3S8C59EBvODTyVaRMxJncDcFlkR3lJilTw==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/71b9adff-5d7d-4567-aba4-d0da010e293f/88bd38320ab4a4524e71aec64bf88676/dotnet-sdk-8.0.111-linux-x64.tar.gz";
        hash = "sha512-5G45p3Gyl0Tc5mWofNUyLfqRKrKQS8wQ8FB9/PTKBWhM9kw04SxwhK9Jp4TMBOtTKjrSvkzrZoF2NH/rS+N/gQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/23273a60-23a0-4fbd-8ffb-8eddb2880ee2/65a67bebc6cc7d85fde858fb501e5c4d/dotnet-sdk-8.0.111-linux-musl-arm.tar.gz";
        hash = "sha512-KX+iiMjBdOwWrp13VBFmioJ70iJ3cisPKIXuYJfAqCfZ81w0BSzlipDxbU/uyr5zjGPxyQKzqP6jZ3GjveSvvg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/60fc0fcc-1f82-497f-8ed2-89b75ef19388/d78cb2271cfa396e119dacb534a0e8bb/dotnet-sdk-8.0.111-linux-musl-arm64.tar.gz";
        hash = "sha512-fNb6Mz/BleX1UVu2dbhuwxYKTRqCxolrOdBHebsdKqhndJjqcqfT6Fq8CGRlUtNhonfZpvuMQYr3B335TyrgOg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6b36b2f4-0a10-40a8-96b6-b222860f9820/22605ad401868ae796ec1911984c46a5/dotnet-sdk-8.0.111-linux-musl-x64.tar.gz";
        hash = "sha512-pRdTdDsBRQYPfbF8M6RwjaBfH/ftoEOunzmjx0xadVN9AW6M1rGBisLQPtANNTm0oc/0s2BySgmCK6qKiW+SAg==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/92958c4d-e15c-4554-9ab7-b6b251fa95e0/d931778a5156b6d739583cd1af0139d8/dotnet-sdk-8.0.111-osx-arm64.tar.gz";
        hash = "sha512-tH//G/XZ4rXKe2hNcqBQTDzPizN0uNei445Bci9+EXSAAfzTRI5iYBS5/KeAgr/tnA5G9asUGmRkIevCGRuaWw==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2c694b43-e8e5-49b4-a26b-a8d1850d8974/aacd6da4f057a37d12074b076368eda6/dotnet-sdk-8.0.111-osx-x64.tar.gz";
        hash = "sha512-QZ8qZeVxRTexhWkcmnFSq9Tl+F9uWAZghuPzQepPFuD1ZL/cZM3B54djqMO4crds7CXL93/PZl19dIGcYf3Jag==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
