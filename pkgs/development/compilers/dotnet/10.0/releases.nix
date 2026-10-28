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
      version = "10.0.14";
      hash = "sha512-eUqw1tTYl50akv8nNFnUZvyHXsjlx6xd3uMN4V1pNou9b1vFq2+XcWUGvOlU2/sgzuKHtrEFiEQzxyFEpTmEnQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "10.0.14";
      hash = "sha512-PzuvrER0jsiaaQejCMxdu9e+ROpi9aTrGQMLr0JQpNizYm55QzXNvBo+9r3+O5JNn5CyP847pWS9ScU5eig6qQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.14";
      hash = "sha512-tz3PuWZRJOQFeLhceC5wyMP6UO2YVDh5nPhD0F03b//m1n37fa6dSpDz5f7g5fNGNHyQ0RBZ8j+3UfV2WurkEg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.14";
      hash = "sha512-8xmkl8ngucEaOgvjRDIr3I4K2Xxx5K9ydiAWSs6fw5AX6MWkTBSF7cqYOrRWaLa0Bpj5EfJrPTSUqSLGgJANBA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.14";
      hash = "sha512-obn/HAYT8K4e5aBYP25r2hlbFTdS58QMsUcwFEnxDIwmRJSeFao0aFGdmVbtrU1QIzSshSBXmqB+4625w7c28A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.14";
      hash = "sha512-YgO/Gkx7Ebb/0FIjQoNRdqn2e1IuzCZaiT3KzPkIIbTvQ17QRGfYNGBCDwkcMOtx2JOzWn0Kwqnuh6SdbSfZqw==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.14";
        hash = "sha512-9rMkXLzPCsNU/9iJlG1YPcPfxbHSjj43BH6cjal3GC33+heraN2VXOTR7NVnV3DhQWuKI0/ODER7HdgxGi5J7g==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.14";
        hash = "sha512-u6q0tjYatAugSxoDrAG6vYVcuC7Nd96s5WXLHCo7AGBk4T43kQAZFa3YIpDc/oGbO4VEvzRvaaQOkxtBOpFNQQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.14";
        hash = "sha512-UcpmRCl2A+RfQuHHs6CxaErtOJE53heqABJSIRezy6Pa4wrCi5heEi95DMYepn3r8QL8zz5CptiwR4CA43PrRw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.14";
        hash = "sha512-EtXOHonxkJL6n0wkN2eQqrI7O4P19VF8HHGfT86XMZaEUgXYg6UftnJ/iXa3re3tE7sSOIF4x/Kg6hoaA4E02A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.14";
        hash = "sha512-m/ieK6s5RbG2CPljI+m6HdDkFg72H/ZSlanRER4btNulnlUvhF+/KJuVZOLM/K5IySJ+RiG6aR8In0uiOoWqig==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.14";
        hash = "sha512-NAvr/nvfKQaXAk8oLm5c/dbiLdh2jeDrSIRzM2+0ayCdCZ9Xs0Pd6eMT0m2Ma5gHvFQ4KrUVYrOu/Y/2SP2ugA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.14";
        hash = "sha512-8/ErdL8DoAYPpVAOZyVuiqgvYK/kDngUUNO6vnX7/GLCHPkdCL5dUSrc8MFRY9SV/0LnmG6J8Gfh9v8hNWQmwQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.14";
        hash = "sha512-LGYEDpexlvEWfKYf/lntCOQmXWClhkeQW/5wqddzMw4UE5C/iD4G0uMmid7uXxXs/xbZCn3gtkaYgCdKw85qdw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.14";
        hash = "sha512-rBvOXLI6pWDugbrcgVL1mmgm8slikPdoTB4OMZBO24AcabRXvm5U2urwWr3ucKZ3JzWQeMw0Fq0ZSh6E5velEw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.14";
        hash = "sha512-s1yCp4BSwdi/LIYsO861cmmoxH3Ww35Qh8HPAQs3BRa+i3j/XF+ZMVvoon95Xr6HK3nD1V8ssea9NGzS0LNvXw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.14";
        hash = "sha512-DE88Kvw59+B6XKWhQLwhHOolbYEkNB/HjTtkTcspk834de60iBWnz2D6Zwvck93GHUxTFrGx8PSbL1m/VYl+eA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.14";
        hash = "sha512-U3hoAD9ZqqCaWTwWRu8lr7ckqDF5qXQhkzGW0AFEGjWwJ2qO3l1IMrL26Vso43WM8fhYk+bsIj0Gmjju7gXeGQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.14";
        hash = "sha512-soeEvzKNynSs76bFNBtgWWPg3/2ZW3t7TUyAUEYk5+PNlsj3/hJyJHGHoCGryV4Bs0wFYSsFVj5+TZa2C+jTcg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.14";
        hash = "sha512-z7/XiOwSqWTIzDZqO00IP3extOs7il1qwFNa6P87rVpnCp6e4Lxgg+nH2DrFVcdrNc2ai+9++i2303xn3P4lAA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.14";
        hash = "sha512-Fr7IdXYFqRCfi0DUs/oo/Q3YgCI9UX8/l/NHoWW0B+rKABfvuozBtkpCTvjabF9RoAb7Vd9vCxBag7dT8KAhDg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.14";
        hash = "sha512-28U/aWOlu44dhBelU8NZEr6ha+D3t2aI6gt/PzQSuHXzCMsla/iRJ97skD/YmBsly7+fg7CHDBkcYPlmRWAX3w==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.14";
        hash = "sha512-OobOegSVcgAm0CHzDql/CdB6otcE35qsvoC/LmBrUzHmizLrV1c8SsvHa338fqipTEX0GE88Tsr1l61BBjlR8A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.14";
        hash = "sha512-ZiiQBsOdluailDf6kiMGIqF8fN4nllbQf/B39Mrkc+n2CMb2ZLc3g43GDo4T77aDV6gcmLYCNf2Idxc0AQdZmw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.14";
        hash = "sha512-SkOkZsJm0lWQqM1U34kM/zyEBrlhn3TGBHpNZFWOTrebkQL5UMdkjxwfK9Opuo+mvBq3h8Jr1lTLUOKyriGE6Q==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.14";
        hash = "sha512-ShpJECGjtRvgCV3bBuSEWX1BD7YK0sWpWOIotb9yt+akylct4+eG6rsQNBjhjYpxli9kYJmK+m9vHjrBtLn4XQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.14";
        hash = "sha512-N72/TcpS1QY49SEe1u+fILXWldLyPy02ILFX5RJsqoEmqJfW2b1tT/x8eeNmaHbbLJ9EPlL4CNTqhMCSsNQAkg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.14";
        hash = "sha512-g+1Pgdaw7gzB6j1/JF6jrkoqDXrH9/oVSbggy9txIgJAjHbKgegzrFmdrI0m27r4zWLaRTroU56xhssFr6eRIg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.14";
        hash = "sha512-65AaJ7Gsr0+UtsQ65yrU6NNlfkpGdgpJxKk+jXsranU2PQFnu3pqe4h1JgQAOxMwF8pkNtHhKV1OBcEQU1e3tw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.14";
        hash = "sha512-I6iuyU9J5B62jvvsJVGRx8fq9PwGPkeK16mgmejYqT0bWqai7k2ax0RRkCV/5A2669ZotJvrpi2iIJBT+W+rgg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.14";
        hash = "sha512-OtOLEwDfeIWJNsF3EPUOEx6YWrN/bSjPvB1mYzXrvjBY1w4ioShlM2f+7Wzmk+pTWICqyr7B5Yz5h2NawMCI7g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.14";
        hash = "sha512-MU2CWnkhpol8sJXzZ9IqxVQLjHy9cqHQahlI91BH9mbCoV6uRpN6q0Mj5pJLN9qT+LyAhrMhpari229D8QG5hQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.14";
        hash = "sha512-XVcOnSgh4EnuySXtcnNRlAer7C6LtXvyT61deqzgHHt4fn0nnpgwiC2zaLkhb7vl1LT1cHeboGc/FGjB6FG5pg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.14";
        hash = "sha512-Kqx8Uz6dy7YheWnItPBlHkuiVvr6QONFAhFrK7Pbyp6ixMWWcS58/ToRrlXEe9eo91ZmtX0qx8CV+vNp8Rc9Rg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.14";
        hash = "sha512-kkt+jqbr8OFoAuwLZ5mUKEFnJC504Qwqhgtj259288kKraAPNArh5usAHHSyoUAX8vnetInPHe7ccHfG9ykLnQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.14";
        hash = "sha512-Cp+0XHjY+V7Ac2boAkKymKHAAvmpitw231tj4LufSuSlKTeMTRBQvjkKXR1ahkY/x+eCJQu3TDIGNmOgElkU0A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.14";
        hash = "sha512-LqyCvEWkMshyGeeZ1y1KraQ6czMsISLmMB5VKDT4addsZysxjlMC7WbCryVokdAO7juS8htBOZ3+KaDY5FQ6FA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.14";
        hash = "sha512-IfDwQKE3gcK9u7iU7C/bOaqLNfoRf6zvXzGLHsJAbsC7Shwn5ztRCRWjD1mKRk5XUrPO9VWSC1+q8oimXRDlsg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.14";
        hash = "sha512-WdN/aKRDOjgKZZ1ZF9HAOTZM46rJYElLXoI4IbEQiJfNdAqFZYiXZ3mdBcgOmLuf5AVTeUg3ILxgkyE3VBDf1Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.14";
        hash = "sha512-IIj3QW0MZPRI7NOKO44MpNCMcgLo9+z9/CqWVmtejV735Aap2/cheQ7yGZS28H93+yu4LEKWy1SBcLi5Y4+DHQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.14";
        hash = "sha512-v8ircDX238iomoF04BL6nWLuiqO7MGiCO6VFsBlV4VYSNYgapxmxiQldwJteA3jwC9apaomFvgy4rxeIt3YCVg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.14";
        hash = "sha512-XilNjytmMPmZTan5nX9y8XvTyxN9/KGxPx2WlWLUa+h9lJ8g67b1H8Yj4C+K0LixjbgtlGO5xlHHf4uUK2Gfmw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.14";
        hash = "sha512-CLHAGeF9Xf/lXB73HjLxX53hMz2xm3LWlF1U3Yw0F80KH/CP76hY3a6Pa0yHI10pkpQ6k/NuLJ7UM70N7939xA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.14";
        hash = "sha512-ZgjTTrzm/+xVXTs+MdgANga60kC0JreFffaUx1MRLtpgxyCo/ucI+5slSQTIdsxEyeg7xnhefBklRg+oi/ridA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.14";
        hash = "sha512-5bjGZtoBn20vmDNE7UKGw9Cx4c4GUiSd2tO6VXqzycrIN3mUIKAa471irqfy+1MYGJXO0869iEug+O25VTtdxw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.14";
        hash = "sha512-qdJXw8GqXjSeY1JzOnND7NqS6EIJ3ENeIgxUJ6Pfd0+zNGigZQjrZOWAS1CJQosZYDX0qDg0/hCFQGyE+QEX3g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.14";
        hash = "sha512-XS4LNBTTYXNneWjJjgfWhEGnSYAYz3TiQg12UZQWCQV7ms+AZ9HbONX/O2UZqyHAOXRM5LpIaRQ9X/dtft1HSQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.14";
        hash = "sha512-gd2h8ho8PYx5o4ZS2eoDbgL3qBWSR15EaUPbYPkX7I5L6imQpro60FNIs0YJLacqQE6G7amHYF1wWLWacyd+3w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.14";
        hash = "sha512-7UwGrgeIXSytvu5bGQHOCevIOX/9lMLCTTLcJNtHfXhirEp2FqX3tiBEZgsxmae4uNrYwVThjQj/J1FmNuxmYQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.14";
        hash = "sha512-Ykhofl1jAu4+hfUt2/89z6cbtpisnobwR+340N9TE5qXk7UtMl5fN/jxza/hezlRRlkPU3RCPsGRBMbpTXpwFA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.14";
        hash = "sha512-00rrk0lrVjPzOoBdZmaRwhA44K8+Fi+2DIcXsZNa+H6LvCM9tuQi0pdcVTFnmyUuILt245xo+U036NXtwt0chQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.14";
        hash = "sha512-KyWzrh2Glb5W90Y7pwgm9hNctD2MHTUXxEuACHlhKWZoaf7T9rJL7/IRobRpz9vaybwWtGyfC8Hc2cIifTR9zg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.14";
        hash = "sha512-u1lsqblXTPJdwtSauZdCv7U3pYdAsSXjvDybS2Rl/rGGOLqMP80ljy/J79W9Ck1OsQFwa7297qUjm1YIwFOTag==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.14";
        hash = "sha512-JrLaNFJh+iGDC9zaXhG3qwYULfKpApNl98VhlOEY2800Kxt05rlKKDCUoA6KUqFkCHMEiqvk52SGkKJgR/P6ew==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.14";
        hash = "sha512-D48gGGEx53DjsKJ3bhofq/4V+UomqsH+5EoE0tdhCuIbDgd2/zhH3wIoS/f7DqJ01t+RwrrQrVSGjLzl46L2Sg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.14";
        hash = "sha512-SrQC9AOp1y3wumvs0zlnP/v3mBxiJtx80fmuIi5BjfLwMfTsM0QS1TwQNoekMjIczddtRnwIJgQkx6TpsQkoPQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.14";
        hash = "sha512-seOrLS1kMyoJvCa1fWEmjYCiVGB+Qv6C6j4YndDtHrIb49wMEfH7I2JnMV5bUuPMTRJz7F6GyEmFSAShy93Eag==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.14";
        hash = "sha512-aaaa/7gTMAMy7wlLle+AU0VZhYoMUBmImsZI9zcdrpSiZvb1GVVzsyQnwp4vEg+TvPRwm6qQuWisowO1q5AhKg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.14";
        hash = "sha512-gE41ik4tF2dSyYm63hJVseHNZdj0WNBzNFl7Zwv/AiyPxk2oE+pzqQIQovuRfzh7XPsJcUnLg2Vvyjt/lcQe5Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.14";
        hash = "sha512-SaeXGZoDmwJs/4kLtoaLvpFDl6lTOEytpx/ZR3jtqVRI44farCSXizx3K7QX5T4sBMgLptfLF1Z0lfdGO7qDpw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.14";
        hash = "sha512-zrBKxeWyrIBuxESzTvusPYG49Pl7J2ajUmxqd6MNuhj07d2QYH/kp8bSjci/10dYQ30+tEOgoVYkuMkNqEEYMg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.14";
        hash = "sha512-YDHtb/zQKor+wQJpL4QyH/iBdAgXz/mpb6QMHU7dh6d6uKWHSrvmrtWu7twDJJA9D+JtNjUS31OopD1UehBeWQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.14";
        hash = "sha512-OQVIOSu5UGOlBhTsaYRyrtRiwbAEfplTx+Ln51OU332ZSocOskRFw4IaaDJ12Ke6ekFJGAd3i2yLFcjb3zmJbA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.14";
        hash = "sha512-pvXNq9Fh9CJsaBZo3RBPG1HtCcIvOxeoCzpQNg0kiuNpqZ1egbe5bPDzhTxODyei+/nsQH2UMvyTfyyH5KQE/g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.14";
        hash = "sha512-0Bb2ZMdtEr7DZGZ5uJtOmTFx83tvy/dM8UYGDVa0eRJ7BAmeTiZYZUfUJrmQSrSU+CymP5Do4T0Tpt0HUwLqwA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.14";
        hash = "sha512-mSR4ZA6Ntw2QBkqPFp4s+k79RRdg0Z/P0u2eGIbZtfmnbQLPWFqj7FGjE7XVdLOLeHRXRMsDDeI6XhZsTx64MQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.14";
        hash = "sha512-sFXQ5snIEdwGEn8umr0TxoLXIa2ubuQZFSzRogkLW/XQmVOLb2hwdmDPl7wBQYc0rb4Qo2eUEVsjD5elJFQx9g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.14";
        hash = "sha512-VX6JXS+AXtCL8brqXN5qvXmOzrlHOraG5T8dpdn3O1IL2knDcR1XwDNWZc2lLWuyg3u1Muu4zme2C5VnLOBoMQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.14";
        hash = "sha512-DyXikUG15BzvPGxe911+gE6zrn3Qs+NIWsNE2x1d/2N79ZJ3bCXkIumyLyb64cCNEoIoqwvQ1FdkZuxC7lit2g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.14";
        hash = "sha512-ZmSPyo5Oz6UDNE3+moZ6VZBKNH/tZRNvCF+j8ssby4eKI0FlTDMH1rcdszdrk/nRhPidzmvg0XdPkZ02ZEG6Kg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.14";
        hash = "sha512-1k8096BmENepiqExfgA3ndME94v7RqMqTqLrNMyN+FpqD7WD6jKL9tYrYWi4WKNCAgvRMFVlAidzA3s/FDmIQg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.14";
        hash = "sha512-Kn602fS/n6hsgpCW8HzykOu31D/oNrxhETNlgoou5yj7Zvvw9KWX3GnG7hevtm9R3VKdP1kPEfQ0Y3eo83YafQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.14";
        hash = "sha512-mLWGagTP5n7nMfJQI2XpXRYgvPcnyYvAc8ZiDfum8ShM0UcrPDyfW4Lqo45UtlCHCucERUHQuMTI6ybVweCN9A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.14";
        hash = "sha512-uLCz3X6KYE9BnYOOG/iHVO1q9usRUJD44J4c9H/EuXm3lNTT9ZCXDwjqF8aQCQVItq9/yO1Etc1TTi/GueI9cg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.14";
        hash = "sha512-932Q01OgC1k4vtlOWSqCT3+fHDken18kfcyV5sNSBMrKNGuXs9XBcK+GqFeUS65BgWRao4K8BhbaJYxJRythsA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.14";
        hash = "sha512-IxnELWV90TtAsOxP+F+ybzjDljfVuAKF7yDXFnEhY1t0LIi45GRosgx4QBFILBt++IsVuK6BktkCH1Fpt28/3A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.14";
        hash = "sha512-nH+5l3opHzzHtkdPU1GSyPRc3EDVYT2Iks/bR3X22aDZGbQg3vCjAbSBoV82fUVvris7k6vCjpYZQ5edp75OUg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.14";
        hash = "sha512-QSPp/M2T030+HPgeXxD7fwmX5lSPVKP5CEddOBBd8zHK2QYdwXsGh6OnzF7G1rQk3eNnWdS0VKmGZUjHm7C5gA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.14";
        hash = "sha512-ci8owC2bq9Bz+wgyXAnTILul9fjQskeq7sO4G4RJHGcdfByETQt1j3SRGB3dt8wRQF6fCDG5RvlUw90eGnNaLw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.14";
        hash = "sha512-dBy7TZgXlK1x05MWLpchHvYayVSO/BiZcPGG3AsBITSkIHUVSPeqbFJPESWYUPhuPI5zjIi9YMYecppvFv9j+A==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.14";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.14";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.14/aspnetcore-runtime-10.0.14-linux-arm.tar.gz";
        hash = "sha512-wFkAcTEbMvPKZQ1TmvIgbjwklOPZGMFYEXZYCmbaVCLGXA6PfdxRAXvK4xJ7vvJeqFF+sWyzVDUsuinoJrN19A==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.14/aspnetcore-runtime-10.0.14-linux-arm64.tar.gz";
        hash = "sha512-tdXvjq7joOvSSjWb6aCkz2e4C44uObVUJ3eOq61iv2OQq0gQDTsTTRUkNrqho7v/FKV2/qGi8vejlnBwVjYa+w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.14/aspnetcore-runtime-10.0.14-linux-x64.tar.gz";
        hash = "sha512-3QJP0mFpJqVVt1y/eoNvbc6ZgZnwWW2ddWdtyiudWcjuhnPGrCNHPA8aS91Z61zQL+mrCX7q8t2Mi9EXyF5wMQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.14/aspnetcore-runtime-10.0.14-linux-musl-arm.tar.gz";
        hash = "sha512-Y37jxLGTuC/m3MtVP7zdSBolNgLrobAF+0lHQCDrGQaGXkJ2EOQJYtaJxv4Xb5g5s2RxUeaGaxTOP7M7h1Se6Q==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.14/aspnetcore-runtime-10.0.14-linux-musl-arm64.tar.gz";
        hash = "sha512-weq9sFQJdPUgmpNGJ5jYSDe5ypbqcHJAS35XHSx0VNCUkCU0tVO9hT6BcseGwtf8HSLQ+KDtymW+2kQ99rMqqQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.14/aspnetcore-runtime-10.0.14-linux-musl-x64.tar.gz";
        hash = "sha512-LPMIg8C6jKGpahWBpwcs7CKaGafcJVjInSqp2YmOLPiv6mu4489ZaHWFxm6tfauif+Yx4kHXKQ+7KUQl7XTFjg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.14/aspnetcore-runtime-10.0.14-osx-arm64.tar.gz";
        hash = "sha512-IyOxurKuci6rJXjI+Ds+JKA4vRPC6QAc38NDcgGub7JrOUkguCqPGSrQjRB5GkDjWifb/F47s9ZupwPJP9Pj/g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.14/aspnetcore-runtime-10.0.14-osx-x64.tar.gz";
        hash = "sha512-AWM3mm7i5jWQV7ItTmiUFky7QXXpgx0lIeS9rOd+pmrJ0VjiiHE2N8vPRVBxhrVQiJyXBwfMgj6c2PrZJQzhrA==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.14";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.14/dotnet-runtime-10.0.14-linux-arm.tar.gz";
        hash = "sha512-Ut2rKbr32iW6eaATzt2GHkleAnY1F8d50C9Tl8j+3hX7wJXwprsh62//CgkpNkWizjrjyx72rgprivGsW1PCTQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.14/dotnet-runtime-10.0.14-linux-arm64.tar.gz";
        hash = "sha512-meHW61096TWFNAT9N4x3y/gTvTrglIN7WliQAKSSwom/DQHYpr/5m0RwVy2fhdwLQSObW3gB4DEZe4PVJ83+sg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.14/dotnet-runtime-10.0.14-linux-x64.tar.gz";
        hash = "sha512-Y0MmAoZF84cxyMTnGmg1bkyg1rZgcTmiNKt2Bof3QgY+2vM6HyDdphV0LS3IMAyi/4V2GdUfuzgJA4O3EzSviQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.14/dotnet-runtime-10.0.14-linux-musl-arm.tar.gz";
        hash = "sha512-1C6NGuhOZqqmEFhdTEVeeg8LTTkol7QtT8cY96I/JtahpgP4oCCvMZAlcypIXnx8XmQhbeeCmkVVy6o+VsgiVA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.14/dotnet-runtime-10.0.14-linux-musl-arm64.tar.gz";
        hash = "sha512-CPGd053+cF4TM8PuY8N74CfgYndo9QSL5r53Z8I5rKD4Og7TSsBEXNL2O79e3ZSDpqwYTiY5IyhPKU4GsPZpKg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.14/dotnet-runtime-10.0.14-linux-musl-x64.tar.gz";
        hash = "sha512-tuGFWz7OMx1tWx2vTtCiCZMbhSfs6F7/bYQ/8+a8zUvIsMSEytp4MqRTz5Ew6P6D35YfEp/PTmEZmtcBgUA58A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.14/dotnet-runtime-10.0.14-osx-arm64.tar.gz";
        hash = "sha512-GcV4HcL4dgCGWIa4d0pMWFHK8fXPP1kRhbkisOUd6muMDtC/gK5NO+Lgg9tmISQlh0Pnefq2iFMi1kHv9SsDgg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.14/dotnet-runtime-10.0.14-osx-x64.tar.gz";
        hash = "sha512-sT1FPmDz1xh0OtpXENAXRSTL8W3q10qmKvbMJYvF9zEOjsmR+pNl+Ev3i7GYQX3c6xOBrPVX7VKrAwCiG2cVlg==";
      };
    };
  };

  sdk_10_0_4xx = buildNetSdk {
    version = "10.0.403";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.403/dotnet-sdk-10.0.403-linux-arm.tar.gz";
        hash = "sha512-pTsfx+DVCaQP047j35PsAK6VFGXQIZjMuafU6tYRseJifuI1Pfb9HyVZWlWWv9NvOM4kn3shfEMqaTpan5yHSQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.403/dotnet-sdk-10.0.403-linux-arm64.tar.gz";
        hash = "sha512-CWaqK3D0Z3uDGb6d9Eenig3NYWSDZCW1Wmj9cU9AI/64e0ysIbmplreUcq1USHzQrc0qnf1XDisqHSZCOiuqmw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.403/dotnet-sdk-10.0.403-linux-x64.tar.gz";
        hash = "sha512-t7PYRhz5iwfSVSzpGZcC+jrQEKwmcaX4zVE291NOUPaFW6e7sCsRSUVj8dBBVidqMc2hEDuQDl7s0NlHPce5xQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.403/dotnet-sdk-10.0.403-linux-musl-arm.tar.gz";
        hash = "sha512-UhqIXlndxchPpXMZJceQ31MJb7Oml9B++7t3rjLECTw9HD/byb94V0mCLp8oVeQMJKDb1WxHDezIGYknLs+skQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.403/dotnet-sdk-10.0.403-linux-musl-arm64.tar.gz";
        hash = "sha512-paiBQp6Hnw/wHoSnaNvAIuf+0PTC/kk2wL7BNPoYTRa0L5jh5DvBwP6l6c5EL+V+/Ie9wEAj4zf5sAE8hJvCsQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.403/dotnet-sdk-10.0.403-linux-musl-x64.tar.gz";
        hash = "sha512-fIWAausVtcAuKCI0UyrFmfaUCeRbpO8JwT6EhEHToJLE4DDvquy9JxiWxBN0KckNrz9EypgF+idGjMIyPGcKyA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.403/dotnet-sdk-10.0.403-osx-arm64.tar.gz";
        hash = "sha512-WJPGa0jqNnTH2hhQEFnWBulvNnL6vk1eQXYuaSx8g98+4LK53FoHhhkdotxBPXM1FYEBwUyTWrIX8xrCUpdw8w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.403/dotnet-sdk-10.0.403-osx-x64.tar.gz";
        hash = "sha512-zpXSJbhtJAHxEcKqbfD15oVcN1t7NKtKc9+QxW8rD8KkQ5jP5FXLaJZwvIWQAS6UO2THpZASKvmM3AZ3IbEiIw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.114";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.114/dotnet-sdk-10.0.114-linux-arm.tar.gz";
        hash = "sha512-8PfnoZdg9yIfoXEWkTKbMLte0IQbAnSOgvF7s89aUAm1UJeUZmJgFh71XJTJ++MP5pkyV6E6i7HkRGHNMWGBhg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.114/dotnet-sdk-10.0.114-linux-arm64.tar.gz";
        hash = "sha512-ju1sirZA8Gw0+EhB+b3wQMddm6SSb4I84s9WzgCcKpwR95UzLFWblg5PRs5Xd9OatadyJ07cQoYB35603wE2hA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.114/dotnet-sdk-10.0.114-linux-x64.tar.gz";
        hash = "sha512-ZdLqMaMeL8fmd6rXrISkL4Xdg4PN2QYPdcRprFU6CPzhjBy3bbkqsK6EUFxyJ4/VVWj0bWWV5qEh0v2fC9Ak3w==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.114/dotnet-sdk-10.0.114-linux-musl-arm.tar.gz";
        hash = "sha512-Fd4o4BaKLmpu2+r4L49rwuBvyWAEGrlQiszs0f7/0B2/DV+LM2ZYwhtGyVa2nHKzTd2QR9FqPaJ7nH1uBjIPUg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.114/dotnet-sdk-10.0.114-linux-musl-arm64.tar.gz";
        hash = "sha512-5uWNebxNBHndnbr57sWPPhHC+9V08RjER5yGlaO/+opymol1E1ZIk04iIOjZ8Zl0MBs2JO0gGGKZT1mZSvCTlg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.114/dotnet-sdk-10.0.114-linux-musl-x64.tar.gz";
        hash = "sha512-8OOBYVxxMGcVKDSjR7N44VdiPErtsIRgW4m2IzA5JbCsqc4aaNTBAW3f292WlMx7CSXb7oSbaoTvT+dPS+RX3Q==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.114/dotnet-sdk-10.0.114-osx-arm64.tar.gz";
        hash = "sha512-D2njLlUQf16CPTgQPiTaf6Qnnu2nuUhRyIsW3gLArUyy2ai4xVYHCaAxbRjsxcYYMEmsynfN31o0mPKNiAblYw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.114/dotnet-sdk-10.0.114-osx-x64.tar.gz";
        hash = "sha512-F4ABIM/1PmL+MDPkJn8TBm3qFbfOpABy4Hy9YcV8vnZssZGRq1TpupmLuisY2TRXiKqXpfqZHteAMjFjrolccg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0 = sdk_10_0_4xx;
}
