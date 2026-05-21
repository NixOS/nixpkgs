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
      version = "11.0.0-preview.4.26230.115";
      hash = "sha512-sOvB52dgtuR3sLYyb3Cg+B4FpmP1vCMrB0cxHjzkzPF8GsHlM0hBKPUIMTx5xAWLzPTIPU4xZJPaC9cxjBJw/Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "11.0.0-preview.4.26230.115";
      hash = "sha512-67Ggrr60W8GnuJxQ4MYUF5nDObgervVRN1+A7sqecLiT33U2HdttI8yIgiGJz+odecPfNkqs8ZTPWCibG7UDHg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "11.0.0-preview.4.26230.115";
      hash = "sha512-YFqrYZgZPiCPFX8ShZgkUCaZRZRFpYQ1s2nW5viVgP4oC79/L375dGneVzZjyocUXaG/7njL76xQSGfTXvbwIw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "11.0.0-preview.4.26230.115";
      hash = "sha512-XM1tVxzTTHMdrcbgFitjppxsnwz8rtxsEfPa/cqwr31GJAqYv2cdjIr601wFqza7C9MJ6j/MG/hMSKDDZPqQ7g==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "11.0.0-preview.4.26230.115";
      hash = "sha512-jejVFlJnx0gE8UxlyHQ0qwwyAcbM4IfFIWUvFNUWoBiY7AOsShBGY21PSZE48zPcbH3Bs2ZouDKPqvv8+T3Anw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "11.0.0-preview.4.26230.115";
      hash = "sha512-meGNYQOi8jBpQMo6v49GEUXlmItNKS7Gs/O1NgNkvHXgC7GEARL4R2fQANRB68aDUmv/YJYIsoNe0vEJtpm71Q==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-GnW/iB7yW2FucToowyrsEKsAocgYcrF0WJ9kve/zqGN+Ale6BRssGYB2QcdNnEGJgnDNZjaiZZiDKuu84C9Fxg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-XGjNNdP0RYZnULe5XUwjy+xAcy6xJTRbYac+BGVtQgHcSQqMa3aEmjHhdrm5zmrk5viDmNkeVXgFdGbFyrLj4w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-vZJuvUHupp9sQn/elRNlJV48eOnn/ipI/i9Es0iX8/K5G0gwFZM8x23RKCGguD3SixQa920iG9PIILO5vi83uA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-GPz+T9ekHDU6Cz77cZAb3j6oTWX6x7MWpQcZODG3oyYIUQDxnZDA4TyHa4oPP1M752AD/04YjDgIbc251UvfFA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-hB544iGw687/lyH7Eef5yG+s6AOkKYct2/tkYKiigyKYCyf+c3PpNEPVDqdSvrUl9dMFZcNF82f1Cd0K5iL0Pg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-QAIBcV6Pdw2C5aRfzdEFlqhtSOhYZEWfI7Kc50luQxyoc7AlFXvVR+emuhfG0FZb48IJK4k6AUuZegZn5jVnzg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-RBN5UyUj/R9+yDfLa9z80yzFkJdaOAczFbHtJfyvbc6qSTiNb7IWnxh0atAdy5EIw1XNpv9X/yNQvPCyjjR9tw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-7Qp2BYtuMoqy6KCvpoqzBQKbJqury4bcmhZ5XTD97tsgfq4rlImaqc1FpGP7YwCDiEJ/uTYyP0kPtQ6yRy1UqQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-6xK9SCyRm9XfrITszhNNemAVhED/PqiYLJQ8Dj0MNdWGt0mfOiMCeyQzxYjYymI7QZFXtOs5HUBqIdH8d6Tdtw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-wE2OCXdw9GzYMK3YKEwwfonKATspPbQ3uTvxIqOxZRNa7x8irEJE7mtFU18NmgbIqWDkUGlwTjS9Ery4pJZL6A==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-dG9xTx/svwU/510X5muBgOpnRiE9MseuVW5b6pOOKbFVMFkbBPyFJiE6OA/G5D8wFmLmhWJx7fbwIhx62S03oA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-pFT+Pl8REeUeb6k/R6M88ymFnOgT7wyXOm/Xv8NbhEbf+6a3zKujJ4unxHTMaxxOuGg951AuIDL7EJjZSnqmXg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-QXceP/hL/OmI996pgqkzK7ewK9F1JpoE50j/TXCMdFeZ9+UIclXPXmReGVVeiaF0vQn98ojHQ/T3Ek52VSXTpw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-r6mLNLoAxWjp4N2/wnTY8ACedn8AdYX8gY+KcadYqp23lHChy9Av8RD5+dExiMKOrrshr8RcjdnljkqLXq6URw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-KkHwIjKHdnFALQkRT3Tx7jC682rR7u4btTVExc4aTy1kQnMIgu5spw/OrOMtkJBJagIK8RY33AvI8vQyWa3tIA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-YLf0gAaQe3CTcFXbvGVo3Q/ycg9XLBfJawq4sr4sH9rMOhB+ffqfD7uRpltwUW3Pmnj4ATmrvDiGIk4rwAevDQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-2/mVvnQZSbDH8gU6RJsLvoaznvJ6bGowIp+e7Z5RTHANbXvimkUjNGDE40XxqzdNOi41yLcbkNXBI3mpTsVF7Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-liFPUkGA9K7bBR8aux92w5OeccS0ugLWQEAyImL/1aMNvDm8omiWrWB5aktSsPao6HBf+lEasH9ZpO6gxH9yNA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-igBz1OJcF0CQiRWyaOIftIcfCvveuUKtx5erFFTGItdfXVszXxb0/UQRgyXsVVMHLKC+6fJeJ1ClTr6GNzKiqw==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-Lmv5+83ANACntwvRW15mTPxiPdVK5TMUFR3iKqWCsMKHr1JdPA5JB01zU1NPzsCzO9rDR3XKFtP5lAHseu/jNg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-BJxyXvEZouZveaWlMFoKg3kG8kDQ3evWkV4Mhzgvz9M+JEwviL0qofWvcprIfTbiUNt6OBexOe0LqVL1DoaQSg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-CeKSyD+qYscT9uOuPJeXzsQqO8wdOKPjsr6TRI0uD3OXeKfZ++QBywKJfzYMIn5qNNbrKIxoc1+lhVZqMCpdaw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-It0pLBD0rzrGlgf4BsweinDCNnZCsu1KKtmN2cbaZVqA3JB6i/m2SCnrww/plwR7GqZrUPoE7fpBXAoVM1/2YA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-6qfPYTR9CQpK/6o9+e8Kv8lfnVFYTY7x+PAnvU00+nfSTPnBLjmqZaWwP5O6DIqPj6F8U/651w9lnN1uitISaQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-ojhvqeG+B2wdOPhDonifLvcPUs1Qqs4RvAkWHB8W+FSEHbEeujpsZPM4stdWhyYfSYgwS4Tdhag31yCKsaGOQg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-YbzTyrcsd3hAuKfnzJWpshM0aafXYVMYYoWMLzD0OKXFHurQL1beIRCdzn3QWJFc7PYu5opN8KKcBWuYiroNdg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-gjHdQG7gLRo3dm0CmTGoLsYRuKY3g8Yo1xhGVrvrm3eFaEuBL9mHxt0/qHKY6Qe9glPqa8yI6i495ohmD9+Y4w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-22zDOId553j1wLn1C6+WYM9NYOpsnhd3t4TAf9PmvjVXrue6UF/epzSR29AYQSFHUHcYXu36lskCxIcWxZ7diw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-LG+VKRVjQ7iZlR3ho7/1eZVZ2qiJYoE0HdR2EApvPHY34ppK27+mAUsRqcADzvmRSutGEKzVqAbZh9b5WY/8KQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-h73OQVRs+Ay9kWrhAYpTRn4yMyC8nfA70aZ8/PwFXp9O1/DWZJ1MlTCBmVjx+Sj2LAxxgsd/G/TeyAoXPkIubQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-4xPcgSqKvOTxIdDI13lLD1VRLx0NmkLypyo5D/JiwE+2kAeHQ8UkePaUl7DvKY/lBfUPZe1kTXfg3SAGixa05A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-rONsf1CL1LudPVWGETZGgpj24qCwk2EAWnqWz/7j0O8See6scf8qIq6UW7l8GbDite7Tk/lxdviasIc0uGgf/A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-d0F3uDzq3Ryg/aHBa1nQ77YgW685Z02u225+r4LIROdY1jxU7WGNu21XnWGEkqmweIfPesmY0ID8M8JJM+iiRg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-q72+P/5K/etIJ7i44gfUlVZ8HdDLQmZM3jpUB4g99j//go9aoCG8SoejTvK4+ADG+K5yIUTKokQxHgpQ6GnZLQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-P2++Mp5MRKsbdEz0ASwZBTgNxGIkpqw4ZUtkLmtrgYBssE3k9zAXmWym7Cxxh/tNMLjts0pW4GmAlUOF88Fezw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-/DENzVfc/S4AQR3uzbfjOaKlCnFuc6VSfJ+6gn6gOvLBaJUZkY8AFk23wy3EG+pWoRG3vOw5JTcSmdfy4wLZlg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-ffSHBDXQWHJgdwVr/RXGN14oWzi8/X3SHBInJ3R7manAbvYIZci/4I/27AgKgClpeeEbVhvQLLGGsg3gwwUw9g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-MApSYkGqzNYA5S52PAqJ+ZHy2re/aXG40VILlRDHR+iPW2dsbkIYnU+lr9yNJzHR5R5QWabkGFayMv6S1/3G9Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-3g+TIZdlRu0q8LysEyMfysFgwdl64/7PlJm4sJtpPTeuj/H9p/5jjNv2ZWSC6aeS1GvLkNiTx1uvi8goegnIHA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-lq9MTTn6lEggJ8mDssvdPHv+ucCoiIRWsHnG08vd3awZRz7hYDGR316ErjMNuMR4zHXZbV/RGaR43piBuL2YGA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-9/vesepyIPjLIY0LbP8DLAt1S/UKFPEihEIj22IRRPIRw61uHqtPXDloV/q5Hkq+JzEvM0NEdC2+K7mhWv5NCw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-9Uq4uGjV5JxSB8VxQq5gxCGkUpcxPb1o/Aj8m3RYj4xbUIh/aDSor31rzeUj55CoVcn/Kf7ohEjdEHJ5ql05MA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-HmujtEOwQ8rUdz5IA6lKobfdkeTQk4NBpH3WF4JmCzQiJ7q+FbOntqK3TMp0jofm0ARbH1k0N9NKj1tOIPfs/g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-4XTkXjSpxSmfsAq4bDHhSR7M1njC1ue7f+wcOlS3VXMtA1flkIFgy5Sm90TvmTqcA9HP/a/1mKKFcavqgWsadA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-0nnJLR+cYzOEufvCsbvVWS5THmeto3QSVRLsqT9acjWqSOsVSME9igsX+rfMTtHwe3AkMAI/hv1KA5ibVX7f3Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-fpPf42QaeHZvxz/UUKK9qxh/+X5aa+t2T1nLQ/BauV/oLIB/SFGJBMjATI1W1eWny42ecTSc7Gv9/kf9jA00zg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-7evuz2vNT26QtSOrb6cQox0Wt0flHz2Wh5gM184coNP5jSO6QovK+DndSubspM16rV4HwCwC3QF7J+zaZoIIGg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-h0tHbJU0x63+AnO9cCbqhNSTlOMk3dLiFAHphyDtkNftCvWgeET2rMX1zXQBWQwz5FntPmG7dSIEWg4Ut8rGYw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-sTsPSr842hTtq2C/MKQS042QOBcGIqK/PwNiFxjtaqSOfTRL19wkJSVs/EU5t58vzvlbKMd8AF6a5k99eZUaIw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-rTyL3lw2ZL1vpbsSzptP4qLDiIJtolSB3oszZKkAcVSxTvP0Bq9a0tgod+TUkmX23TiB3mL1VyqyXVF8NR1KRg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-jL9lrxKrSgjqNxETbwOW6hsTqdaRA5o5qkekAtHL6L9u3QeEJpjGJC+c0nUhnYG/eAwZ2WxvQmD67RlIio9dbw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-sT0KbIvmMRU0RaAKq44xzTIbva+egNuCzau5YfYY3Pliu1amV1RHnzO91zKQuAMTmSw2IwQyhZBCOmF8R9ABBA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-mMy4VK39Aa1d5vjyRcB+rjOF3KmtYSbGVqHp2HjaU1ILtyUFPACNbL2wxhh4EeJwsYR3bqO/SjqYoPTTztJpZg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-6fAXC5Ei5R7V5vzWTzYldfMSe7vdleh9zjN4SzlY1gFn7DyV93RBHYNtxTK/nK+UsyT0pqNEYuLDrayIxtDnYA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-dQjz4BoZVg0FgRIJlASPN+xFYNFEQgMOyZBCfy3WnQQ25sWvO3EY/0ghcrz63NGOOf4pZzhv+ORmfNHOZf9/CQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-X1OVu+khvi00Q5MhUnXtdK0c2qogQh/Z8b823gIqWdnaK07bldBN4OzVnbzIqujBde0zfobtb1UN08lPXympUA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-+R4FLjcOxf6eLSu63UZE3HmUjIW7CH06cvmKzGcQJqq5OGCNK8JvUsFE8/3e+Hkc2kh0xE9tseS+OMJgYtoYOw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-RrFHAtC7aMzZfsR9yplzGghvWgdiWwSe2Z6cYW1eRSH1eaI8IgnTfFhImh/g0WPRSN7NO9jAbculHUD4oN6CLQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-55D8bJbUr4+6XaFTAJwxGuXlSEhfWacs9XcTkC62G281Uow/G4vck0fxV7SfiQkBBGHoCojdsnWrYSvlCBJNJQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-d8wsGl6/ky+iPXXbt5PI+1G8JX7Bz5ZAcIElHlhiMsM5hzCwnEjGWfgLooRc8TaMPpSB1n+tnqLrvkkiidgOqA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-k8idppU/2PjuWd2tu1XSdu8+LVHh51wvcmoBkfNsi9S25GUc3IDdqbSA1xYujo06i1PKxuZuFc3rereRP6SuHg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-vrYBDLGltQrZMJWtbvAFQBeYujFs/Brpp+xDZItgOVagbwx05jUefqJrg30PcxjPt098q+pEWk7aLtA/Ty258A==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-53kUyhDQiE9I8ZDbtpVxLc6lDUQ6SqMkSUn++jeneKeLdR0Xhx7TnzB+NwLdjOVcWEeBVJViLunqp6Ij4HwsYw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-uJ7PTAL7HBslM0w+JvoIRZcVsCDHTEder6FaYchvyhmmU1ilGCbRDZjHMWgHdTt8txG0Pa5bCst39S5nAe6RMw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-CNtglGAP/SKABSb4xfF6E0NCIcRyiYcQHcrTcEqTQUwMhBAKQAE6VKI0cSBDxK4KZ4q6kdSMi+U9VqbtEN8A5w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-D16SlkHg+PLAlOas6xJY+AgrwTtNXZUiiQ63oRhHcpSML1rZy1qhQ48QFxL4JxIIIEKwuEkjdM4sR713v00tng==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-glZLNFOtJCPTyF0Eh7U7Sn+cbwvKJMZVmGWTHKaUcjdIYWE78E2GJ4G4n3EewhG/ReOtSesgQqfOn6rrgBldvw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-2NQXwyay1NP0sXzaaK+UJZZg7VVLAWuWXyp1hzl1WirnbKnUKsAkdxDPJ3JuJvqVs1qlBJY0yVpSvUvr/B7H1w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-wtUMMCC+J+ztAqRTjsz35BoogZ2HLVsnJNMlEl/iPCpTo6CeEV+g0kHipGX1JE88y7hx9EsvEymqoQHarHESlw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-4YFeWbR8+q3t+CwVd5JNWwElyxTtpGt4ZBQBURm0jb7oyp6kTrNPBAa5Z8L6SqbSF911KPPyUZI1KZokgdszbA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-9JX+dN1fTOZ23/xixAFq118j1vJdEKOgdkDUbQkD4wa2mVsD6DlzkwNJtbXuTOUS8GS/JzFizjtk6ZyQgd+s+w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-0vDJk7pmOVh7iDxUqThgOzPWgtm0v4YIMJ+WH83YzO+8a90UQzIMjgNZ4//XcxpSCLw3jjeVYUkeV015RpsZKQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-eekHcrEWDUQavHB6rJGt08F7F7Pxe88tdAemk8z/Hjxa9Tv5D4xX9rNcu0yWqZaz0Mxie/x+DwzxZlmtejqGMg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-Ac0bFspfSo7zUxqHTDxeWufwcl+1DeYF1VGHQxc8wFqm0/0tEoOqxKbahD30WM0dm44Rd+u7vwavHdPbJLTmXg==";
      })
    ];
  };

in
rec {
  release_11_0 = "11.0.0-preview.4";

  aspnetcore_11_0 = buildAspNetCore {
    version = "11.0.0-preview.4.26230.115";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.4.26230.115/aspnetcore-runtime-11.0.0-preview.4.26230.115-linux-arm.tar.gz";
        hash = "sha512-AwbmOVy021z4qo1OqQFpmN59n7goC8wBis75AMDiKvDbfpR12Na2HXHxdBh1RsvwiSV6XySgU27T0fwE1bOGQw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.4.26230.115/aspnetcore-runtime-11.0.0-preview.4.26230.115-linux-arm64.tar.gz";
        hash = "sha512-Xnv3UDshBlV7bia+agcdU+kXvwQJckJsnJIk0DGSTCRMC8ssqPZ9AZTxsJnmUsKjWEoNk4rBlZi9pVjbpOOwOw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.4.26230.115/aspnetcore-runtime-11.0.0-preview.4.26230.115-linux-x64.tar.gz";
        hash = "sha512-9lntUC6iwjKd65xK5eM3k/e3O/1ZqkdGH4taGAhI3nWX4LFXpKqNBiebMWPVksY1lC56CYgMiyjKN26CPaFwnQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.4.26230.115/aspnetcore-runtime-11.0.0-preview.4.26230.115-linux-musl-arm.tar.gz";
        hash = "sha512-StejwLqKnKPEzUfwyluifNSZTxMUGRhxdL5ONghbFEZEIhdegWEYE+oYkF66OYVBHs6+5pICpXOpvZ5WYs5GCQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.4.26230.115/aspnetcore-runtime-11.0.0-preview.4.26230.115-linux-musl-arm64.tar.gz";
        hash = "sha512-Y3omOM6wsS5ioOOcdeQK83LSHRSaC1J1iMmflMesSvhmLzjvb9vC3L7JILnF6oiBoAUh6AQxmdyqKP+LFBBn8A==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.4.26230.115/aspnetcore-runtime-11.0.0-preview.4.26230.115-linux-musl-x64.tar.gz";
        hash = "sha512-JXjaQaZuDwiEwHUTl4CgPcaWc4yVNT7suq+bx9/kuKt1iYrAr++3XgPKktJL8aLsq+ie/4UWHIm984qBUd3iVg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.4.26230.115/aspnetcore-runtime-11.0.0-preview.4.26230.115-osx-arm64.tar.gz";
        hash = "sha512-bkBhBnRoQrgJDgVuTui0T22iR4J/PlxaEHz1ztWEUJrTHGP9c0f691Ymwix6fI2D/oAbHX4VDbc12WJnOD6iwg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.4.26230.115/aspnetcore-runtime-11.0.0-preview.4.26230.115-osx-x64.tar.gz";
        hash = "sha512-miv7b6QfPXfXnG6DR48Va31ca5cUATA6LrGBu8nVCLCtpRa7aHu4jFDvZbk/XDfYc1AGizl3jY2JZRUvtzxKVw==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.4.26230.115/aspnetcore-runtime-11.0.0-preview.4.26230.115-win-arm64.tar.gz";
        hash = "sha512-XPMSKNGlU8MaGgRrPpEdHwpZP9jq+iPahqJyo6YIuURgFPAaNHcsofJcIx0yUwFiPtNwBU6NnUk620kbQ3fhFQ==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.4.26230.115/aspnetcore-runtime-11.0.0-preview.4.26230.115-win-x64.tar.gz";
        hash = "sha512-qwHFvhJ09E8yTi1j3FBzCrD+t4HqXfQoK4MeffyeWJHomm+nuSLncPPhP6nFruOe5j0eYX/kWGIFTC6J9sQgkA==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.4.26230.115/aspnetcore-runtime-11.0.0-preview.4.26230.115-win-x86.tar.gz";
        hash = "sha512-Vdz2QyEfuYFBCS1N1vS4ekux+6p7anKhhEH+lGhS6IqAGwu39exqfd78tYyN5nMkI5TihCKN5qHUS5aICQDoaw==";
      };
    };
  };

  runtime_11_0 = buildNetRuntime {
    version = "11.0.0-preview.4.26230.115";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.4.26230.115/dotnet-runtime-11.0.0-preview.4.26230.115-linux-arm.tar.gz";
        hash = "sha512-CJpVqPWz1HwCkw2rvzIS8GosfmMSIlYNactfnlNkLiGKQnmj4EJvQtYMv1xROqh1CFF71OF6r2pbc+yZ4W1r4g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.4.26230.115/dotnet-runtime-11.0.0-preview.4.26230.115-linux-arm64.tar.gz";
        hash = "sha512-NUJukm6vqRHEWXepKakXMhjAeeKiPORE1d+/mzZtVcgOwoXmO0nnG3cdG6CVoPBNDMdn7fu1vKi6LHdiF9dPww==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.4.26230.115/dotnet-runtime-11.0.0-preview.4.26230.115-linux-x64.tar.gz";
        hash = "sha512-r0Fq6t+HE8bbEsLQSB9BY9IQRhaQB8lvLJHjtJ0FtgLPXmI5FpbnKpWdkWt/R7loZngjFiLiytd+R57aYawyJg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.4.26230.115/dotnet-runtime-11.0.0-preview.4.26230.115-linux-musl-arm.tar.gz";
        hash = "sha512-LgM9A5TbtG5Al9RgWkWoFprbJAOpoL+1c6b2kullre7+OOs0QoDYirnHhBtjFkECSVoIQK3Kval87yIRe447mQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.4.26230.115/dotnet-runtime-11.0.0-preview.4.26230.115-linux-musl-arm64.tar.gz";
        hash = "sha512-jpaqfXQwdkl+dJjq1o+oeZ419587i0S4Ay8C859cETTxZFkCa4iLyJmsnb9sSJEzq9AlrRhmyE9uw6LUW4f5CA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.4.26230.115/dotnet-runtime-11.0.0-preview.4.26230.115-linux-musl-x64.tar.gz";
        hash = "sha512-RE+lD0i3w4u9ZYkkV17xQMH0xhB2Ck2TR31kTVSAVDlTbjwxcQAuFSwzNB6BCFz7nMQzK/RFNPkDNb8D9NHNXA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.4.26230.115/dotnet-runtime-11.0.0-preview.4.26230.115-osx-arm64.tar.gz";
        hash = "sha512-nYNE06waXEZk4RLBloKg3w76cAZLNSolUiwLkqDZJ674S4GYcGnouys+9a7E2Cu2wNEzFl+J4mIuDL2BKRnM4A==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.4.26230.115/dotnet-runtime-11.0.0-preview.4.26230.115-osx-x64.tar.gz";
        hash = "sha512-w84K19aT5Ve+wuDnOUl2YmET0xyIpilbeV3sHKkqvNlxGdhT2luU5FqZh1msPDYWRTQt1cfCQuezemsVz/UUgQ==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.4.26230.115/dotnet-runtime-11.0.0-preview.4.26230.115-win-arm64.tar.gz";
        hash = "sha512-nnVLAX7GLlWDxFIPLSYAbRA9tKUO3+JsgVyAZdlVyYB5RWr2BFPK9AzZAczf5dsdnTWHqRiidGLPZ5ZwyjFY3w==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.4.26230.115/dotnet-runtime-11.0.0-preview.4.26230.115-win-x64.tar.gz";
        hash = "sha512-g3iXAfdbENSLG8Up0XA7hlyCysiPzjbQH7TZRs5RJ23fyXmiG60tDx+9E+VcrwRmUDA8oUbNB2ViKRwL/aovXQ==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.4.26230.115/dotnet-runtime-11.0.0-preview.4.26230.115-win-x86.tar.gz";
        hash = "sha512-8bneJ1qPZNm4Stf/3d0dtzyddN2JrwZm1UjEiOzJZc5P6Ir2CwpaqmlDxxnay1Tb3vUAPWkKLkFwZRcKpx7q1w==";
      };
    };
  };

  sdk_11_0_1xx = buildNetSdk {
    version = "11.0.100-preview.4.26230.115";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.4.26230.115/dotnet-sdk-11.0.100-preview.4.26230.115-linux-arm.tar.gz";
        hash = "sha512-AF6shOPhaq7rQ3fjuIKrnOOvB2c1ylqucjDE9hwYU2VDjQXk8FlFyNXDHO7TVuGEtV6P6wRrAdytZR6F/gkTyA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.4.26230.115/dotnet-sdk-11.0.100-preview.4.26230.115-linux-arm64.tar.gz";
        hash = "sha512-8EiL/RfMnbtTz0OQUF/95Y79KGr42VmfU7bGUpkMcm3Pe7oEmZgqqeLZ/iII9DFm0UXsgKwmOXBHrhePKNDi8w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.4.26230.115/dotnet-sdk-11.0.100-preview.4.26230.115-linux-x64.tar.gz";
        hash = "sha512-9MdFGLyci5Kxj7rimceRaxbY/60PPhdo+3b4w7e0rTh1u4cYriMRCDMk+o1Y1q3PzD5K7Rd/JpQyty57Op3Yrg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.4.26230.115/dotnet-sdk-11.0.100-preview.4.26230.115-linux-musl-arm.tar.gz";
        hash = "sha512-4zJLycLGfvLhCFDJ91LxLTKrJUi6tqSRRX+WXRigTQ0gskj4rGUzBy8m8qmH5vrQp8y+NwM3QbE9scTnE/bTXQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.4.26230.115/dotnet-sdk-11.0.100-preview.4.26230.115-linux-musl-arm64.tar.gz";
        hash = "sha512-6bsTBQBxbOpEpfvTASsYf/hNkClHrd0Y9FP+zYOdhGh5zvq4lFvL6PDTPwcJL7GmVmBoUqdl5iDF2KHd2ssjOg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.4.26230.115/dotnet-sdk-11.0.100-preview.4.26230.115-linux-musl-x64.tar.gz";
        hash = "sha512-jeruEzw8hobVyT9yGbiPJT05X3ZxfFa4cwEXU94/QE18jSmID7RVERUb335rfxJzJE+/G6EyaS/qwDg9rymLTA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.4.26230.115/dotnet-sdk-11.0.100-preview.4.26230.115-osx-arm64.tar.gz";
        hash = "sha512-ZWgtu/rg941V6lJZhJOeDoAv1sDXINM6G1HQ30gIi94fuHCbU7VCFeZ87yYVmBQNjWD2pwZM8NfopaY5QWp+MA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.4.26230.115/dotnet-sdk-11.0.100-preview.4.26230.115-osx-x64.tar.gz";
        hash = "sha512-jDZnR7tmeLCGE7ACYI1fK+5dE+yRdziy855ClUfeoXsHP+iQVNYzos8l1y01r0uv6Tqiel9xBuZ1RsgXfViBew==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.4.26230.115/dotnet-sdk-11.0.100-preview.4.26230.115-win-arm64.tar.gz";
        hash = "sha512-/zVuRoMtC44Aw+bTm1QKtoNptLjJgiIX0TRiUMvWPwN4ekjMWrnBKBDGnPLtRhU9kaJG2ExqIi9kRfczlaHX+A==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.4.26230.115/dotnet-sdk-11.0.100-preview.4.26230.115-win-x64.tar.gz";
        hash = "sha512-M6qjPSbC/Run5JKiWOAi6S5pP4QyZ0PSgs2en/ERpKO/5p7xxuzSnVPxgrmT1YwSArwTcPKDy1dMXf/DAY7Cvg==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.4.26230.115/dotnet-sdk-11.0.100-preview.4.26230.115-win-x86.tar.gz";
        hash = "sha512-EkuqB2Rk2XXJ2u2YSzbsjJ/BDuRGwAVTs0WRQIdOWl8rbKeICvtqxnfvR7/un7Ya/VoS8vAKa57SnXEozTv1eA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_11_0;
    aspnetcore = aspnetcore_11_0;
  };

  sdk_11_0 = sdk_11_0_1xx;
}
