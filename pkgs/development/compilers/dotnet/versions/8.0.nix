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
      version = "8.0.12";
      hash = "sha512-IU0eI4OrQYkabBlA2WpJTv4ySiWm9d7fnnX99k4m1aEq1XnffJIg+a2YOHwbJRR94GdQMHTb0Ug87OdX10Z+JQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.12";
      hash = "sha512-vX8WpwQ9zE4VMheMIXm8pvQL1BYAvTTFeDxuiZ2U7edUHl+dTBA2gizqKG5x8nVJ+hBLEOnd6NVe/IQ/4jJZQA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.12";
      hash = "sha512-Njr8IyfftNDLVifJfppsfU8Fq0e/HM/dkll9pVVZGyEzFyaQVN2irOcwdLXxZeH/npWaBD0x9T3980vhkMbt+A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.12";
      hash = "sha512-8rjYi83EF7eBOT1xfUkQA3QxH1sZ3GDbVwX4keXHE2x5PTVg93AdNymis+6hrng1cRCmsQHXqLd7TKYaBv+IZQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.12";
      hash = "sha512-QO0rXIEDNJxhuxwu5DG9dSy9z2zgb2rkzQ1chPRwTKc6DQ6aM/Am9ip/ZGctBwOkd+U//rk3mAtiyt4urSkFtA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.12";
      hash = "sha512-62zfQPVBxlPMyBXwGoxtjGa6wG+3X7DxDBMUeXVkazAvmskE6K3oDlxizpvicC/ixs9qP9XfPG29Xnk4C2OO8g==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.12";
      hash = "sha512-r6NUtAtfVD/yrl5I32Tgvp2omJeEudvcJKHP4P48QAq4yTcNxfIwSrnpTNala4rdesPN0oCT1EVYjjM5Zsx90w==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.12";
      hash = "sha512-x8415TsDFy1pMt6c/PvjO6N42DxS8H53M8dfXgtAETiXAhZAx20mR35MshFn/LFP1TIgk92F3XEn4jzN8alWbQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.12";
        hash = "sha512-+mObcz+CfLpcmBUBLi0dkPyapyBWusj1xBBuEZz8Aeka6MWy5WS2ln2Tes4tKv4HKdbEQZJjI9wDH+9P+7GJdA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.12";
        hash = "sha512-SpNIfhe1CdGsbt6F7iP0rKJZ+4qPJug3l2T33XospN7AGhHewHIQadRQqG/dQBab1e1ur3w8dCnmYlf/48gymA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.12";
        hash = "sha512-XkM73Yq41AFG1IAwBvusNpSDn8OuPmkJEKJpPFlccX/GYlT5V/LihRlNVS4OHmlJhvklpuro8x+c6arLSnv8qA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.12";
        hash = "sha512-ix41sJBqRfoNp3zg2+QBX18XEEwA2iVcGQwrHOOgAM5IcJdbe8wO+K7Hqmb4+gtfonTuVzxf6hvDi32luuSUFw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.12";
        hash = "sha512-fuwAxmHlGgVzoMiqtPeYKaKr7UQQYTOdlHddgduPDArxQRJOHFL/ssRTk+9NcaSkSfK/+CO+iP5yweuX27UH2Q==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.12";
        hash = "sha512-WEZ5f5D7OpmL48PowylsZO0w/bhuVSbvGjO4VtnVlvk+chNeArAd+mocPcBmleNDMu11YoZvEC8wkHvsdfIOCw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.12";
        hash = "sha512-04gvjzunjfA5J+srNF0ew5KNSNhFwYiZdZ2554nUhG+sO/QtbiTPP9p9QqCqwv3zwf2FYz7/sUuIIC/TFJnPbQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.12";
        hash = "sha512-BRkp66CwQudTw7WCejICFbAMwOaTrvjc8q2g5yj3uyAZAYDQVG9VC+QmsO7EOvZuX0vuxhWkHNg1u0yAjD/swA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.12";
        hash = "sha512-WdlGK6tDI5MwJ5BTFpPhfUn1vU1CHP0UVEKnBhHOhihgQaO6Y+Itdu/erLjaEe1JE9aANdKahvLJTIbXqpDRqw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.12";
        hash = "sha512-Arv2j2asHvlV6CjMjw5ahVWQGy9To4oolKcm8Lx3P8zPMjewt5M6ubWfndOcIMhLzxtx9QrmLF1HA6xEqo1JXg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.12";
        hash = "sha512-560CmTGtQOStnCIStBedCaPIDxqD4mTLj8W0myxjLUjEai5VwHcdecjhkZ7g6Owx5igQcXdRVhsV1BgRQOfb+Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.12";
        hash = "sha512-jt6Vtq6RHBHBE7Iwmw7MzCMNvNCp5+Bt3PqTIrQ21IttnpESbcLgVlI0VJAqXxIwsWiRn5hScfSm88CLGSNsfQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.12";
        hash = "sha512-0R3R9Y9ipFnYu/kzEOjJt0VZH0JeyJkuWC6kuQIkmpcbElsCPvQWV1Q7x8Ui6od8ixUlL2Cx0o/RCB8ZeKppIA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.12";
        hash = "sha512-fiP4Lp/fMzye0ShKP6IDUA6+4ICvGdKsIXL4Slq72E6+AUlX0dghW6tNc998ErZphdLX2sbsSc1HQnDICutvpA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.12";
        hash = "sha512-10ylliwboh/r2RsZ6JxBaGTlgJFijpATV/Fu57wppCvnIs2n47jDPpF1XHGiGkSFVKuMceLTFRC/5rvY03BafQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.12";
        hash = "sha512-+anxlvYQUscNCsCFQPGHyADxolr4cJlcvYhe6D9t0gfoJObTwe/N16kUv4nqY4orTGbdOVQTAzK/sP/Peexc3w==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.12";
        hash = "sha512-cZzBGVhiVMMuauiv7cpo5uGmDCJkp/T3bb/ebf4iPuiBoLpzhj3H6MUMExspoifk9YbuUreRBhFPjehxw6ZMLA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.12";
        hash = "sha512-FXRkE1G3pOU96QCaLzoR6bK2GMGVJZG8KYxzWG+6YJExOx8Zp7b2cpVRFmqZVzyu73WtSl/gNDXZ16yJG4csCA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.12";
        hash = "sha512-CLYlwkALgB7C/u5shyYTfqq/12Og5oAvQrSB2wNvDAfRNo951HvCOU/wDsXHuIUIdPLlHlLMEAWkpm+NeE/QHw==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.12";
        hash = "sha512-/rSaXqthJBKc6Hpo5XqMDAinY46BfCVeJZpW8FefuPsw1JPj6GcNjzHo/FlkOP1/1quDhIIwR2yibukE+4VW3g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.12";
        hash = "sha512-Ht+5l1Kt2IUJ/CUj4hDt1mG27X3idPvCIjt2bCFp0Kohi0vwg1KyIhn71O4T25TGjgeIVksMYnui206PyHv3Kw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.12";
        hash = "sha512-kAYDaWNT7LpzButcbGML1KWVJPpiMT4AB45Ky5p+8rUS7qgItUEEgFXWUoxLoIUv33I83ltnBdk1YvK7wls3FA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.12";
        hash = "sha512-e9HuZf9u4oqAV546suSM5gxxL4ya26j78ZoCvg3Q2I7jFwjiqIY5nX2gKNsCqnZvI6QmFcppdtB3pRu1fgKivw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.12";
        hash = "sha512-j6SeFxXVMtQmKPQm+cFQyxmreOhqBPxgj/s1Ox/iBjmsfmjZCacPhvZaXBHOAIlofm1Cu7AHw4c/jNti/nmVVg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.12";
        hash = "sha512-/VNEwbjjJt8LZamwsKfNulK2eGARbzi1m37Ci3csBXturaOHvhXzECAZvcriPumALGVFBO3Lc3WSs6rsubxiaQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.12";
        hash = "sha512-Hv1gGAnrlwk5LoeZeudMJd2G69oI2jJzppWGJGSvXJyHus6XmsVvQwd8276rTm9o95GJzNi6kRwYJ6xLVrCixA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.12";
        hash = "sha512-hRd6hmc60sbTQO25kWoW/y2htMTzWLlk3GMQHjZUxB0b9F6JqzTo1UBmbqkAfZTCrDQ+redeyibbAJ1CdoGIyQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.12";
        hash = "sha512-DwGq22s4EZo9VMySm0cxAJ2kyHDQzEh0o0N3m7HyoMfdy3BxQFOoO6RGR8HSvpmBk3uPQbIOX73uv4GP2QhJeA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.12";
        hash = "sha512-mJaqr8IqCRiVBf1J2isll8Ay/4R43FgDxPAT5B/NQl+hm2xhp55qyiFSIwLSHF7bmeDyneEFDFi+BzTNQ6KB0A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.12";
        hash = "sha512-8Z0UJe07s/eoPjnyRxA8VshWA3eKTeQRc4BotwZcsgVblxCJPJGAmTFgKuEs3xwTxanuGJPqp2T0FQiSSFb5cQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.12";
        hash = "sha512-agI+Lgn5CaY9okxs9ab3UH6IN7lAHdE86WjPxU69YvtDJIA9Q6efR13fb6cKAU+6/+Vc/SCE4fQm0AKC7hQSlg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.12";
        hash = "sha512-tPEWNfOGZVqbHJIIO9nCozIVLdLwvj4ZGAAnBnSG0Zcv+cmXic7ptK/Lta9iUYhVTUUVIGmSRsfyC5ggDAn3IA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.12";
        hash = "sha512-BvGOuh3A5AuiGbyjOu3e85/+4SBWS5AtLLZkpCfQIXY2KAUP/vt3aBSXn0HwNaaXUWrcq0NHyA5wvZ5M4QCSYA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.12";
        hash = "sha512-RM2A3428VuPrCnAapYC08K1t/trGBC9iqe9Htcq36CMtwhzyV0XWK5diWmDhk4dLAdH3v2tjhePfUx76TFI5Ww==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.12";
        hash = "sha512-RyibsHCts+wVGYxBzkPRkVJEMLzLCZpV/Fa6csnuIIixvvqMwUornjrMVNcXMRq+0HBIlJAgFwcWK7ge2uBmxw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.12";
        hash = "sha512-67ytUxCcDyaCmVkIo3J5bChFKDJf3CIjJMtBJ+1wnaGqyavoHs9c3kGeppVu+FOyxbduKHNC35IxhtMfr3DEMA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.12";
        hash = "sha512-cq5S411xb/jEUFPNlwoDV6PLKbCYmDHujelob530CaYP6/UfiI/Y4vqpyBySG2za+Y41vazDEBw/5Hc2u1sZ6w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.12";
        hash = "sha512-jan6vGT7vg8fbtNyJnmEk3jYNTbRnzxx2b37RMZSaub96HLnRARe8EHt+lFmjyxj39BRC9izrxW1GDEUebz6rA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.12";
        hash = "sha512-h3yV4ya3atlf59IJ6H5Eo0+zxX9aYNZAsNJHOZGO1Z9/n6eFrKtgjaBDR3tB4K6/SPjFYrmKfPAPWVkQ40zszQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.12";
        hash = "sha512-/Udpwhuv8ukIken2Klg8k/i5lImdl7Zo103aUoZyxcFotGM70cZjEfD8wSgZ5uuybnyvHxK//rU1L7B+2DLlhw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.12";
        hash = "sha512-IVQ7bb/+Ay4oTDGrpbBzmLPibWQ1eKQ07xTE+KqFqF1jC/vEWcsVDWQAxTm7c1OVU3rM018flvE6x4oSwMP9PA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.12";
        hash = "sha512-7U+tpgXW2+obU+S4SJck81AAri52F1YjfIl5m9fWumni7FLqKiNsWGl3s5AoGy+IwApTBHymKdCrsZcU2uEELg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.12";
        hash = "sha512-8D6h096yNgQwd+2sUneE/ne2Po9n9eoVXTL1Pjt3oLhHjB+spEz0VBKtHv5u6ZTNlxiigkhZxYYQmgkidqHvZw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.12";
        hash = "sha512-dnof4ysabawNHR/GHmDPhDJNNVIo04vtfe6hdV93bCHodwH8mSXA3+q1wPgtgVVhRH7o8ivabTZtVlCrEDQsRw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.12";
        hash = "sha512-UNHaTj1t8NSwSuBZt2+M4iFFSsXUwrWxGakl/cfxe5Q9O5byqeTgRncZeYoXJccnZocBb0/KJEukSLUq//uwnA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.12";
        hash = "sha512-KYeu+MHDm9YuXW6r48+6y16K6luIA00DaxQ/IyVJ/d4wGGRlRbfSuezFi1UPzlVG+2rlJSXYl9Ar5dDb3hmWEA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.12";
        hash = "sha512-uViRfO8fKV/V46GOydgeiPxjMv+9xrGsESLGgdBBzqQHS+fwmmmkL6kNhEr5YNPrcTgkfID4VjXsTBNcX3UFoQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.12";
        hash = "sha512-wptP67Kbz5h7pv/i7eC1J/fBP09d4y3xOzhP/9nhTmm81LkfatTa/7diXpz135ON5Y2HRvtOf/Bs8Jt9A60BrQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.12";
        hash = "sha512-rxDXgjhW13dFRIuFwAXj4ANY26fxU2/kb9OqEfWEZ27+z8Ltfp94YLPo11t6OG+1zXt8oSfWg4qWODSfZ2LTMw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.12";
        hash = "sha512-JAVp2YOMpHCX3yYAVGlOmESbuP9NIJ4uETuzsbREPpi5bxo1DNEEaWXiGl/w+R2b2Udf0lLQbf430zSMZy30qA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.12";
        hash = "sha512-3hTYxYIO/eAqxsJol8bVNp9g2i54jFziO9RUjZ5V1RcCs3fXh6JvBuPipxBxgLpmWOeZFvr6oqecBmuNphiWvw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.12";
        hash = "sha512-ebP8KcwMcLozFzphxFEpgnAb4dL6Oi1WGuvpodmVqr2k6ZFYVBsHcZ+IISUyz4n4xb2fqPHzfNIJHJGeBBYoVg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.12";
        hash = "sha512-seZ5qw4wLxMZO0R7DspDiPpNklPfBMG/Kw/6SIggVxrozB6HS01mZD84wZsQddQCrA5u+QQnd9w6SiQyByr0Ew==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.12";
        hash = "sha512-gobM3kaSrjSkmW7tRfhj1sQkCpFWwKO9i0o4FcOzreY2yezUk2yh0BflBZM0kdKQLnuUeXL7JA7E3FBvEYebZw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.12";
        hash = "sha512-hcHaF6X4WURPtHJjrZfJHtz+X0FdD7ILo7iM0EwotEadJZEtyjxqSMKMbz8UKZMgTMEOoG4joYgcou2cN0eM4w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.12";
        hash = "sha512-w8lBF8Kv57bqSeAt1hvACf0he5v0dn4rQ/Xy+IbJ7KT+xaa/hkOR+KMg+o9ixttHTdMhFBGZT5j/E/qaW27nmA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.12";
        hash = "sha512-CeYo95/17pXA33pND+nPGgvZbMuhnyURqPM18y6C2F6NIRF+tgSFv0Q4GU+y2T2+OyvmOKbb2AlLRxCaIDIM2Q==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.12";
        hash = "sha512-ejn6wj4QD2SaXZjU2kqo+3FFf6IgNeK1nKAwkroDVCuNm4U2vItl0nSkCP/P8D+Azsc/20qnADWsMGc4bNygvg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.12";
        hash = "sha512-9QsWEMiK59ByypH9UN1fyzbR2ssDD8xUaxR79nyykN4vQMAvOnmFFJVh5Tez+tnIK8V98bFxQlo4PbkM729tDQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.12";
        hash = "sha512-BtWP7zx4UFX6mm94kUdtGyaEnhsjZDYN/m4oMvcpcKGuS1BZ1IZZcVraLTOFzoPXgxHWXJXCCkL0oSx4eeHrww==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.12";
        hash = "sha512-AVkiT55B5xqGixGbjxmwefC5I+uvyK9UFMe+047bjep1PA5HZIU0+iT5NdMeJsXJCSor9+FPplYP5XwFQPfGVQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.12";
        hash = "sha512-aK5BtsYX8vxGuSsI8JEcgTQaSJGo5+yXkm4NrenqBXFvexuqTfsKT65i215dGz2aBOFhEITWCAXf6JzTmBaxCw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.12";
        hash = "sha512-L9j7kDdn3Q4FxQ132wUkdn0DhxYdyLxlQtPhTUAwibwsP8eqjGpaXLCUFgC75aDNZnmHhWnwxjniNPSlJg0oiA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.12";
        hash = "sha512-f9BbwJT5N9cCkK2qaf81E0OEJCp332mqCHP2J1vXtSIYujYF2ZMW4nuObgZEnYlBd06r/Q7aIAqxO44zzn7QRg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.12";
        hash = "sha512-91MXcB81uqgVuia/TDNonD/Rxy+8k4AaDxZ2jf/JOEqMNMwtSRTaPp7cBb43pQ/x5TUw11+XTzk7ju9fENuHoQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.12";
        hash = "sha512-cyo0lyxMMB8t6LH0Tn//R1MvWg/v0ezguSWKgXTR7Vk/hkJzwKLYyrhgM+Q5Pk2vhltAzBTJNdIovVtei8RzLw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.12";
        hash = "sha512-8G21b6Fs4JU/hwYonLvJ3z4MHgwOsW3WHCRGq0O2YV0gLhz/HgUihfgrvTPwsQX7zRfIgbtdjv42PLZiCBe+eA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.12";
        hash = "sha512-a/d+seYGVkpGTtYotJyVgg/pzuk61p7ETOOghcd62vp/LMuuMLqI9o3N/xsk7+KDDlm+DLFZpQZTMgDOOa4ZsQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.12";
        hash = "sha512-137EsmMMjMBT7JFpQ8w0FEZyAG/6I0KWUBvnuamdpLtKXcd6B+8ua9rlcmNBEkN6mFbxS5m6qXwwn66GvSLx5Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.12";
        hash = "sha512-KHnmVudTJSlyzdpx17lkJFKysFickorqE2/7duIknz/zhkrB6fsgD+fT/DA0j/Nz43ezzIo796rIS68X0ByOog==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.12";
        hash = "sha512-nhFohFnSuFpLyyKEfEUpfKe+AwJ9PCxcnZK5Gqd+na/MylLUkg2iuNYx7CX6RDgazg+bvvEUf3in8rMWdczf6A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.12";
        hash = "sha512-QHgRha5tGSwRVy67PSW1yBZfcJNthI77IJaV85sOCbSRQNCQxUU7DmGb9aeI/7quGWUzM1BahaZqQfOXiOmdAw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.12";
        hash = "sha512-VQNqkmSpLIbHFpVSpOKNO/6JMm0SSrMV3ptcIzHSvw66Gsqr5jjo/E8S2Q5dAUlS0b/psdOiulND3rYOQaYk3A==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.12";
        hash = "sha512-Op9dXXTWqam9pw9UqX826kPhNvOTUS4QJPPRscD3yJKMT09Fdxp36Sz2gT3Q8ToA0RhoHTlRj98I4ZF8M0qjXg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.12";
        hash = "sha512-Wi42A4IiXMx8/qWmiktaidyZXg0NfbMM8d0aSbPtHGOVUNI1BoiZARdXci+t+HXmBYV7cxr+/hJKMV/suw83wg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.12";
        hash = "sha512-+QeWCI8Z0puUM08mIsfVsBVvc/jQX1PDxySTnv0BlHQ35saacdOEwa6Hf5mCxwrIsaKW4p7j9cY9MJSFjdmBRw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.12";
        hash = "sha512-/usq+rObnkCjKYd2utS1b+GYDSV/ZeJMbSpFv7CelQGbvmQ24w3Zd4jHE1jqMfbBzf15/OHqBHXHdi4Nu+XRRg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.12";
        hash = "sha512-4unTG4jtyBU2SkT5fjYQEWKCjnlNu8rTYySGCCbjClIzi7O8z3fxYWlng+B1tnA4NpKh5y5fYI+dvaXeiI2UnA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.12";
        hash = "sha512-Na4e35U88a8KvpRqAeG2OmnQcOwavnGPVNl9BnWTPcNdT7RbQ7o2hqDOSvT8jsqwMcZt+L5yGxYtGY1widnTlQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.12";
        hash = "sha512-SmlxLDqwOSkq51ffwjidZfJEnBNZ2kQBWNPOhzD/NKms0OrGD6ssCTwID1xGwiVDKcyHyeWp/kpZaSgb+/SWmQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.12";
        hash = "sha512-pTM9MIEvOaIGzu2Djz7CNqtBSU/4ytuN7T47SySP/N/VnJB4QfOCEz4MYFWG5Rpqz1Zx5gV4eEfV+DFUJlZ+dQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.12";
        hash = "sha512-RtGa0QmyL+DxjypnrrfFr9AjPfGVbLOlAqQcIVr3xYOjhlm0+XsKanRycjOiQpY7PYJGIED1nICm610kxTpHzA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.12";
        hash = "sha512-4b4nmMBlWXn/rILg/kgfLsXYfzRBRgmuuapWgHYtmyZPKmP/8QndobpmbIKN65KgkcJoLW+6E1BggutpEeWYdg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.12";
        hash = "sha512-AbdCpfp1Zr0hKzcbOC0XD84G6RP8sc2hJfjd2hkUNoQX6rTH6zw++ZahCA9GAiNawqGQtlzu3YJG6ELLmwmP7Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.12";
        hash = "sha512-L6Bva94q7LHaYa9GIATU5L9mrcaZ2TKD3UV7U2gbeL2hqyHjtKC32CzMJgiJpqaidO2lgf46r5ATLhBIpgv0hw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.12";
        hash = "sha512-UhlCsMqxKcT9vf3v8xygojEypCCVdWY1wUD2UXdwsQaYopOKPVrBOrK0me9+vDQxXpRwmJ8q92x83NnGsq7pDw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.12";
        hash = "sha512-LryE5guy2qJZR613WmgBSVbnmGBu4wJWn8Cd/pLVhvloFpI9qodruqZN0VmO7wXEsc4m6ukq0sfv3u/qKmWLHA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.12";
        hash = "sha512-iLAQ4BaR5cDX0DPP9s/wEq5A8He/nqJu6i2nGUOEiOYKlYGNTHQEyKqc4b1sh0XCAQPQ5gn/7NMBrqo1/0hjWA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.12";
        hash = "sha512-fFUUZcpljb2Z6/Duwtp1RThdOEvEFuI3lYijFTVpu94oRjw5sbtH+5qO1KeqrxCkY+Fnpwe1ABBy91zdoPus1g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.12";
        hash = "sha512-GsgHWhLYhuzBlBp2XlL1OBXyQyUHQJOpR4bR4bwG31qoxIhjUOQrgbiXD9pVKaKVHJxHO00nLSQN8mKEg7YKsA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.12";
        hash = "sha512-nCHMRmxs2ZdwPEDy1Gh6mpwA38c/TskLYLcF/DALeEsQEtCXltP7FirPHVlYASOj1k+72xV/XPm9BQ60xgrOEA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.12";
        hash = "sha512-/AzCzNAiKUaHOgyGaGw63jBJOan9TtPFEpoQVtVK/OeyJFGrAokcL7LZxEmYZHCOAB/McmVl9ktOdebe1Ip36A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.12";
        hash = "sha512-OjWkp6to2inzfmTnMiKuCQAei74AsWgoZXHJFOU73AfLErCLRY3vdzVEE0mR7vXki8jljzpBqPG7DVH2utO6Tw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.12";
        hash = "sha512-HH8rUT8WfI8co30Fed0+V2kcH9H0Dt4CQ4REQHL0d18Ef4BsyNilXeeYIupGUYV/oJbJJfuCENuDP4Nn4o4XVg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.12";
        hash = "sha512-A3gyFcNiSrVZ1D/IdmpUlJ1iGYdV23L8yA8jo6PgeeYas8fWnUV5fC3BXq5/zhwpy+I61Ma1fqL3pn8WJWcCfQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.12";
        hash = "sha512-Rcs2Tn4y+jEo6oLSbi7fkxg50eODt3tjZNzM0iJBnkmMI9ZdtT9PSp7ExSn7NlqjpilPzP9YRCYhPrra7MfIbg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.12";
        hash = "sha512-j+NocH9tAxjaCICEVP3g8YhQm28A7yBg3GnNI0B2aXtba8vlFomvu509icbAp0g10YTGbqlOdmt82pIOyhcBjw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.12";
        hash = "sha512-qL1rcHqe9ZRFVlU1PTABx9AS9x+zrk9gZ+zW4nDr5Ai5AgeXo1cYSH0nzEv94cScH7ipGaCrYItF6tCoquK+Tw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.12";
        hash = "sha512-pgyneHJjNT8ZqOoRunpxLh1ZilEvh9xRV16LOeigV5ROmZ/cyUCB+5/vKnsuC0Yz3noErwfpukpLUGe6TTQOsw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.12";
        hash = "sha512-mwOme5QW7MSs0xZP3cPDTHVqLD4uZCVMkkDwajj5IGyOstFSqjOkMD9d8tW0LJZM0PbtXz4NkbS4OfZvlztetQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.12";
        hash = "sha512-s4TAfOSVe5loFWXz17EI12BcKZKrsrBiaaOS924f9agg2Ko1KTZ4Q5fzBZbQ9ArfKe3LpTpkgagAb4qkR9xQDA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.12";
        hash = "sha512-Q5KIhosisJXxTfiHVthJKuIM9FLrl6crL0nMplRQ97pg3LKhg/YstZCdrzSYoKEB6fCns3BQIXWzjYXVQl2pSA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.12";
        hash = "sha512-tDX7X6kN5m6U6Vxb9PvHPXWXLW4gSq/VwWlfUy8B2TBknEV4/FBkYCwwXhKOkfrguhBGW9Y3fYpw+Gk7lSdg/w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.12";
        hash = "sha512-jn2v2QIk6ti9qvSQDeEdI8gtUoSojX3gifYQuyn8dBYsrf9izKopL5WhxVsiA/L/ysYSx/ciMdm71j/FhSMUtA==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.12";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.12";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/26fe9c15-40f6-4eb5-88fd-63d98eb259fa/c36789f8460b7e20371c38129d7fc160/aspnetcore-runtime-8.0.12-linux-arm.tar.gz";
        hash = "sha512-FEvX1FAlN6KAbRfuFhLks8Jidmxdg9qLEDHKYfKh6r0bulpTGxv8r6uZnwhNuWHJeVgE3mUdh/gd1tZJdjNZSA==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8953c6fe-3542-4cee-b022-a50e029882a5/1bbce821b1ae97ed11b305dd708c0437/aspnetcore-runtime-8.0.12-linux-arm64.tar.gz";
        hash = "sha512-kyP2WEv5hQD+AjAJ3qW5Dkm7s0zc6gho6NGML+JgsIcxVDjKLfeD8lkAPBoO4x8tc1yM6oXCxPsE9tr+BThFMQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/df752f45-7e9f-4d13-8568-a88adda5aa04/9d59726fb38525b4956cbb1e1fe8a2c8/aspnetcore-runtime-8.0.12-linux-x64.tar.gz";
        hash = "sha512-A6f9N9zkbDHX502nzU2aq9gtXgh4WdAGX0cOv30LYq0f61n8P3RpAzepKPV1HgS8t4OIluZLP40lrgNcW39cgw==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d7cca8a1-ed7d-4dd1-a993-6766287f2f39/2775af53e9a24ddc6afac345ad417b5e/aspnetcore-runtime-8.0.12-linux-musl-arm.tar.gz";
        hash = "sha512-F0GJyFHrF43HtWJLIgsKDfisv0HEzXPhVanR79LmrSrXescZ9R7bukmE5L6Qdjom7rv5WMGneuMuJvcoAWURtg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/90290d06-b7b6-4ad0-99d6-1bab0a557051/3ba84f7ecb0f681b8f7cead66124c373/aspnetcore-runtime-8.0.12-linux-musl-arm64.tar.gz";
        hash = "sha512-d65Io007lHiqEbgHf3sdb16kdpn5Lj3CnQXMzRayXgI1h6lg2bwqXCWTnLt0lBAs565/1sCfWXkUmBpeftknFg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8f3afd94-2927-4be9-a935-da9f4dcdb004/c594a54091b5b85063f38879d50123a4/aspnetcore-runtime-8.0.12-linux-musl-x64.tar.gz";
        hash = "sha512-p9O64tp7TalGhR02GW1BBTWTr0E40a4CDOS5sUHH6E1TRGywiR4SeYOr1efAEdfJ0gOSJ9ypQJ1vrrY4NYM4mg==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/16c2edb0-5977-4a8d-9060-1d8a673c6b44/6802cfea6e93712b7872614bf47ebb9f/aspnetcore-runtime-8.0.12-osx-arm64.tar.gz";
        hash = "sha512-l75lVblM/eIlULQ0wOuNwykYGzC5MLYsUvQEeAmUbQVYs8gJVQnNByE8ddUfXSYCB8+wkzXxYO1cVe6LaeY3Tg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2d69b57b-d997-4364-a898-220293f49d9f/c192bee87281e416703f53da103925d3/aspnetcore-runtime-8.0.12-osx-x64.tar.gz";
        hash = "sha512-qzE801RZhvMFrxH1SVo5bPXn1mJtDkaRfv7fSveqspy58t4RTJ1SGAgdZzndUvlpiZBrEFNplfVnK3HMhliUpw==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.12";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a50c2f56-3ee5-4387-a9a7-4338b75fb5c9/41676fb7ec43d9108a65fc0d76c15717/dotnet-runtime-8.0.12-linux-arm.tar.gz";
        hash = "sha512-C448N/IFz5Za+9cJav1fxuICJIs+PBdHEuG880trZKt7Dvhm7rbhahFDZ+NWZtrLUusLoQ3eizFDMUoFHrGh0A==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4bfa2e49-fd4b-4aa7-b5c7-cd344beb72e8/d04a3458f047737f9343430e901efadb/dotnet-runtime-8.0.12-linux-arm64.tar.gz";
        hash = "sha512-wwCofkF5j6565JIMFAu+NJmhCT1BhFD5v6RpsEXr4uWEDZVIfpN+7b6KsiHhOIrtdv3MGMktgXeO5DODun/jOw==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/14263fc6-1fdc-46cb-b692-df3e0f4204d0/24c37267d4f4e166df57ea3ec9acff18/dotnet-runtime-8.0.12-linux-x64.tar.gz";
        hash = "sha512-4NIW1U6aIarvwSCkgQUPETfMcIy70XIE8LGkfbtkJAeOi0TchClXpmkQJc2hSQ5QYQkoAkhLX9EsWQP1umNEgQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d77d220f-ba55-45b2-9013-5def3d55d558/8293468a0a39b4a61ce94f3ae5a65fdf/dotnet-runtime-8.0.12-linux-musl-arm.tar.gz";
        hash = "sha512-7JsDT1UOgHtNT/WwfGx9kJWetNbbXZe4skUmnaa6hz/ieCJJEYH+NOSbbpiGFGQLJ1QkpYWG8CKRXqSKzekGsg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3b021406-40a7-4609-8046-5877ae6b2c2d/8ca6aefd8b95ee56512416448d7ccc52/dotnet-runtime-8.0.12-linux-musl-arm64.tar.gz";
        hash = "sha512-s2m3G0g63HzVPTxXzOoe2SnkQVguIfMZiUKdMf9r2qDm/nVUlAKow80t3bk1wYxDLSxyxIbQNGfyelLgCaGJYw==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/bcf1eef7-7287-4076-9ad0-f5c308605952/d70135d19e557c3730f5b801d67d4e84/dotnet-runtime-8.0.12-linux-musl-x64.tar.gz";
        hash = "sha512-Kpegfp+y3MgiWFDJV0oBT5oREUfYfe1ik+t78mz2vubMUWcTwCwToI6Xdtut1YNifwXm5i2qr5b2U+KMCzeyXg==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/30fcac13-8a78-4495-84e6-00ae9445c76b/4989e4834115de71774568b0e606f09c/dotnet-runtime-8.0.12-osx-arm64.tar.gz";
        hash = "sha512-i+qRfQ89iqJ/Brlbl66iINRKP2sMZMZhLf41PdTfiBi9pWV7Y7yhFo619IZsqLizjHCrxe/8ovw1ik3InvEGCw==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3458a9c3-f34a-4d61-896c-1551ee66d5fe/bf3c24436ad390578caf1ccf185e3151/dotnet-runtime-8.0.12-osx-x64.tar.gz";
        hash = "sha512-sYToXFX9D/0Ue93laVtYbMGHnNqhG4MswxWJk9sphihmFwOe0voPRtq6CgHo7Om+awoWjYc0eB2XTHfI3DbVug==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.405";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0d09934d-c272-40e0-b7fc-8a015604d647/7e48c4791acda1a7d5d5fa6ce25e6c2e/dotnet-sdk-8.0.405-linux-arm.tar.gz";
        hash = "sha512-+cQiIhzhuUYOR3juJRK444x47qd+l1d5rwP4L+tWZLlNM8V9EDd3g5uedywDlBnfXuqkebVbeNcAE1Qqh9K2Ag==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/bb17a3ab-7122-41bd-96cf-33e35b1d4318/7b09327fdd49b7130cf94838f2979aa6/dotnet-sdk-8.0.405-linux-arm64.tar.gz";
        hash = "sha512-B5iLeEv3GRP2B84M7VBDTGmYCucVymL7avaPfqomgQw/n/4k3x2HBtGlV8Prd1YUPlNXAWCJzxUIcUuqHM6Cig==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a91ddad4-a3c2-4303-9efc-1ca6b7af850c/be1763df9211599df1cf1c6f504b3c41/dotnet-sdk-8.0.405-linux-x64.tar.gz";
        hash = "sha512-JJn6oVIOj9mih6Z5h1XeGj/+8xwNw0FiE8ipvsZIYUGb/IGPHBxBC4a7coSM5W1LbHSDmv2BdakiNF/GSQY+xg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/96e5d348-c2f7-4a67-acc4-0f602a484c22/365b77a304001e7db5dbc078c144acd5/dotnet-sdk-8.0.405-linux-musl-arm.tar.gz";
        hash = "sha512-+DrMsO1FtMk3ilTCx0/Y9VkFa3t3GvcK0l1i1B3Rw4S3lcuJ+95olZ24aIOx6J/mdJEAwFXy8wieNDsqXh8XBA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/55055690-d867-4443-b7ce-58cff24277e0/cf31a6b9a5a66098e0d1f248d0e9b11a/dotnet-sdk-8.0.405-linux-musl-arm64.tar.gz";
        hash = "sha512-r3KGMN7kIF+VUvUvSgb0jd9K/yOKuzLt/QGBTMDnEME59I71aa2Q7eUZVkubwFe6/7dOtgtU7Ec2TFHFwc94nA==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e97e02d1-0d81-4c05-9e6a-13ce436f1420/d883d1822ee94205d593234ab7ddeaf3/dotnet-sdk-8.0.405-linux-musl-x64.tar.gz";
        hash = "sha512-BQeP++s1t6rc+JJ8C/Cuxq9d5OYWWF3rVXQwgMCzS7bkvsqi4jwubDhWvAgm1eVPlqtpg4Z8Wxr2MHxi7MAYNw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5ad12484-1bf7-4c4e-9633-a09b7cd036a6/c544b4a3f03d8c98fbc015bb3b134e4e/dotnet-sdk-8.0.405-osx-arm64.tar.gz";
        hash = "sha512-NhC9rde8DBN/KD6VsB5FwYburHZSB/t20isQh2qPCFGQYJCA4HTfnIsccLO2R1WfVCteExNwASW/8D9sB9nyXg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/485c72db-0004-4f65-a37f-1f80bb445fd5/dc59499a684b6c8677ae7f43ff0e0062/dotnet-sdk-8.0.405-osx-x64.tar.gz";
        hash = "sha512-kqAW1FMGWGZfknQJXYflfc+C/woiJPOjkq9h0Dwfg25FF5gSHY3e4+TlziCUOvdxIbAxLyepyQDzmzlzgenbZQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_3xx = buildNetSdk {
    version = "8.0.308";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/faa351a2-48ab-46be-b7cb-88444c642735/7c711c1cdd133f3e9eb3243bf51af198/dotnet-sdk-8.0.308-linux-arm.tar.gz";
        hash = "sha512-fJX5yM7abqOJLNi21tOA6emR1VtT3Rv96jQFLv0435e846Rr94AltChIP+cnYJlmoNgBPYBXLri1XMZ8ytiQEw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/086519bb-5612-4c2c-8b80-c7984a46a276/4d4117e088dcda14516a8af754f25249/dotnet-sdk-8.0.308-linux-arm64.tar.gz";
        hash = "sha512-be5U3FW1njDm8y/8+XZskcqTHf/vi4p5SoOb0S8gLsxXTnAIVTf3sUDoobZ9NjkYZLvRRCoM5giOMuEfWzNHCg==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d7207d3f-a42e-4304-b4c7-73aeac93577d/156593f4ffbc65dc2dab850ba37ca270/dotnet-sdk-8.0.308-linux-x64.tar.gz";
        hash = "sha512-8m1Nq7xU55JkNT0NFKjfXfcgIDwdBFXmX02UVx6FsZQLkRGpu7FW5tsdRnVulTS7PJ8YQKIMlhkB1DC48bvmsg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/711b3696-81d7-4369-b9d4-a80190675959/4c08677a37df7a25e2eb44e05eec9ea3/dotnet-sdk-8.0.308-linux-musl-arm.tar.gz";
        hash = "sha512-t3BbTokac4uvhzwjrI/2B1hIJGf1CPVD7lJDOL/hyy2geKGWSSf3I7e+7Ojvw3nQrMFmwHRpEj9m2tZByzNGqQ==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6f538f52-0116-408d-aee8-0e87d24c2f1a/14bbb255527d485953c961ae93b77778/dotnet-sdk-8.0.308-linux-musl-arm64.tar.gz";
        hash = "sha512-uymg37bO1Zaes+NSWM1SYmu8erZ5jTH8p7HNnIpbFUtatgbY4LLjkS+Cd9LrD6o2xdU1vmMEIJ9WACC9j9x51Q==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4801adb8-3aeb-4a4a-a2b4-78d213f7732c/a5f025926bd2463241d8774f4f6edf3f/dotnet-sdk-8.0.308-linux-musl-x64.tar.gz";
        hash = "sha512-0uRsDETmchy1IT+60JtTl5nEiOvqMp5C0CbR/8mzf6b/U9IYKknjmkBWPGzKhejNMqMIfzWHPbnzKbLaq8d49g==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/32218f90-bf6d-403a-9a62-35ba8d60bcad/175821940686b243c81ff8321414a79d/dotnet-sdk-8.0.308-osx-arm64.tar.gz";
        hash = "sha512-SHkJ6KNt9vK4o8iGdqLYBMza59dZv7li1VbqRv2Dbif65sCySwDVSXbTI/BNvrJxUGvNKrKEpWSkZdzeXpSDsw==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0776860a-7d0e-4e55-94f6-b87f0f219b0a/a0400cc3a044fb101a2dab8616f6ae4a/dotnet-sdk-8.0.308-osx-x64.tar.gz";
        hash = "sha512-oWfJHRwDZyLHyv8SYaibVwd00eICCWQlc3fwZOmQ8FSMZo+/K2Kzcn8QEUbAV7AAcQbJfXO+r5i0h2WimpNwRw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.112";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e9e78298-4150-465c-969b-8b1d2fb069e9/88bfb81d6fc900bf1b68ca3ab7631443/dotnet-sdk-8.0.112-linux-arm.tar.gz";
        hash = "sha512-YUD+PrzTdQD7AY3JmoRyGROee7sTIlUM1SHgP/Litz5sWn6y5g/dqhDTDIqeJVje3rhFP4UjH4EfTU2ZkjjRgw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f6d8b6bf-4e75-4ba0-a1e6-cb79255b48ab/b8cb663305eff90d17ac97e46e1e0066/dotnet-sdk-8.0.112-linux-arm64.tar.gz";
        hash = "sha512-LXwd90Dp4lxsNyJuuuZBIY0unjn/kKks4aWV7a4ADhmJ36iRvs/FOTQO3NkPu5is4yuOFrmY/wbHdBGh1CBBQA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/1f338ac7-da1a-4d21-b78c-6c769b9c2dbe/5fd0e2846ef9f7c8bf6095ce201f50de/dotnet-sdk-8.0.112-linux-x64.tar.gz";
        hash = "sha512-3smWKLZ8p87unQvm423udnI6IQE43sBap4GkX0dBAnVkRC50qYav6HSRmiYxw+dVVexo5MPkdb0vgHpqyqmJ/Q==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/672126ac-5134-4b27-ba18-28cb02fdb168/1eaaea4bc9a463f692abca1a45e9b5fb/dotnet-sdk-8.0.112-linux-musl-arm.tar.gz";
        hash = "sha512-qXiriguzCicsRzDD+TVU3qAw1mZlkrt2BAR+vzW6ZlGbrl5eRK0YhVXwHETvAAkn80Mc/Ewt13E5e5hee95gpA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/933119f6-9819-4a3b-b6d9-e737054bdf60/9d27ea1e7a5d00226f4a343f2cda76ad/dotnet-sdk-8.0.112-linux-musl-arm64.tar.gz";
        hash = "sha512-eQub61Y/9dwGzjLt0m5tv8O+a/nNY+Wls7SG76PBpZX9n01CVMv37948MuhUL39u6DKQ5qbl4fchnruj733M+w==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/7c1c61b0-ea00-4eb6-a97a-31560c81b5b0/f5a5ede05aca2fbaca5b1486c2571462/dotnet-sdk-8.0.112-linux-musl-x64.tar.gz";
        hash = "sha512-SIMgFeCtdPw2dwhgRODuUAT8C5yvKeohE0RKBBlD4hOO/r00eAq0tjGUt5TfgKOJN7RgltmiDIMttU/gWEPSSw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/30dda97f-e407-4887-9218-96062c82d51d/1fba1e21b5e514a007cc39f97e38d60a/dotnet-sdk-8.0.112-osx-arm64.tar.gz";
        hash = "sha512-4o/vqA6KXu+huO18x79/pZIfOBz9OxbC138V7TthiPLe1OFYKBqSwn7lNJ0EoEJeTKZN7Oo8oHGLMEfh58ureA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ce94ae9c-4627-4b7a-8857-eb50cac41a0f/2c8804a1a59de1abcadf19deb68ef59b/dotnet-sdk-8.0.112-osx-x64.tar.gz";
        hash = "sha512-KU3LITZvQjGU2tlWqG4K7ZoOPMImX/mxv2HHjxrHg8YUwloG9k5rNXkBNbyJnkFN138dco9Plcla1XuAAVBroA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
