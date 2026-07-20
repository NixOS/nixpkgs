{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "9.0.17";
      hash = "sha512-DxIcIxpeCC1Kwc9axm0J6EWHwWKU96skAagyUA94KsEaSHzhkbW3EUnx2R9i1VRpPG47ZWvlTqQBmLEkoZ/dLw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.17";
      hash = "sha512-2aEAXr4pylUAaTAfwkFVMjBOWZwlsrmsd5GXRRO1OP7Tx4dfRWnwD70g+qhTGkioWp27cfBg5xjLil72msYC9g==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.17";
      hash = "sha512-9zSkFcQZl/9ApmpN2xxTewMchmlBpbwaASbOk38qd3R0zwBm3fkt81mtfb8DQwMH551TEF9khKiyWquO20R4wA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.17";
      hash = "sha512-6qOF7QnVuxUq+Wb81sDWQN4LnWWzmyAgvI0V8ot2dX73HUqi2bPLtuuHaYT09rnghTmXF5Gj6yQPFMvijhR1VA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.17";
      hash = "sha512-3+NwczDPlHGYL1Akidm9gvd/5NzWqhNcfUY8Tqv9YOLNEjJRfBBdi+8ZV9klbreFhiG+bgLZDIQ0/4pGfLoG1Q==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.17";
        hash = "sha512-MM86H0AUunMeWK5mepgeCLsqiWaLom+teUyRn74zu5MPIyUuXQy4uGPasrzGhs9sH7k/PBlZisojBn/RX8fIQA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.17";
        hash = "sha512-i8mMBlJy6rbkR1CA3Z685XiiPrZ6tVa34wil9f4PN+dPIdmYYMR7e98ps8T/UY0e2D2iiXqpFtO+oS27UtqpcA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.17";
        hash = "sha512-dT8n5W4efuyvElpZ4MUGU+Urvp2ryyJKN3nRasbS6vlUynuDxR9vnYplXcwx1+WNnXiq5Td9FndJFjmiqEa37Q==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.17";
        hash = "sha512-bmDFH0ZS1fcGv6RuLRO8ibRBlPB0FFbrXBVhoWfAqzmrZCOPyG9chYbfjOwXTxGa8Ms6r+6BmVkX1vnJ6d0yZg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.17";
        hash = "sha512-v8Ia2eGjQRp1TsG9OC93/GWJ0mJOpRYQWtaSh9nBVDttSHUzcmonU/2TQi6zubN/Mj7jxFgDZe/p0uxU5fnirw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.17";
        hash = "sha512-K9dCZnohNgRieyLljhtgF5ySVstg7KvBsrGA4A6GNArFtDjFclRTiS7u7BH2v5AvkEtg7dNolRxHVJ0O6wSO1w==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.17";
        hash = "sha512-DiW59jRET2h0XKl9xagZOWyk2cBGg44PqS/6Vi1nqNNuKaUIezfCRrmp0/gUTYaJTnyNj7y+HyUgQ3zM0sDETA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.17";
        hash = "sha512-iUtqQlN+czkG4AMJLi5KgmKR4rzgV5OtWxBRMrmFoNfHHRNwSbMgHDVSwiRbLXxlNc2u1MVc3OvHhkOQhUPbhQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.17";
        hash = "sha512-hHpFZjzJoF7Ggqk8OdrqmPM9vbxV+9gDePJQPgqul6vIT2L8mtYwoPCBg5eSg5VUMZU1/2s28QcQXxxWGTeBCg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.17";
        hash = "sha512-ykqJOS3ztsCaWA9DkoKiI9qLSrMRh2Aw3KqbYO7Q8D/AcdHDn6ZU/uWwZRynOlyltwpB3Van7Tr4pN1v6kaa/g==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.17";
        hash = "sha512-uZwBaiOGUxQl4c9royJvKRqyFazF8L6Dn4agHhJEr4yS2/fNDnwu5Nmw01P3C7Xis6G9dTjCFWgkoF01I4FsXA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.17";
        hash = "sha512-gj5mqE6mUnMt39u0kAACDVi2BHxROgJtH6NMu3xR1i69dyAVLyRjZue7+Yw+9PWzzl/GE1zprfF59aoJzMIwYg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.17";
        hash = "sha512-e2mX6Wg7KPKibfLLdyYO/LUKUrpLrnHAGtzIaFP3IEzRhfQFcp0unkf1MG9zkgzPYpuOu1g6iF8YsKdnmFjuzg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.17";
        hash = "sha512-29zjTIv3z8396D8o0nYPcOA8OcBZUu229Q/RCrNqAF60jW+WBgeaaw32F8Dk6nFgFDT8B4y9aR5Iovh7i8VRsw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.17";
        hash = "sha512-benR3++HMuzFnl7rxtemVFjTp1xj+AfXkD/wrN/E4FM9BOPea6xCNzAk+gdKKBbCa4ODHmu6KaviTSdm4IQCtQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.17";
        hash = "sha512-0yHaUkWroxe7i8hOtgY4w8TFo+fXma0EooDDSMwDbpBA7Cw0pHEWRuRyp+JdWGFlBfEEqJUrRZJedMud9lkpAA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.17";
        hash = "sha512-bX9s5H8EDV5MokjVYJmm90lnEX+Vghd0JbPBGVFzKJQJ6TQ5I13c+nZSGer/riVZ2is+IAujCeI3gyNkXoB0qQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.17";
        hash = "sha512-QwqGKfJoNwRjJ08V0c+Ji/+kYBLUDCOcjjHhxj65mS5n412pQAxo5zwPkoyAh/Df9ffi/X/HFXClheP05xTxng==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.17";
        hash = "sha512-/+kkFv7ge85To0pCjZe2Hps/hB3rAvNrKj14c8WDd370xXn4dVBf+pThEz0ga7ODCzKWKc3tBmD0MlPqcckXfg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.17";
        hash = "sha512-8t2U7pCwj5Tjd53uS+4QxL7c6zXt7kVwEJO3NxWQ+gy62muj3200FqyxfTEtwexRF2DKyaLWJ+4yWEp8br+1vg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.17";
        hash = "sha512-QjOSj70h1TdSUtbFm6aBCHHX0tjj8qyFzuHegPvsefMLLO8yjsAAP1waelkEXQHJoLVbyW5CoQoaSEpoAeAtLA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.17";
        hash = "sha512-ujYwG0nP2T5o3EO0oMysjRW8pYnsv2oyVZmDOKaKgl1rv2ccx0tkl2XWr3cd14mMnKoZ53B6IOp538OIu4ehBA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.17";
        hash = "sha512-Jtz0dWS3D8qqAE5UW/GUO1+WS0om10CEhfHYofDh4awErKy429p+fVwchfopgDU3MajuR7qNufjDDHwO/+n8Jg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.17";
        hash = "sha512-1sBIS6pBipMSKlRpH4caGUopxD4peQlsDumGhpHcthmh338LCecP8Nk9uRIs0oke7JXKwV/OX4Xe6HrETCK38Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.17";
        hash = "sha512-ykNuYIqzePEwqBngXh9aovGxW0n2FWuBJvq3bYMzBBNet9upZlXmN8/S+PEGNOpMyc1LSIxm6eMTxd+dYBDoQg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.17";
        hash = "sha512-grKg4od2++Et8RDvjyDZCmP+9d7wBAtKPTDYUo/NxOEFgGefBKT5P3Ga0I0KWrrkb4rBoHpz+9bFkpLVhQLgWQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.17";
        hash = "sha512-3pt0O0fLiYX2rtOz2MQacbESmSIuu89wMtSS7C9okSGlI0EZaAAHZd1i1OgmRzHcJOKYjVELMQN6P6eCOmTZpA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.17";
        hash = "sha512-8VRhMTM1oBHuDqG6i3pcYRqFstZrqTDmrDfvZHUofBIpU3PCzq+kXSwSkIM940wNYsFcKvM0moySc+3pSyL7OA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.17";
        hash = "sha512-Suz+rstUCppQuKXTZWuUrJyo70Rnw6cmSTLq3Z17ZJFrz0lcq7tZC8nWloYSI9Of5sR8qcAsxLIlhzbind0HSQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.17";
        hash = "sha512-8MAZRJi1KxVu1OxdfpvLBL5p6uq6k0Nqbrh+xKlXs86YY7AajkPJ9KMkT2ArfL0xEZdYiRyg+fBaca06RH0kYQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.17";
        hash = "sha512-bBYC3Gy6ji7lQlYzoCIqZcY5ZHK5rfz170TjTw7pszV2481sTH9oYL542QF4ZQFOmk76DqJOMsEJ3NsGAG/RIA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.17";
        hash = "sha512-kRjr0Z+ciq02SeaKwdPvaA8r/G842NhElNItGrCwVneIxztfrfX6WbAY8ojsfhYSgXbL+hD/BejP25EkJVkaQw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.17";
        hash = "sha512-gXSec9ogCj/hIPMC6qamdQAv3JB33igkopNpvpYDPrLXDsQ3mjmezwGHrRaPwnntXcLaQHHEYcfAxzSvFgZcuA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.17";
        hash = "sha512-BVxi6YotaOx3Vq+0rjoVX2TOJlE4Z3DJzD0ISFMc+oqH1kYw/wAQonimiLU/L4sUa5X9wZBLm0IK5bf6H2L2ew==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.17";
        hash = "sha512-uWrr4NNEwbIo805hKsmYOOEjuLJSPrJTcc3RfuGYHByfkxvzWFPrFmtOx0aGdVbyyUaNB9FCE06lp8ai7vZspw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.17";
        hash = "sha512-2tlGhD1pyaMNih1V4BcrzBGN/njVRQZrmVywgDQXT5U44rGBgpheV8wOIIWya138MeZBiuByrGExMr0Vb0kTSA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.17";
        hash = "sha512-2RcD4Jz+5ODsKm5lgAk/7H1O/jDyfUH/0D5GMae6KyPWK2qkj6ATBvpXN4N+tGvZMzpnK0Buq8DSRyjcuJ+qgw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.17";
        hash = "sha512-imrVPetou3ZS4qQ05e1q1C0CfmZEb5fWHneussmW90hBMvJyzdQL05Liitqx8IB4+Ed6V5iDfiXHIirxyRMznA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.17";
        hash = "sha512-NFKviiR2mjYW8KsW7UQoukw/slr4Ktr94fjT0BrgnM5LkyizmvNGh+SWrBwt2JILJTf1ehBt+9h7LKPOo5Hkaw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.17";
        hash = "sha512-RTbLUos8ArVdEkJai/lC7SI7YlyPgjMyz3JuA5N1xMPnGCWTjCkwi5BZlyNEMwrnLCPhvh8VbEFcL70SWTppyw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.17";
        hash = "sha512-kG4nwxsNdIMaDWAFcQW6mDJYZzBJOep2787qQg4iiqJpo7I8bI0EfiGt9J69BFfaPhbAKVgF5RrQjH73j3m/9A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.17";
        hash = "sha512-hO0BvwQW9Ap4veRGtvUhn/8qT1ywsyredr2PM+X+4lSLDGqpjowvd6CI83oKODHHa6J+v2U/q28jtLxsnkkYvw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.17";
        hash = "sha512-CyBrJ8mOKZ6c3yi5jsMS8ce4NekG5X2HG81BqObC48AKUL1yGDgbda0LmPJ8SskFqUGDtg3onHlPqOpU+/Pxyg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.17";
        hash = "sha512-NGcFXzs61HnI1xLspKNkd7Yz7KY4vZjAJY4gKW+H05ZhKKYG6hjYE+tr+negiK9qJ8rjIhTNFZJwOF1EE4gaEw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.17";
        hash = "sha512-n3V9NdOjTD5OAgKuL5Chi/QSoOeRNugC1NOtFjeAyAw6oZdABkxBFULjwQCpfNlmPVUioJIiaI1aOB2DXD3NLw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.17";
        hash = "sha512-9Y+KohhgUisoFHy7hT3dSoHu4Tu0xxxvwbCWFbUJZu/QpuYvqdZFip7hg/KSOoPOhHP5Vuf9h/AFePjLzZDJqA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.17";
        hash = "sha512-T1rWlgVcZgE7gY2DeCQXa54CyFTo9+UbTn9SRFOBhg1b6u0wuxR0nifwOmh69f3fGej1jTWixzFCRw/gpUCwRg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.17";
        hash = "sha512-/TXj4s0Blx/7TtJ/Q04Dwyou/+WNw6ukxGv+253Ptk8y8OKqsdotu5GbZ0Oq6dUfkZpmiOx/s7w/dyokGGmZ0Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.17";
        hash = "sha512-FmCInGb+XKP7qfRaLc7Te95MCtlOpLmor1+53v64b65llmsdWKTNvZ1QneZ122k/f28Mnuk6vwvAKTOMMu2wvA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.17";
        hash = "sha512-TDrpPgoviXR8Tyt9cOt60h9J58YSYU6o3AK4px7ipogwzdy5P6mxYdc6JmAJ9bIxadtLJVk8eIRy4Xk8pG9Wbg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.17";
        hash = "sha512-GSeVR3DisnR2n1Z4zgA09LRuhWPFN2nDVXZI4+bFHhd/WUTBdZGngUysRK1Utnk0SIn8bny540nY1YVawyOwCw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.17";
        hash = "sha512-HG3VHqY+dz6idpsJq5WQgRuK8ImtbuqoiPB1qi5EtzPJO+/6Wyp/5aaMgPdqBLFRkCTnn69ADyQqHW0HKe/L6g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.17";
        hash = "sha512-v62OR6n0s0SswA/ulNZ8TotDKUKcNoST8jEyK0hFnyvDkhFfQ6ZKEDYw0sm1FB7S2L6zlbG2BFUhwcfs8Cq2qQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.17";
        hash = "sha512-OePRUteSSwbTaLsHtg7OZqPSuwoJWviePi6Yo+RNMnSzDmpprwuMlJoBZm4XArpmfK1wR7GdLlqMG1JQsofK2A==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.17";
        hash = "sha512-uyXF4+0ywJi+ax7YMmGjEv/SIqf8dnEMgcl23ztfe/wUsJI6DgNambfXy+y5cpGSrzvh+2tXVUrqIf63zsdcXw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.17";
        hash = "sha512-2vKmcQg94Rcep0Fc/fFeL8r5eEnv1nC7KB2QyOecqAoCf9M7X1T1pS+Jq9FmiwwQskIQMrOKZ24+dWyO5mwJSw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.17";
        hash = "sha512-WHqX7lQzWG7yEvg7RnRNdnlb0e/utUhWYzsIFE2P+vx1uEb7zIaaWCDtef709Tpjq+derkpEeIdljIXhR8AR3g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.17";
        hash = "sha512-A2F4UubnnFzGhDBR4GNihjseFVlZnMZIIy7KqfDWxEOA3gspQx3qP5uyZ0NUwuaa69JHowptsXHGmG1qLSjKdA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.17";
        hash = "sha512-1/NxG/Yew1DA8eynKsxG7pRK8qJetvJXv+HhD6gbvu/yHsI+9YJHgllomIY5Hz7AR/3uOrg7EWZfUz0S8APlKw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.17";
        hash = "sha512-RUXvYQOwsj9D2oLWGvAi0h1ZU2C6JVxfmSBABOOtrdAES905io5fTDz/WAWxtaVzd2jNoFJW/pL2vq3Y9erEtw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.17";
        hash = "sha512-foGIAKNl9bUw/2SKBkvk0tMWkW2s8gOrc/MgRpPmzxk1Ztz61nonLo8miRBCSUfMkdrMWi0dR3dQEXyyKFucRg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.17";
        hash = "sha512-y7PlxuNjbxEGhMG2mZNtMTT5KVmUFcqA3SAaClhX/2occN6SrntIuQx8gm5yPAd+eEy5XjVIbZ5bPyZUqSr5bg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.17";
        hash = "sha512-4xIDKo3cLLP95F6RbOambhjRMueKQjSnLVuSwI8SE3uQIDyDm8o4Y0/Ab1ghVOAbGXfqUY27ldcD+3afiRKUVg==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.17";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.17";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.17/aspnetcore-runtime-9.0.17-linux-arm.tar.gz";
        hash = "sha512-r5i6xKePycOnX+N3nOzu2h+XpMGvgK4fHfMvcyUj/RQieuCUPdffoRsSHaODjSXNOcb8QDq5Vi+vqSSk1XeVTQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.17/aspnetcore-runtime-9.0.17-linux-arm64.tar.gz";
        hash = "sha512-bKBCk8JGsUhefbUedDxTM22HuOksariZLW0Jct6E/tCts8dD+vylhQgZnK0B8M6odTF9ewzZd6gsq303xnwZCw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.17/aspnetcore-runtime-9.0.17-linux-x64.tar.gz";
        hash = "sha512-qAC0en2yvr1BindVOyMvmjCn0ePaDnsHVyh4rDp1z6gxf3yWmreLeazC6Mus6lRnVm1BCN7xFbPyZZN3Zgqrig==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.17/aspnetcore-runtime-9.0.17-linux-musl-arm.tar.gz";
        hash = "sha512-scCKlpJVFP/SKWdyf1X5hrnbdY/cKmKvB7tHXQ4VuwVUMpy+BR999kn9ydwJFGKb8u6796lipsZaU15ZpHfcCw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.17/aspnetcore-runtime-9.0.17-linux-musl-arm64.tar.gz";
        hash = "sha512-8AESWVpEPnEstC8kXjnljAa9j0nwnrUQrl9jJLpjbsChN6NbyG9+al2BJXf2BUNc4mBLtMiqQPX/DCsSbFIwbQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.17/aspnetcore-runtime-9.0.17-linux-musl-x64.tar.gz";
        hash = "sha512-1U7gsl2CYc9BuohDO+1/Vppncet1pU7cxvjyl4L4kaMclhynwHJBTvofQ7QKUDCV2/TM26SOvzJNMoscWRH4LA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.17/aspnetcore-runtime-9.0.17-osx-arm64.tar.gz";
        hash = "sha512-FC06FM/8bnWQa2Zih+CrBdMzb+yUa8/HXTSWqLgMD5vX+wGjNaDvnOjXyEs4fwLUaREKry3ZGq2c9lEH6XCHJQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.17/aspnetcore-runtime-9.0.17-osx-x64.tar.gz";
        hash = "sha512-kkRNXXbRXs0ersUqjE4ut0pP2WxL11XFm5s2Q4omNikqgTaqVy1s1bJnguo+CIl2LHof9ejQ6LRPrhQQZZgOyw==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.17";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.17/dotnet-runtime-9.0.17-linux-arm.tar.gz";
        hash = "sha512-uZSosdmfD/Znce3GsIHNAeU+NM4Xobkkseocr9CgRIqHY2KMmUHt9+SVpAhHqz1LZsWQXckrPgy0BWZKFoTucQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.17/dotnet-runtime-9.0.17-linux-arm64.tar.gz";
        hash = "sha512-HOVdpUsXyUCfJgtCkJEsQbBP8Wvf5vk1uCI3k2tHyIIrJMzBKzABymDiuBXQKFGNHom/vqItc9sGa+Lc8pM25A==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.17/dotnet-runtime-9.0.17-linux-x64.tar.gz";
        hash = "sha512-rW/D7nK2RF6aM4XQljNhriwmCqct0Wu1LM9Ewjq+aC9wvqiy2RWF8T1Y7NdEmK3TBb++CQf9c7YBgPwmqmV2NA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.17/dotnet-runtime-9.0.17-linux-musl-arm.tar.gz";
        hash = "sha512-MLZQ6v2Td6pkgykj5S3K1npzlrN5aRZNhRf6ulRHmiQCIMtisuIjjRacJmKw25/4POY93mk+EIIy2hLiaKvA2Q==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.17/dotnet-runtime-9.0.17-linux-musl-arm64.tar.gz";
        hash = "sha512-ZeTQI/ddSjEE0KSfxlJXm1u8EnERpg9XJp56tbd3RwWQ6SYv8tEjNvUHEH8eS2RrG+peFr3oF2ZpiXq7dnlX+w==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.17/dotnet-runtime-9.0.17-linux-musl-x64.tar.gz";
        hash = "sha512-uOteVlXWRXYpTYGMnQBdKBShATFMNsKdKiZQ7X82D3VnDf/+BA+yCklM2IPyQT7NyPNWh5b2DLrba6Xll/GrKg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.17/dotnet-runtime-9.0.17-osx-arm64.tar.gz";
        hash = "sha512-u9Xvk094hC9g+A/BrN2YzqHCbm7LCrjetaxYgM3BjMGA2J1R4KfATHo3EwsVJnN8gzqZY8Kjf8nzZYYLpyJFug==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.17/dotnet-runtime-9.0.17-osx-x64.tar.gz";
        hash = "sha512-kTFYYYF19WDeNAtVbsBYBr+E/bfd/7YKyTc2RVKlKhjyoZAS544rZsN9kKJunBhWljBZCgKRlEkvNHXQFyNo6g==";
      };
    };
  };

  sdk_9_0_3xx = buildNetSdk {
    version = "9.0.315";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.315/dotnet-sdk-9.0.315-linux-arm.tar.gz";
        hash = "sha512-uk8EjJppvJx/YCAeJDFgxiLv9YYwRl2heerdefVH8s/KVn9z3VeoXniqsr8sM0Qd2meVqG5lXNi3OyZhKzhBxQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.315/dotnet-sdk-9.0.315-linux-arm64.tar.gz";
        hash = "sha512-TYyeX5UGMJVgj4d1tynvQdbckQ4UmS3bUz6sOKRLFXzdZ7wkRqNikI6s8EUzKAAc5xYbPwzrQZGmnEVPH4zBaQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.315/dotnet-sdk-9.0.315-linux-x64.tar.gz";
        hash = "sha512-FyOnBWMANWaIBgDcB08QNmQov7VNsqdJt1xoT23KB2PYChz5or+gFOWkH3q06E8h0ETnAVIWWoTOhu2/qROvsQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.315/dotnet-sdk-9.0.315-linux-musl-arm.tar.gz";
        hash = "sha512-Hx/BeZcntNVI/lZC9EGYnvu5p2FWUiTreASreCO3IojBDllciRHKhFo+ymYp2cugeTBn0lopCLLfgtokGQTNYQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.315/dotnet-sdk-9.0.315-linux-musl-arm64.tar.gz";
        hash = "sha512-/O2VMQl5OAQ0wZxwolff+4QIb3iwZJy8K+sNn2tClv+4bQvm2NX8YQtjwnKirIYfXh7xyU+wqB45OSewA1CTPg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.315/dotnet-sdk-9.0.315-linux-musl-x64.tar.gz";
        hash = "sha512-2ZhbgXwycggYzQzT6xNuZUAK5uXSaV+0byLqm6s+AtURiXoQm67p75Ktr9qPhgRWslix/re0i1yRjLw9Fnvl5w==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.315/dotnet-sdk-9.0.315-osx-arm64.tar.gz";
        hash = "sha512-gxltbtyWIWRTWmMoOGW4GyZ6WizuD2iJdB41pGhASW7NLT4F8QTJoRQlQkiFspAXb6xUzKpZIUyeaFFwTb2onQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.315/dotnet-sdk-9.0.315-osx-x64.tar.gz";
        hash = "sha512-oZwtbGAdBJXQ5oNnTSarOX6rHGw9zI2Susdrx/LJDIYrS+wxkai0nSzfDUnhzccLhM5is/rYlI4XnxXF9fADyQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.118";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.118/dotnet-sdk-9.0.118-linux-arm.tar.gz";
        hash = "sha512-PB4wW2LgZvw94tMaHgfZPoWmi6ynv7xqJA6Jt1Dr+mIfIUnpjBWElKL8R2oBHi+WzFPeQLAOGcKakcNygvvBtQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.118/dotnet-sdk-9.0.118-linux-arm64.tar.gz";
        hash = "sha512-ut2yaP1jS/hy+dGoYo2SDKCNY6U80VwbAS+QryA3t1vgD/WZIS3G2GhlGWDtN0serJ//AnNDc1LA4MzHtgdK7Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.118/dotnet-sdk-9.0.118-linux-x64.tar.gz";
        hash = "sha512-HHu6cYRjzE+NFiy4iAjroU7h5y4myEtfN1HDMMYqSjGvX5iv1d7rXCcgObXcZJJVzImvIB+NcGm8Ah+rSdGExQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.118/dotnet-sdk-9.0.118-linux-musl-arm.tar.gz";
        hash = "sha512-EvI6uK//wn5OD2zvuFYUH6SKUglZhPxf5ux06uVtbW2Y+8r9izq1tfFPnDHQBFkQKW0B0EPGYdZFHB5wycuMSQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.118/dotnet-sdk-9.0.118-linux-musl-arm64.tar.gz";
        hash = "sha512-njyZ+nLFny1Olbo8R8gV4Q77EYO7mZzU4+z8BhJw8zhI+ZWxZgvHWshGWrC+kHl+bXfF5EH1CohNcRFOU0SQvQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.118/dotnet-sdk-9.0.118-linux-musl-x64.tar.gz";
        hash = "sha512-7vmItE+LAzl+t9kiZpgBlWvxQGYSOk7Kv8EI8obfTyWbeZDwIIAENRVj8eRRJzkg1pk5vgL8lPR2bW/Dh9eWoA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.118/dotnet-sdk-9.0.118-osx-arm64.tar.gz";
        hash = "sha512-UhD8oktZlk5ctRVvJAVLW7QdQDE+df50kDxPIv4Zvub2i6Xq06W5W2eFtMIOzid5iD97kvPsF9DGw38uRkOymw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.118/dotnet-sdk-9.0.118-osx-x64.tar.gz";
        hash = "sha512-0gjEt295yyI42nN20yEy+n1iZ31Bw17lb699MY3BNbbQYQTZDcCcR6GpYsYe/aP1fNHsNqDjkCCaGHaU5a80xg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_3xx;
}
