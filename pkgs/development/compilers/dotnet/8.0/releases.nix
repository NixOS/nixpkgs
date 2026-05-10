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
      version = "8.0.26";
      hash = "sha512-qZd0KpqCuGfIpyXlQs6JLmzL2oRHVJggJAPSrOQ8DJmOp8g3yEUyaToUK+dCGw7cxOA6iSVlUcjq53scKF73Sg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.26";
      hash = "sha512-RMA1jvyhYvkZxnk5KcWSyhxrPyO66L9pDb4Ae1uRTWiLMY+euoIw8stZjTzRZ25S3daPeLXGesEN6rhtewfetA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.26";
      hash = "sha512-NChciJux4fRye8CEQ24dZZiiv4VVoQZVto/Ns+5TDP2VmDAFp7UxjgiQ4eXntESx4dgzHAStyuCm0tCH/fQ3ng==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.26";
      hash = "sha512-k9+VAvNrxdJaCqMPTFcSZE/wtxqIZSREPWENZFRUwzkokS6Wjsoh4ksua3tqefKqaXWHnTfNaKwkZU+WXdbSvg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.26";
      hash = "sha512-dcHO+cQ/Yc+YrfZ1zag40c6/HxRDvVGMw16y+ugd1m12jXoE7sRmpHp5Nm1HqTgBipPmMEBrv1Nq74uTHyzcqA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.26";
      hash = "sha512-4gyTpzTr0XuIU7sc+ysGN0vbGNSJAT6EOyp05aGauPNTwJaXnSt8ISpMAOpcUExnYPcAsTXTpWJfoW+o830gbw==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.26";
      hash = "sha512-J6NfviBVYu6WVcULW5kA4PU3OkxRw9Uzxp6PWJ60EUojHmzWHST/NCo1IhWwW9mc6Fx5Y/XWMcjBJD8kTg/HaQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.26";
      hash = "sha512-RIgTsRnCZZSH69C/uXfzPtzvdAohdstS6F5h2z5PIsFATsSjsYXQ0Nl1JLO+1LIxDiayEOsqZ6yKz8BGVApf6Q==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.26";
        hash = "sha512-9NsaBD+oHiqEWQeChKeB/PDuvQLrHVHrqsV9VRSGGF3tj+VEzvZBnwYRpTJPQudA6MyfnP5C2L37W8q46G6xcw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.26";
        hash = "sha512-uaNmF2d/+QstnCMuD94VL0+MvM68o8gPGLAaIHzAiDqP6TZqdfMZ30BiNOXmSXbhZh556dL3JSYa5rA3LQLtBg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.26";
        hash = "sha512-p0eABauRR1SPDxtYnXY85nyLCSqrZDmFQU/COg2WAtGXzoVGEAFJq/9J+sjpW1fZ8RH9igLXBBOxWVsjixqPhQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.26";
        hash = "sha512-iCzZRr2JImT6u9HQ7cwEFY7dUxPjv/mcp+Rje9bWKa8vZ4o/wfleWLquaKvoGyKVDido1UhP6YqridJyBGVbOA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.26";
        hash = "sha512-BW0e59oIuyj2vAJL/KVAfjUZQ2iO9nJuIPO8PB9NfbAwBCvQLPxbbIsE5iVOfwQkh7bQvSYqy98S0X9YAn2dIA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.26";
        hash = "sha512-Fky0VDv/iTV8Dr5XG0AqdE4Myt9ttZeD4435XRbk8B4oBkSm5zQzREtydjd0Ji/FroFaaNa9IRa+mKjN+3pH3A==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.26";
        hash = "sha512-zG1HqqgN8UGkXXdpFVQqJST/TlAvLPioNTiukImd05Mo1OjIMYT4DRgvEA37VSBhseAF+l8oVma8onkSdw8Nsg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.26";
        hash = "sha512-LRDomJZE3bHW9XpdBnN1iAcpUCtky+6771onYxrOQsFJRkdovjW8t0DtWUHhEWGTBpK7dg8Y8GfhEKvgtTHRDg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.26";
        hash = "sha512-0rSxfjzs8CT3iUuBoT/VWp+5C2B9+2HnKW2vYjuFMkzrVdrIFG9Kl/gbcM6n9DRu50g010Aqmh6nEeHC/JyeCw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.26";
        hash = "sha512-MqZnDX1dTK9L+sKydqHjEPx4oULj412HYEO/yYub9CToEaeKNUs1jX/vjUZsPfMPRTe/tOwADURpGIWvORpB5w==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.26";
        hash = "sha512-C44+jO847tR78uttPy7GlT/bxQEVg4WWjU4NLdvfiarM7nH1gqDOMk1tI0mrCu6f0j0QlVKiiS41VH9hAMpPeg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.26";
        hash = "sha512-RZSwJUP4x+Gnvp2FN+tBpem4rF7g7d534ZsexxlvcADPniHbfn51unRoLIRR4VxmrKWYkzevI4DbIUvYq/jFcw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.26";
        hash = "sha512-L0THs2RNazoQ3b49ubo8B5cAX9urGlfia0+qKDdaUGSR+VpNWLQk+cIU3GMY7D//Tji47H6CbWHi1J1nqcnW8Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.26";
        hash = "sha512-G0SKR09h4cxRhrJR5Z+A0oN1v7b5xOTCgD1sap9RctZQJi6izKxOh0JpGFZo1q7RsECv42tuT8r3N19N1T/t/A==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.26";
        hash = "sha512-kw8PI6y6qRlc7DtKAczoRwUXbBXp/z2qWzhArDq/A2/VEdPoldnKiGsH0qesCXD/fCkZYd14zlv9bDmoaikH4w==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.26";
        hash = "sha512-wUopT8Yfk9H/ptyos72mLYtCWX9PvLCsqXCv/Jfx4IAMnnFWgFms1cqB3Iuiv6gfKNVulg/TLlcs6X+qIw/qcw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.26";
        hash = "sha512-wRAQvNF+EVbKWCSrIxRKSGc7e4DfMr/f6RCgL9TWi01OuhcVrLHPKduO+S1bBOMid/RADHtKKEim3T9u2L17tg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.26";
        hash = "sha512-UjeJv405adVjce3KBYuPAB676suC/N/wm9RxkpI7p4mBSolD9ouX06HNQbKBoz33xrrsfqUgKYF97yb2f8Gdsw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.26";
        hash = "sha512-LTStD99NDBoYO9CCYQOlPrChxQ+2LlDtCnUc7jM+MYFmuyZuM50A7yCw9E0nI6x/v96+nDlUWVeWGbcxJrLHwA==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.26";
        hash = "sha512-6Qb902987gHVpAjIfvGcn/H7a2dDLz0e7ICHdKd4ZUDIX/wxsDa+sIDqH9DCrolfjMKCM4AnKYVSc6R85riH4g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.26";
        hash = "sha512-V9szdAVLMKm2R99alsAn6bqqfrS+j+glnsVpTM3ECFI6rzo2Z6IuukdbyWUCBQQW9ZtdTz95EDPHuQgIjhp6tA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.26";
        hash = "sha512-QbkPjE+JsSlcpLxYF0J/J5eWubpbLr8iTUXZhKLr9A20Cd5t8Jn6e49K91hncZ6BRXY0A7TgAfaujqWR392wwA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.26";
        hash = "sha512-BS+KFsKGAWLrT3d9BE+lsId0Y81ZVdNxs4R7A+2RoG/flhqkO2rgnSr7ZaUdRKa1n/Qq4dfufVFadl1wP4l3kQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.26";
        hash = "sha512-7J+rn2bp7r97AGwskicSkIxrxlca15fs7pqL5ssJr0atvc2vnx5kIE7pZGgC4400rLbzaJoMitjv7rbPpGZKCQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.26";
        hash = "sha512-hXvjJ9jI+oHiD382Gt1IliyZrYJStOfmNzubljzh1yqx2J/5cw/OgV4IrUZxpYsbIgF4Oqw5iVifXVSLSlB9Qw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.26";
        hash = "sha512-Bq5HYD1X0d6dSDKSUx67vDjPTN0UL0F3kX9N33j0tXVx378puyEYQBnpcRFjB/yJDUSGoZuycngMbbNg61UJVg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.26";
        hash = "sha512-LvHiWGejXQ3tMgd0qyoCnCj/Z02B+WppWLMAk8AaQoB8NT8s7fPQbFdtFBXun8/kHy8DtWIQksd/7tTdnxUllQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.26";
        hash = "sha512-9FSKXZUv6R/JlCBxyxzKwlOaaStXfOEDvLXbflu/DquGxPAjVwEJkBYzWkIftg7uFgBxSGry/a3BKbdKQdgegw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.26";
        hash = "sha512-PlTubz+w1Cm77j+vSv2xzg5IJ8SdOlWQ/0H1HBn8N58qajPAjsh6SN17OybAsnECC3ojRQAFn7U0jJD9ButhoQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.26";
        hash = "sha512-Ebxq2Q4fAYC8ilICA88Fll0qT0nBpJgA5jtk9zb0wRrfbnxXus8AzIK8iqNdtweNu2pXz0twvDj4F9USNw/fkw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.26";
        hash = "sha512-pLG+ofeEPsDZnlQ4qRQm00HMu5n0mdB1ZWr7KqkitXz2+GSU060D+QvyocRxPokT/BCP1wvA1rZ97fUbKaw+XQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.26";
        hash = "sha512-s5wgCufg+Y8m8Hz5leK8z42Rbkpj/6B5NDeKohAF7PSpxdbyDv2p/FwGKftdkR0UCOPpmk5RpuqO4gfojbhQzQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.26";
        hash = "sha512-R3yEDeOW6uHuswesNeSrW9gSeBkX0vKW1DktVt/aVpb81CEaPmoJvwEEw9xZWe2tT3KjL32SKNCT5acZWgqIng==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.26";
        hash = "sha512-Oh5tfN0RKEFJXGaMlY2klu4j+THWmMI91njBaY29HkqZw51iTCvLzKyoJpILIX1uWJGnxkBgxOPIyde/Wiux3Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.26";
        hash = "sha512-Ok7T6sYXCiRtarwXvtBMv/6e5ESfdLxEnrYXeGST+JhRHakIqwcvvhCnyPpE31ZXPpE2UroDccj43mj8B/O1ZQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.26";
        hash = "sha512-ENcMrkBwvVf7FA9BxvZ6xYPgpQkHPBQDz2exfiq5AqCHYBqDFDARV5eYDADHVqSGXkhhpB7kI95YPoZxQFu/CA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.26";
        hash = "sha512-lhrJ9UDouxK0AJzaRZ/dWVWepRcY4gcfop+e3oN9jilbto7GghcM0O7SEVZE/ExDlvCs5TKOltlEc+ec9j8O6Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.26";
        hash = "sha512-oKU8ONnBahbPcoKpmY9BMgmO+XcgAvhMuUuwzhtYpsnwRl8xBgst07yngSznNIQicD60JcoBkwuluRFWBYk46Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.26";
        hash = "sha512-UUV+HrrRqhO41JiRv+vgNZlMrJGqzO3AoRudtATYNUSv4rjpKiKiEnbH7tbKTitN5qb/PTN1D7SSGcVXiTRy0A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.26";
        hash = "sha512-Z6BukiuQ3ANjqer5D6GzWl89GysLQ8vDCcUY4KQ1NbGZ499D6OgUmC7yQietdHbdHy9FNQKzTTIPArmk0IPfqQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.26";
        hash = "sha512-hqTru5VKVpaGn2GMjLXmXsGAJvGhYBgglleKqVLMs7S7sk07NshFodUJApE//DJWHTAI0R4BmEBRIyje7/27RQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.26";
        hash = "sha512-M2ie1hI3VieTXGkg+fn0UNVSGxmbDfhGLbduXCTfUJRoTOtumUyXJrzBZ5CM7OvwffxCTj/OJL5cAoT0jajj7A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.26";
        hash = "sha512-/SH3saSvRSDw4TgEi4G6lMVdiIu47N869vIIUi+QLCD1V9v/ITozacDRrl628SkAMvdysPw6Xf2V+MtVVIs7ww==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.26";
        hash = "sha512-K3CPLIq1flHDVkfZmBIgUVTDniL1yM8o+xR3HIc0+vTNuYnifODbMsKxQ7Y0GxINF3Mho+uiWotWp61SAsy9Uw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.26";
        hash = "sha512-5w5BPt9TqthU81ZKeyjPkw6grGHzyAWPmBhtgypnFwk8fy6P9Cxcf1YpuLtHCN1RvaXtOL5GUiKftSD0UbxYUw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.26";
        hash = "sha512-Xokayv2BGD2kg/NUutLFQdgZtJ2WNvq20BIWi72VJ7FOobKfKumw0tDJYoAzA3gXWRJAxzwDezXt2/JIIsEGnA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.26";
        hash = "sha512-ANBYHTCOn0G/Z9TWqQZtueQtQyplaFHIMUeTna0BQ9on9sFzUXva57GjksLSyRhnignHhIJuXpnCsIQ5DgmQ0g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.26";
        hash = "sha512-HIgaKh/eFqyFPaW9pUhPV2oP3+l0fudsAqziuxFAHSUIYbevhWY+NalVgTxRE4sI3qf3781EQD0nqrIWUpjeFQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.26";
        hash = "sha512-8zqTCg2DAScMsxQ5W38+Zog2FFq9XsbNX7yUL1iqhkcBLCmX+7l7FQobJyhz4qptxrpF+2agIT3Hd6guLdcQBA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.26";
        hash = "sha512-DIQQnor5GUlGIIJB7UT+/GkAKfKutoaASVMwiuYWWpCSonIhe6ggZv9WF4eO0C7mIbTnTAwApjMr8P5XpuoP5A==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.26";
        hash = "sha512-wlbQtZ6X4efSlPpb3jy0Xnz1fWWNX1I4vCdaOUvbg5nr2BVTB+824sIY6tGlIcAqqdRXqX/RlUA1BxgciKjnlw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.26";
        hash = "sha512-UPyIegg1tutlrkBKAk0s6yOeDP3Zng7zvTTJgSqQ+8zVkvWj0vWcnQWP6P7gAjURDWKN6WiUFBoPi/SMcTw2Xg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.26";
        hash = "sha512-pCDrEkIZdoS0hdK9pbJ8OnrBLH8PSJY++PHKvVnRqdmQ7E/QH/MfM/fXHS/B/0pNw1W5NyDv+rARhdNfLBcx8Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.26";
        hash = "sha512-fhknzto3eamkcUlVf8xKKqc6AoLKxgvcjiHlBFX103itkfsx+qJtslZhlORFG5qLsae+ptyWBjgrW3UkIuZIJg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.26";
        hash = "sha512-jTqwZprQZdpZDal2T5jRQxivj9vBrp/U4DCFyLW+C7WPoJ87YLuXm6E/7EdObt2Oekd5ZOEzDu/IU0qMYnk26w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.26";
        hash = "sha512-DtLq8KgpoR5803ckM9mMEbOlNM67LS+idTbr58vYFmRKRvx+9QHeiExuqv3h5/Ac0O5MzY/HCIsVetnEjHtPQA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.26";
        hash = "sha512-U2EZQ8fh7JumvWVnlGoSUNN4ZoZ7Y/wr8Cp+2K7rz1glEDyqkmeZLT45nyqv+fnixXiRTFgxGH5u/pmCpFu6lw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.26";
        hash = "sha512-CrFGhiqzJ1sl7GeIUMLbZpmPo64AQzj167Ia/9wmUIK78+0HZzIQDaB5ix0V0f0kk0Zs+qUJnIARO4pLCyVtlg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.26";
        hash = "sha512-vJMRkH1QoiVHQ2P1KsCZ2Enl7V9umXnkZAhObWpH82EzWJRCI9KlKApGqtKPgam/0PgnrnZYFQBqrxkFr7Mg2w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.26";
        hash = "sha512-zYLxEiqaBWJBPyJqzsOzbjTCqAUWNzpBWVlIyghyPHR9SEuSPIYmT22JWOzhh1l8y0B1ExWR7fs0HT5bvQMwEA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.26";
        hash = "sha512-TFWwdrHXYKSv8VgMvP05ln4qFBLMH7ggFmoF/KQDabnPOeE8ruhWgGot2tuXyFQcnjfVms//aBfKahdxgb0mFw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.26";
        hash = "sha512-kEcefj8s1p/Z5kWgOx8ZbsQP1AG76/BCeAUEuv1j6Cwi5yELOTyynoQahU3xUwE4NeyOZ2oM8qs0NBwHvu26hw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.26";
        hash = "sha512-hUUs29xBOauaxXOzkg7N/TgbwiL5zqZln7eFbppULvEV3JvdaFiJmZGmAul6KEFVk4MD8Wdr1Dve8JZTdz/02w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.26";
        hash = "sha512-E9G6erOZ942RcXdbwkqmW+nr5PSfB9wQR3z4G7TwjH7L7U3ceyYi2igO6YjgW/2CD3fJt+HGg07DeOhpAM2kGA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.26";
        hash = "sha512-UYxS8tRAQ25q08pBYhHFMLwkvNkYGByRGs3DBRrhmHPay05khlNMCPzjViNPBTKW/NOXjK478bj7B21kppHD5Q==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.26";
        hash = "sha512-wrxqpEM6yBhMG3AjsrrFIfQMUCT03+LaENxcvQErmcbLeXLGKIyiSUFY/WZJDVTt2+y5+h4iOFrxQ3ueTLIJbA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.26";
        hash = "sha512-McCZZPMxwzOiHt3m7ZODAphvmXaYV+nvugIEfSS1N3PUGEqtSbTu11ttTUXqrYtc2oybTEYS6JnNwzPQ7A36SA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.26";
        hash = "sha512-yoR1Box8QktWwo15Ww1npYaSDmQRo05drX2PLIACiX8le+P8gLjP8L2X5/lVV5RauDY3AWooy2tSHYpRfu9XnQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.26";
        hash = "sha512-HLpC9bIUQT5qH6l2AqMFNLj+4vfFBTZfcU1Y03fdDE640DeOZavuFw9e6cCMsicK8sUw0+R/UI0D5rAjp0tnNA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.26";
        hash = "sha512-ycXxK0CFJoH0nhsJSNMU1hDOtGB9r9qfQKafY6iNtcqj9GAomxKeTz3jpgnYLEvoS0DQ10t38aOzO6JcpnIXuw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.26";
        hash = "sha512-b0xRtn6MEbz5iduUI6tvUvlzz1aL0hXhv3BZCG5WtFa/qVfOI0cJ6XCQ0qJK8KTKFNN9WgG1vt68Ysmb0GCtug==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.26";
        hash = "sha512-5zkGRgZ1wb1aHiZHTmSg0pQCdQMxmwKaRRi7AWusndqyzj2aWYhANRCBQRM2qRvjwYntxeMxigec+3TEgtwSdw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.26";
        hash = "sha512-nfOGzFQBYDY0gsLLdmSXJ+6yXNMmHm2AIDec09ELWNfd0YmZpkB+kfWXv/y/35p2HuuC/TUwKI/fPE+G2H17lQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.26";
        hash = "sha512-7LivwV9qDKyvdM+aw2JdVQ5ZT8RaKRRLsrBjWRX85IiHE9NUUjFQ+6Ycgbu/SbX20t3qpJaNE57S4rTq0ccSHg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.26";
        hash = "sha512-3klU7U4CG8rgay7dGkj2dsFxDKzUo5E8TJkkDBpluOdQDoAMIogtQNIpM9Qk0w/dYWi0SK/mjpoa4C0qQRKTrQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.26";
        hash = "sha512-GBWEaWyG9Dt6ccFBCWMrRM9GNkK+MRaMjQrNslLKGLOXzW/FqvB4+/vQuBK9CGUTvpQaCsjSf/McJX5qiGE/qw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.26";
        hash = "sha512-TFK7F8KtZGEpEl4y/xEIq/nbUCRUFHQX761DiIcOvCzhq2XHacwywgMA1oBPtlwUTOoVTLUh71eNDwJPYIN8YQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.26";
        hash = "sha512-ND6iR4eEUNz5UKwb68aIljKwRLRbSkGvGCzJkWq2PKlQyasRIIJfOaENMyWKNNob2k0hfQhTIT3QmiYaIjtzTw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.26";
        hash = "sha512-mWt7fyHinhp6keWT/KFOpUz5jmrJH8HQfys8tsEhWaBURR8xXtu9pVtPv5c/i7SvG0P3x+PKjm6ux1ekGbBAkQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.26";
        hash = "sha512-eq2026kwhUy2drV8sbSFUxsbs52YC4bYCudfp8SsUDiX1Z2LT3/cak9hNsDIrUVp/WD0L6MCYCeULMM3l8CdDw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.26";
        hash = "sha512-4ZoySGS6Gq3PwRtmaBU5OgrxqmqSmpnyBOYrB7LQPi2AVXaZ0niuLRKf35IE5MAUq1hMNzW6liLp1ku4inYMOQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.26";
        hash = "sha512-rdIJfNoLpkjyFC3IyirLVH+Rq7WYfZdoB8HLJylqB8md7wDs4vXP/Gd1F4Kt7qpUmdFhZmQBU1m9o1siwT+/NQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.26";
        hash = "sha512-jKHnBDrUSElIsdvDQ9Bv1cjHx1yXY1Va7wjuduJb7jDsEes9CMrnoPpKMTSHVQg7qG9Y7rH330dfQySGJX8WEg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.26";
        hash = "sha512-GIED4RGayHSVK0OalWTpRMlRm9fYzxD/sEg4psclk/J42IU4Onh3EQjuCCdeCFTvqW0JIWXRwqao1/y5iaVscw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.26";
        hash = "sha512-juM12v4XsonT2Ux1fG07pv7dr2H8IBZruIOMl90KxFw4IcEL5lCuX3PQjLZpEaKj8WJU44UEMpPNXLbhou3f6w==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.26";
        hash = "sha512-S/aAv7BB8q3R50dp4Jc3qH8GeUCBDN0TJw8/pgwgKapjw5B83wBas7fBjTm/hv1bQbUh1/bbDlGLupKNQAdVtQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.26";
        hash = "sha512-5YGUhp/CloDBExUFVDK5jPDSOGIYshcYXEdZvfkUaUfFLwZJkq5yTin/SVxTTZssVHHKoIUdJ2Y1Ot6yR9sK2g==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.26";
        hash = "sha512-11r6Cnsv70qkqgSGXSXss8JaDHija4gfUiHR59GKoHvSyW8Unz6fwpOBPImRBXQbplh7jTPOpRpMWxf36AbRTQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.26";
        hash = "sha512-LFrnFKpXk4wmJGiybS03wTJNaMeJELVhs0Afdmga21bmVKFQ681Nufihk7rPpbkMtCH9pXkV4Yq09af1V1jySw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.26";
        hash = "sha512-HvtfbXf1w5N6MOhHbUVFqURz/FsuQq42+b7HbIWyZtYfwphoq4HIN3eiAGNEW+myGTXxMrXDgxu6u/cqAW/l6Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.26";
        hash = "sha512-d/KqjXJBIAdNNWTrr36qoJ5bqeGENSEG/vXPiY08LkxFYkIEt1TON7iKERWPf0N1WINvlGMvhvLsQY9nt0/O8Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.26";
        hash = "sha512-HkrKEb1l7t3JN/3amQvhDa0ZESo/6hxNAxW3tqyYcZK35upFygElrZ34snb+pPx1jJ01zKYqBB3ZRAFdm90dOg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.26";
        hash = "sha512-x5zgBkwqxm5PTxc7dqzG/yLZYwUkKysN5HeYSO+k2EmbCvgfDNGUH8XO/NS8RJG//CY80K29EhqCrlAhz1EeSw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.26";
        hash = "sha512-5p8BitpYt+xPiJQPh3Yacg3nlT9yx/jT/bmet6IkIgScWYRpgDdLOG+1v/6TuiIczTLfH3vBWrpA599Qy5zAeQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.26";
        hash = "sha512-9vAdrXd5v/sPgHeP+n7Cl/8puLkFXNvm0QDCxREB+f2+RFtWDjdOxMQfY5l4ncuvTdL5Bh4ZsECQ+Z3Yat/lIg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.26";
        hash = "sha512-VvKoeAdVAOFQ64RwXKQnPru8GpjCsGEvgrNuN/2HEE/4s7HTlys/m2IuaF5uHfFnVWVC8zeRW0GFlDgaxBNOUw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.26";
        hash = "sha512-IWagNvDfbxMKt/9/CciSDQQmUxi+P2vwwC+Tdb/U/vtPEKe8J+FLGrRmpUr9IIW3iQqnFwspHrWFw+fROxMqPg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.26";
        hash = "sha512-WQT+q5R9RgK5Oso5sOsFVG4z5PKnSGSTeFrXsWmi7muVTmWEY0POkFdhOV3pbBlUHvO/Cdzo6fsqZ2aLsOhfgQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.26";
        hash = "sha512-5ijG8rw3lwBt+9wvUQh6JzFISklhkuknzVEEvN5QYngL4NzqJnBkFl1+J1vBWSB7Qufm5RWf5+ctoicvPLZ8Zg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.26";
        hash = "sha512-CI/XQYa99ArXuufZs49zyJxIOmeRS1waxlkc2PQAYFPQGPJd7NP0Qv0IiXw3dlh2d1us2NUFnvZ2I5fQ/pIOyg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.26";
        hash = "sha512-Fdk7Zk3oiKKGIYIXn39S7zKgOul46AtDmXLck+SiGQhIlPd5kLbJverhqbQ3fxz3jGVMpx1FsfiaW5HtBdP5jA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.26";
        hash = "sha512-c35GqPTFRPz3krWoap/wyHM9o5qe7Qq6uY94iwiRPmUermBh2kFfciLKyM7BuGy8d0kYS3J8zraVb0+bkjESwg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.26";
        hash = "sha512-QPJuDGfdoTIScD+dy7hExP/n1mnQZLdQu7J7pz9E42QoRRBuu9+YRaJsslIPKIIQsdg65MruYDrdmsuXqXbIgg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.26";
        hash = "sha512-6ZFMKq08UHU8oCDspgr6R3VjFz/TCdU8FcAuHdQ8RIBcR2pv+bxRsXA0yjxJJ4VRugNhSuiHYAcbQlM4AXt50Q==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.26";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.26";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.26/aspnetcore-runtime-8.0.26-linux-arm.tar.gz";
        hash = "sha512-sPT2TGiFkSgiTc4YlXLX9owwy2nc/x37Ze1Xi+DyI/GqyEqQo6YwNnvwxvfQDnM3dEUB/qSCmU1mgZWH0jy9Ow==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.26/aspnetcore-runtime-8.0.26-linux-arm64.tar.gz";
        hash = "sha512-k5afgMS/+idqVTilEz4g6or9Wbf4P5Ms0HSf83My+Fyj4+npD7ReyOL9GoFN83O2F1ZYCIIxE+KRH1tV0BjRnA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.26/aspnetcore-runtime-8.0.26-linux-x64.tar.gz";
        hash = "sha512-Kl05v9stc0/XZfgGv0vmE4vI2bRPL4ruMlDO1W6q1MDkvwYUHexu8sakao+vPY/9YLc2G2h/99i0UXnfNbsBSQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.26/aspnetcore-runtime-8.0.26-linux-musl-arm.tar.gz";
        hash = "sha512-LpMXK2RIAHoyAxZI8R0GdnX7uIoHi4/Y/oIWOFMZALXs8wBb2bc/1Vd/gtxz6bRmKH6HzrKo6d06+asHo3olcg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.26/aspnetcore-runtime-8.0.26-linux-musl-arm64.tar.gz";
        hash = "sha512-b9BY/+bt6vE54e4VNO3RrrmfVXWJDBuQLemfdwtsiKCHbJcU/xzfTQuWYMXJ7hJU4uatgTCwfGveXHkOgsY85A==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.26/aspnetcore-runtime-8.0.26-linux-musl-x64.tar.gz";
        hash = "sha512-DsrffmD5eJUe6ShrJDscwQ77zxSycmFwy4hI/MObkhi5IF4vOgvIk25y7DAO6Bx4RBy6TUgImHrn7u+Cpo9Mxg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.26/aspnetcore-runtime-8.0.26-osx-arm64.tar.gz";
        hash = "sha512-OncrRQfwX9dMocq00h8ljh/fdFLhz3DKjVEcNq/pYSjHA3BzVCCe4f5be0lEG60aFf4dYaQQePqE86oBryOomQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.26/aspnetcore-runtime-8.0.26-osx-x64.tar.gz";
        hash = "sha512-6CZo5zau48dvh6TByDMzEeTeKLr2OVRS3co+cmFiaSkGjZ1eA9DAdQCwEcN1qrFKARUaVYVp/oxGl3dREF0lQg==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.26";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.26/dotnet-runtime-8.0.26-linux-arm.tar.gz";
        hash = "sha512-F+T7RtkGrqDEuMuhV00BK/ms+vSNTSwEhmTElQ5ydZw5mX6CttqDmX/T1GvfaO2XlKxRVhQmvf1nWMlB2Vf2vg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.26/dotnet-runtime-8.0.26-linux-arm64.tar.gz";
        hash = "sha512-iltpWqXf21oaqB/syNkC/7lCFrXNaQk+wPT8mK2kboCQuEGiJJkgorOtJViUYFzICk3Mge/zQK4HRSGQy8yB3g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.26/dotnet-runtime-8.0.26-linux-x64.tar.gz";
        hash = "sha512-rwrDrqUBYq/2JhKIOrXsujwN/nzAxQ+6cDQv4HbByrJCCBz4TR0TCkYT6otIZxOaMjRDP0Kmax2G5NTBdO8HUQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.26/dotnet-runtime-8.0.26-linux-musl-arm.tar.gz";
        hash = "sha512-wVEfklRObIXeHfTtKKan2FPG2fCRxPIJFHLykJj6+HMn9sM5GFXaGfmfhfMgbpvNMqpCErXJwPvrbSS+61OjJQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.26/dotnet-runtime-8.0.26-linux-musl-arm64.tar.gz";
        hash = "sha512-ePJKefmUN97dc4ido+oyFGN3RCE6Wp8IFy0zh+5wh9qHsZ0wBG8CKOqdyalkkIz8siQPeAehxV5usyZimv1mVA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.26/dotnet-runtime-8.0.26-linux-musl-x64.tar.gz";
        hash = "sha512-smAiu5qHjwY4lvZOsA38vrYflepdmBVGalLWQk10YpLwiFuW/qU/g5o/t+xkwcw8xlHwMAq0D/Eou03ySaGlgg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.26/dotnet-runtime-8.0.26-osx-arm64.tar.gz";
        hash = "sha512-P1sXpxA7Rn+5k+nossZHx+XesCQTii+yvmQiWRpmMZaKJYTVvo2JuFZgT+YAGeHggOddcGPgiyeeR/aMpaz2ZA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.26/dotnet-runtime-8.0.26-osx-x64.tar.gz";
        hash = "sha512-EwJ0956UC7vVVhKTBNpRId/wQdXnEMoaR0Gycm71+/9xpQcWZttc1/lnqoXXxZo30RRrUg/o94pLGDKo/7ly4Q==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.420";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.420/dotnet-sdk-8.0.420-linux-arm.tar.gz";
        hash = "sha512-gbWVJ3psHZ9ssdKgJclXeRuueRENl1cJ8nOMia+56SJlBYHDuwKXqQ0C4rF6D42R8bKT6bogaOoP6LkcduLzVQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.420/dotnet-sdk-8.0.420-linux-arm64.tar.gz";
        hash = "sha512-U1GXsiS1LXfOBPc2VgB4hldmYvEqjzr/mrh7Frt+Al7bL5QpG/uQF3LXa39ob5dGgHQ/7yFtr0ke82F9mvEujg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.420/dotnet-sdk-8.0.420-linux-x64.tar.gz";
        hash = "sha512-NsaMG+nVxvJM2Oa9S202v9erckrH40mfsT5C5wqQAzEOXuV1ntGc7R8OzT0mpV8TXH5y1veI59RPXw6qcq2aBw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.420/dotnet-sdk-8.0.420-linux-musl-arm.tar.gz";
        hash = "sha512-3s+2/E3rrYALWJEkEVQ+37M9+PpNXA2kMvf5AoraTrt1D4BqzUFVQ3dTmLe7+SqpfZnXQlv/nIr97z2kKdF70Q==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.420/dotnet-sdk-8.0.420-linux-musl-arm64.tar.gz";
        hash = "sha512-wg9ikhUzkjXrxGOdDhLWmvqYWh4t2fBDLmn9fTdNPhLFZsBPyeVBXpLsHUAsDJS+5NKxZgvbkoue0IdW+sbPMg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.420/dotnet-sdk-8.0.420-linux-musl-x64.tar.gz";
        hash = "sha512-FQrw9oX4cbgs1nZ9t5RaTBl5q+0Z+ZVZpQprhxv71dMJo6qDQrNeDe8OtCh7/aeG9JWlYDLx6tx0spmEYWlgfw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.420/dotnet-sdk-8.0.420-osx-arm64.tar.gz";
        hash = "sha512-ITgNTkDLakxbNZic+RI9kBAiA9o13iRu7WdjWETvprRPYuQQeJOYu845gGESH0XjNwFy/RKjIJFVebnkUFwtmA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.420/dotnet-sdk-8.0.420-osx-x64.tar.gz";
        hash = "sha512-Msu/ki1pt4p1fRwR8Z8lGJB9LM2B/bujSyrvhSdbSgL7v0VreNRCNqX9ta9ssgbb1QbekB6Zr2Lh1Uu0q3rddA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.126";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.126/dotnet-sdk-8.0.126-linux-arm.tar.gz";
        hash = "sha512-QZWd7I1b02wHYAGYK2lSphrSpD9nDfzWfhUgHUMHaEO36jP18AUMudlU0M0X00PRcux6lonplza12Q7NwG+4JQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.126/dotnet-sdk-8.0.126-linux-arm64.tar.gz";
        hash = "sha512-VVkRkfVvAK/cWgEH7KZWchcx0MnaCou/GKARrhZj2wlnsOr/k791FDXjryrQBbVmZhTSSAPLW7L7z6KzQF9CDw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.126/dotnet-sdk-8.0.126-linux-x64.tar.gz";
        hash = "sha512-8FTdSFH1b5j7kRoOjVmjPGH4Owvbg/0doMMa7z2AadayfNjzJC+VURuHk0z6py8FeCToEfMG3sb14enX3c584Q==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.126/dotnet-sdk-8.0.126-linux-musl-arm.tar.gz";
        hash = "sha512-0J0rk4IU6I0uiCHHdQ9zXUWIJ7h+Ldl0SLo5HMyuNHGYZ09azOn7xK1yucISmTPKtHp/5O0sOv0NMl2yR6aOIg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.126/dotnet-sdk-8.0.126-linux-musl-arm64.tar.gz";
        hash = "sha512-QCA5Y7fT16CgO1tL16BdEzT5zVNq5bZscJGqeS5cU+ryoa/ddlUmWjWc6zRIvtCEslya3rdlEywbvGg9ZcR+fA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.126/dotnet-sdk-8.0.126-linux-musl-x64.tar.gz";
        hash = "sha512-GukxZn9Cb8LiG9iBoNs0ziYG6D1qKt1Sp2o9DLK/d6MHH+2aKkceWnNoU387hCX1jml5kwvxkAimIY2i3qPWaA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.126/dotnet-sdk-8.0.126-osx-arm64.tar.gz";
        hash = "sha512-PfCRCqXe6dli8U7vH57HZinRfD5AHDwNVM1cGn6n56pCmlwkUCOq2cM0npZRJEb/Mtbq0FF5JYCcuG8oK84vRw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.126/dotnet-sdk-8.0.126-osx-x64.tar.gz";
        hash = "sha512-OUHeXeIRNUgERj2CQHBjoLag045tk4YnzieDL/2u3GMvZLmbFIjWCbkIEtMT2GbsCx4T+VfXKwe/00Ki7KiEeQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
