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
      version = "9.0.21";
      hash = "sha512-8y9/RDs9kJ78OOIBzKjVI1ldsyjVz7KKDw3RRlw38iCB0IbmUP9n2tnJeSTCcF0Rp8m5PNcunfOxQew7lrGacw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.21";
      hash = "sha512-EexTuiEyHgOvfmyxfTpmzc4LQJ7ovyuBAr9mhpjcz/obqmBJ7OvzoVC1eH0K9HuobWAImgqzrpJnQaJ9W8ehDw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.21";
      hash = "sha512-41jpb9nU922db42R6WzztXGnhWbAGDmPrnpLspe6XREAAY7HHWoEzFMLK1Rsjhwbb5Rf49ACgEPEiNoTegt0ZA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.21";
      hash = "sha512-YRHU4joKFKQAtsFn9bEqyyr0xm3oEUCXTfHPXvvnb321al60nYdQfn7/6rGABpnaHFYGV6gP3OVK+MsmgdK5jQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.21";
      hash = "sha512-naOky6WEtfLm5hgU1Hpw6NMcdc9ZPSy5K9F9yc4+2SM0t+i6oPp9XDSQ49SQ7Xb0MdcZB1fytVo254HAGZsYGg==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.21";
        hash = "sha512-8qzJy/Y/34RWCsC1YSmMkIr4lYlBQLUx2tjCCb2hAfD65/PvP5lpwnUIpBM8T6qLpbxKr+gd8RSS92vdg3/5Fg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.21";
        hash = "sha512-4zoScmZFSF2fjCZV6tqG0i9IG0Eh29bwtYJQGD2fWflHoAlYqpnfiU9mfbt6WqpWAEwkZxcEgpcxUIp+XYmTJA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.21";
        hash = "sha512-3+QfqhYlfEQfnIiHvuW1wTCRgv2NNB89cLIBOluafvgkxTF0a9Ozj1MreM1yZkvJx8uScSIW2ApLUG+65j8pCg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.21";
        hash = "sha512-UhKgcb3jk7pWIHEwIEWdOyj9mBDhDiLagTFQSsS9z3tmwGQvkMU7aAUfh20zXN3ny6tgsTU647P/cWGXDiJ4MQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.21";
        hash = "sha512-BUJuLjWhjVS/FBBeNwe2EYE+N2PncRBkpzi0iG+3IpkKbt8cZt2WICtqvMjdn+bJlS9/LIfuhZplN2Gwmneo8w==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.21";
        hash = "sha512-OWvpOA0g4ZD7Fm58qHqsQoUkGQ6qf/2ArsucQPFIlBcE98750QALAHNSanWzgX+7kRrd79ZzbvWlf9CF0oma9g==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.21";
        hash = "sha512-tQQ4UGQJLHD4RYL+148wz5dh1dj3cEQEAX3dIvbNcohTUKxCwQC0ZhfOFVm/KuwG6MFThqs05JK+f90lPlwwmA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.21";
        hash = "sha512-/9/kE6U52VuyR154Lzire3n157Y0ELHAvlb15VNXu9MoG1Stvf9lXRmMHGig1lgpMdC5RwGuaPptuwyYeT88eA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.21";
        hash = "sha512-cKfkxmakIgAHV7dZtIA83301prXInqJ+IbFeey0xyxHss7yP6dV2iTiOQZE9fff8X2Tejnel8Nu63UR2+cmTgA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.21";
        hash = "sha512-4EpDPOUovECWFEh46pt/1MbcKdqCvVhpiPa45mkAopRdPHszekcNr0DXcfvqSXhFy97qafQUuVlpYzzd0Z8aOA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.21";
        hash = "sha512-MCrWNoH6iBO0rJEYsRuaYCyw6/YkUpfK0lPwoyjaj7LSS7xZnC5eKRrE7zp+25DeyJBxLubqUpQ4TDvpxVR+dg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.21";
        hash = "sha512-kFQI1xzuGE2SOSsMnGrRjmncVwjiWlIMq/eATOhKlz8HtASgWTgVlaje3YkZ9ZBqBbYmfLLbXwm0q1C2is9D4g==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.21";
        hash = "sha512-Nu+tQDWWgairW/BVDkQtKwhSKRXE344QmHpomkMaHwC9cedyemuqDrxcgGFOnCZoNP7eSGXmSvaunRL4UxSIFQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.21";
        hash = "sha512-sP/jSquG2V1dInCsSMOHupV/s6KWxaj1jjizquGmSDsRYNvK+T9oeRaOwQ9ISc603ivCxMEL3qfIDL/Cc600Hw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.21";
        hash = "sha512-lZglZEe4boiHN2TqRhgmJk0qbJNshE3FEerLYTNViVyCplJsQ/jIeewYM2vHQSMoJPn8h0SHF36dX4bKM6NYOA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.21";
        hash = "sha512-zu/H6CtWmzEuRg1JwxWWPr5rHyI4jTlBkE4nqYj7vbM72BwPt6U/6cL8B21PPBolPPdrfeGLNWs3SarbtAp40g==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.21";
        hash = "sha512-Xb7B8HXS1muSgkJN9WmeIHxphRNkNLCWPux9VuktY8Vnbd4zMRiG9x9T83os29vrruKUO2DYG4A9Qe5quAekog==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.21";
        hash = "sha512-gq5MlnBxLh76TLs9MHGzquNkMj9HEjNoAMZtxbHYLr/jmEd6St34hR2Hncw8Zu/kaiOgPJX0843iGfuxDsQDRg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.21";
        hash = "sha512-bDSq5FMEr+SlsrcGQLem65uaF9YOiV91sciQxwSLhd6yGnOkAoaam+unznGz0+AeiPwG/lFZNNr9ZAMNwOG2hg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.21";
        hash = "sha512-jdtsgZ337hTQmz3KU3+eb9Wc5O38BvwCeuDFX3Cuvxm+FoLYTeUkz56wgRGHGSjkkaI8T50u5OwWzMofszQvqg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.21";
        hash = "sha512-t+WAqgyC9u5c4PWbZddHNHz+rHiHfzfd2JYB9hQPpjGUpm4jh+5ydn/Ig1Nbkj2pJpxRagwgojKqBBmxyyt5gA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.21";
        hash = "sha512-gAPEG9Z7jPN7pkAQVGbW76pNQrYnhE/jc3aj86Ht9czVHQNfgkDHmQSq2FkE2GwPSzPIXmedE15p9jEiz+dd+w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.21";
        hash = "sha512-CSjetjSbCQB8CkYrwwaB4s0L0h7DTcPwQX//lu7qpGWfItNIzIDBHo9o5jlQgYScrmKTkUcrhZjsC12ZiD2VvQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.21";
        hash = "sha512-d0bkkyQr//RwDv5NmjUmtVMjWLJ69MqfWnrMy2D+wjWige/3qNFctv6Ft9l7FiMHh/83Jj4DH7FPciIruzgsIQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.21";
        hash = "sha512-4V7NxPZ9pDkG6MC0xjo8rJJV/Jwo54hBckhjwLd+hOl9Z+7/z+ra8Vl+qGEq92s7JNhxsf25nrfZ256+symcsQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.21";
        hash = "sha512-nFlpGYydxB7IbSwkJnw5ma6o6tbGgFv/jbGl2xDFY0ABFyD6LVtya9+bLNyDzB+tqdb2/11I/0eaSejQmOl96A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.21";
        hash = "sha512-EQ3yT/JO8qK4dAAuNjY4qZyjvi3c3wnQzx8IpRcA+1hpdg23V5oK1V1Hi2R7QfniTw1N2CL2gMWhtOUBlmldQQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.21";
        hash = "sha512-ekfH4ovmoKRUIKUA4GZJ1Pu2ntnVXZcdRCrMWYZA4a8pjPqYB5g6hzwvLv/Mo0+bo/+Bg+lmPrL+W2YalyqQVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.21";
        hash = "sha512-uOlfI7n4Hi2Ay/XmUczFAcrl8B2pb+d508R+Jhj3O4TaKBvxq3V+ZmdscY1cfqVkV3bTRcqsUhjMKcfDvJoWWg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.21";
        hash = "sha512-Dy3yCGAeaWHBf/zQCSKrLtIs4ue/ejxnjqfnRjKX+EE4UiPE2zumFvZiKrQ9wztArzOHGU74R1467gWNxz+D8w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.21";
        hash = "sha512-suTLaF3+4qGnSQ9CYI9jxb2A72fupXkELs0oiLWIStHy8VWEsAbl8g25kGPmp6zQ64Ooi1rI/nCpIL5WqnQdYg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.21";
        hash = "sha512-dTNEpIKJt6nGN6FGfrOatruDmA8unI1k175R2BN0C4Hk+LnwcL+ZPuUfhQxRKyLtAvmkqZj2+ZNEv1sWuRr1Xw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.21";
        hash = "sha512-SVIqoGqFq+meW2pLMEFQCoaTZrdiT9k0iaXRSQpfQvWHPKuoPXpptKWKgloG1zjpixDJeh5qSYivhOtpVfEdzA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.21";
        hash = "sha512-aIK3cC9GOErpVS68wqEBCNkESJK0ekYvGbx6TXLFUpBpb/9cLo0jQmFL/5Vpaf2qc1US4ih7caKuxfxJsPuO6Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.21";
        hash = "sha512-GSYVs/2fmKVDIj+DVbkIBkciFDYBoZ1WkJFnI9gdqivxQSo0GNGFTxh9Y3GH9RIwVHglGL5fd8iCVc/gDWpX1w==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.21";
        hash = "sha512-xBWYut42Fs9i6IWOLDxRShJ1+c0mDhhUo7ONLUrDyOOjwZa33wltZZGMulY8kuQATlbqSbcvz3yitRY28WPFVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.21";
        hash = "sha512-teYZzfApq6JTpRYY+JTa51HPvI/brM+XuueFcq962Zt5tbHnlmMYHD0Wq+jTtT0fTzThgxuCLQ8YpSfysXULeQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.21";
        hash = "sha512-9sM58RZoNSPY/jkAEkkFpXBdl4exk0L46e6uPK43axQePLhGufD9/NiJAh94+GY6ULdeqrweVCAF0+U8kQ33BQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.21";
        hash = "sha512-2uv5caHd5DGzatiMDNNvUkKpNeN+r4iR12nHVmT/eX+0an8FgDJ1TvnTzwXyrAoct55AlayJRQBZ3rzlx7qI3A==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.21";
        hash = "sha512-8BTuP1EF4C9ipGAlhnaoGe3avxR+blbkOD66K7wl1dR9Cft/5q4dIvgwpE0uHV3h7ORQXaPQ1ufkkGaTPunnnw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.21";
        hash = "sha512-MTJotwzbV/pqi1Z/OidEHjE4wfuY6IsCPui4WerzAccN5owdyWV6emtEb4TYxHlLx14YdZwBWN8E78OtuV2kxA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.21";
        hash = "sha512-KjjpQ1hUnkQ80RAxOpMDS25PLgsjgn1+ioFg8tmbTlNyowK1F4JyVZ+6g2f5LLt0w49ovF7Izyyqlgwm7edi6A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.21";
        hash = "sha512-rwjIF5XaWVBbvW9OU1Shg+yX5hanGG+AFOJ8Kk9zQ5M5y0f8NfqKu1hnSWP1VpnTMt5Au0BjJ8RiOojjXhzlKA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.21";
        hash = "sha512-an9HnU4nSYammj/rB0HJV6fgMbVqEIT4yEiVhpJtwXcqjqVIxdRIkPD8F0EFhWhyNmsdcSUOVVgutGAEzotnVw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.21";
        hash = "sha512-u1bBPA7W6foCSscACrFSdNO6iWoOBRmp7u+RKgz58eJMaKx4uxYcF3JFEfY+ZjR7pAu5YGPlC7vpWVw//DCTog==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.21";
        hash = "sha512-S1Vk8zfcb5sNEaY0kXeBlXuZhNZ2u4LoqHV/hOLk03uhlrc5B8e+efgIQETyIhQ4WkGS1qe3pjJIUeGuF7UNDw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.21";
        hash = "sha512-hrnzKs/VEVs3P+Kqhlxqs4I1MYJnj4UdLBlnv9jaPNuJXmqy0CAkaDr+KsBAGu8IE+MbdtvTyh9W9+Uv+vPeyQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.21";
        hash = "sha512-caenT/OZEfa0ct00vTQKvrB1cVai9vcHEt/O0S9IceZdrmWgx61lpNloQuXmy4tFPqtHQVtZZrU4mO99AQBR1w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.21";
        hash = "sha512-3W799kNaIWwBNgbmznTKI6mPFXb2hUi98zQFLXaMgFcA5z5D3euHG7apClasjHZhpUKa6hxpy4Hp/IjhyX1xUg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.21";
        hash = "sha512-rVdi92QPj35cCE+OA1qoRMF9gxRLSnT1sGwNbzytAOzAZh9V6md4vVxvMy6YMZbBZu3eKuPJNGxfeaIIwYeNXg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.21";
        hash = "sha512-AtHmnd3c/QGQWPhMgZ202WOc+DzviMAHUHjmFkiMJ+4QqeWTLiRTnD89/sAbpEisI/M43etV+ExPuZorkKdkTA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.21";
        hash = "sha512-H5cykB7hyB1ZEM/rAW1UFA+rcIIrFmfc3nLFzofmt/xCYAivzTAjidWcb5I7yvqbmn1tZE2141g/TP9RtagVFA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.21";
        hash = "sha512-R7wHGfbigm8oheRJakQ5eYnDOxMsZC8SYtNJVPmaUFi9GxEkv7NKvPyIkikfrGo+myDmZUJDNhCQTQWKUh7Sug==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.21";
        hash = "sha512-bq3oFRY9b0TV5kalzxjQYlbRxchZ8fZACNSo+m4/91n3zLQjXPZ6ZS0vOtL0SJT7x3R3bsNh2V3da3ukz+L9uA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.21";
        hash = "sha512-ZbKr9l073MLl0svNwxGyypXIfBu1INCBMTz9ShzTxk6NuIWDNUQIctlhRS/9u5YhgcmdARaHKCSQFYKB65HC4Q==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.21";
        hash = "sha512-YVKv2ye8Cyp3E3K4Kj/NYA8qpoQz6LppKg62jHD/N4J8cj8t/tLJYffeh0hsZUhCP1Ydxv/Rxnp0+78P+Z4g5Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.21";
        hash = "sha512-0FzT3DglqdrDWEvdc8z7fVvOeu1LHlnZ75ZyhB4yG+G6XKyzzGt6CZEjoBe/zocYNxAVeRIrfE/ZPIY4gsjaxA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.21";
        hash = "sha512-74xZYPKQSBvf5lXglqGN/SVoxnFIVG4WCNZsBbAnjY6tvvyRJMVW6s6WPSvGij98x2QStRed7Y3vd0t4+7sn1w==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.21";
        hash = "sha512-XuoU/nRlMlerRDa7NS/G3V4AjNlD+eANZO02nrpaR2H1AqVR9wvimMjeW0Zcw0tGLJ8gL2zpmhj/aQiMzzI1tQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.21";
        hash = "sha512-Z7fuSwQqWzEIggXpQw1c4lO7LVCoWx8Ih1kq7ZNa6HrZwukdy0CJzKz6paaLstJGhMVnxmDrUG+68zwLzY82OA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.21";
        hash = "sha512-UwKYfaiCNn+DfNSPeTWOLDkaTw3Sb+igh3dqpePo28Nrzg8KxqPl7Zon8ALmLy/R6cwSwjUBHx56lrAt7xebVA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.21";
        hash = "sha512-p3USODvt9lIKBU7GCEB/HidLikl3HRIHIDkkClHrHs7hYNFA2vSCv0rjHgpB6BxWMCyLT2bTt8sy9mEw2JY0mw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.21";
        hash = "sha512-tvJlCcGBQt6rg/Ia1SsJIaSxOOatoetlRUTZdYzQCc5pIWhx93GaJKSr2YJISNEOZVE/NNI01PwUe+YLCvGJkw==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.21";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.21";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.21/aspnetcore-runtime-9.0.21-linux-arm.tar.gz";
        hash = "sha512-vw0eK/iPSDZr05etxvAntZSnwVFbsaz8deWLeaF3GtpLONQD1Z40XDFX+MROKUxLOdDMrlwg/Y+l48A+muQKYA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.21/aspnetcore-runtime-9.0.21-linux-arm64.tar.gz";
        hash = "sha512-uF4vTXcCSmvD77MpAyD3MCzD/HgN0OISG8mN7UKn/Nx+z6I61bgWBUCHuyEQvh/Y4lw8U2NahsX94tikZiX20w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.21/aspnetcore-runtime-9.0.21-linux-x64.tar.gz";
        hash = "sha512-wv0ETDLLTiC70C7G+LWyJuYhHxFACedbu0hdGStuQuhZzKFl1SSEaNHZ1OwfYK2vu5ofISG2LMQyAZ6CENk5Jg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.21/aspnetcore-runtime-9.0.21-linux-musl-arm.tar.gz";
        hash = "sha512-vMeZOB8ojRYIzCSOx6rIPkZbhhYt9zzPImyfa2dcVnK1Y/JRSR8+vDGzlKKWbzS7d6APVjy21qowTjJfp0bbxQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.21/aspnetcore-runtime-9.0.21-linux-musl-arm64.tar.gz";
        hash = "sha512-rL3bhb0u+XIiIvgf+caq/G4QzAmdX1J7v3JoOJt8sbebmKnqqH1QUOA6cSNxCpW7UW1vhx6kS9n+JmR6cIMizg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.21/aspnetcore-runtime-9.0.21-linux-musl-x64.tar.gz";
        hash = "sha512-mUkqWET1yZfrTQV2DzCt1zTPLrhYq7SfT/5LMi5nyWO7NAHUQAd/frzM4/WABJdFTz9Q2panvZvappAc0ssiXQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.21/aspnetcore-runtime-9.0.21-osx-arm64.tar.gz";
        hash = "sha512-SnPpnlQRN/BiYZFy3rZPvCIWdERCwbaQFFGS5Yxl9AvoWjInYKuxMENOTGQrkLOYb/xyIkOUDAq5s8H9m18ZTg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.21/aspnetcore-runtime-9.0.21-osx-x64.tar.gz";
        hash = "sha512-/BI1YLgdvy0kmmtpXkOJVqRaKsM7/ZkfLEJE7oSbng6azii+7AOZ0QlL++INnSQQ1zYUVNKzgrmMkdRIAIK3hg==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.21";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.21/dotnet-runtime-9.0.21-linux-arm.tar.gz";
        hash = "sha512-rmY3XTEykH6GMUGXyPn9Blo8H9jjkGhO7/p4fM27mBnfA1RtXTlbFBlbdsAtfpZbEA0hX3d1O1fCvxehXV/ioA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.21/dotnet-runtime-9.0.21-linux-arm64.tar.gz";
        hash = "sha512-7meofO7o1PaD8g/ldv4DiG4c7a2QEcPC5SVpOEnyDjeU2OluciCZhczj9LzsaBb67I8x5iBv/B06YHlo94ZtjA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.21/dotnet-runtime-9.0.21-linux-x64.tar.gz";
        hash = "sha512-b6qEfiWgK4fHN8giLG9fn9XyCUW30jmggKfj2ZuXr0jmthIapV3uLnl8yJ/n65fSNeEkIrGyJ4bL8WlCAVauHg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.21/dotnet-runtime-9.0.21-linux-musl-arm.tar.gz";
        hash = "sha512-qvPCRMwS6oM6gkffMpB92fvNaD09gFnayCGiCsQWVyoeek47ktfEbdu5tD6xGZtFqh4i/R0ZYgNKfg3W1g8H/Q==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.21/dotnet-runtime-9.0.21-linux-musl-arm64.tar.gz";
        hash = "sha512-uJStHwiXiV0tWnwEupqN+F05Ylm8Be7+/bJuqGPYWWIHrnKLlU9XkDQH868Da9covfCvVGuXmpjQ5wTS3U2HTQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.21/dotnet-runtime-9.0.21-linux-musl-x64.tar.gz";
        hash = "sha512-VKdQvRoKoWnyShjSGrJ/WWnK/5L6DU2h7KvZ8/Jtlax5Dm9O5k1EUVbd3gAgaGoesUwR86Os6VQkYvwNPh518g==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.21/dotnet-runtime-9.0.21-osx-arm64.tar.gz";
        hash = "sha512-Yde0KF4EKGAUXPvp9WzlCaRgxf5rkYQeUXM2VvXXPNX2fWyTkt8R9T+q60LseAj8e3qR15XH7PKljY+n7iKEpQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.21/dotnet-runtime-9.0.21-osx-x64.tar.gz";
        hash = "sha512-5vKa4y0HejRcH6L4wapbnZGvbuv5fn3r2yPxWJz9AaMWWr46nwhr//+/jQw39fr1pNPwNYNwKZylVCpGgbjALQ==";
      };
    };
  };

  sdk_9_0_3xx = buildNetSdk {
    version = "9.0.319";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.319/dotnet-sdk-9.0.319-linux-arm.tar.gz";
        hash = "sha512-vCi80OeWsupevPDweHt/fDWBICu+vCoBcth8C7UfZrvWGhP9bOwwAVFhPFFgR1i+HVRLIxU6MPT9q7+t6K/pPg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.319/dotnet-sdk-9.0.319-linux-arm64.tar.gz";
        hash = "sha512-lAsFZRGweMSrFTGPOnphFMV8bGNqsyAn6QEp4/iyBSNqHGr3lOs1qIfXvzIZ/0lSLaLLn5ptXSbjkJCcJVNu0g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.319/dotnet-sdk-9.0.319-linux-x64.tar.gz";
        hash = "sha512-7QgLgd0sylakU8k5RosAYaYKCDqH6vIeA1eUzSihT8APr1LZak5BFvPMHeQOYonNDwio/UeNSeTcTyhXDi9gLA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.319/dotnet-sdk-9.0.319-linux-musl-arm.tar.gz";
        hash = "sha512-RZyZaYcOlnv/0PwFKWS9QEaLW5vCnsPKkEkLjQcv2GS+IMGGB6+U0anilHMFHYUkQ5Bfw6D07nk6RO0772XeUw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.319/dotnet-sdk-9.0.319-linux-musl-arm64.tar.gz";
        hash = "sha512-+Kq/OXnIr9NokBstIIu9bTzy61BB1y9rumAxuWSoZBmdbIHxdzsH8ne1RS0NSLbqN2pNgJ0VsZj1KA9swgSvIw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.319/dotnet-sdk-9.0.319-linux-musl-x64.tar.gz";
        hash = "sha512-iq28J7k3Qr7Pdn0730bBejYJtHiA87kTevNCDK440C1ZeYCZhz0ATHpzoygey1+Q1RYkdYV359966/p7/0My6g==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.319/dotnet-sdk-9.0.319-osx-arm64.tar.gz";
        hash = "sha512-dqMsXsyPA81sgrIlHEjb08T+pxybd785hd6tqVMzuPiQArjrIVUnLKHjtEc1A7yr0z3DvuqpdVBc7B2O9/GDMg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.319/dotnet-sdk-9.0.319-osx-x64.tar.gz";
        hash = "sha512-eDjBiaC/p3FaGnow5uv9OI1qOnYOr9fWzCSnbgoX6oO9CLThx/9pgMpa8BQBME83KYdNe7mXJwxUxE4D6eq8sw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.122";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.122/dotnet-sdk-9.0.122-linux-arm.tar.gz";
        hash = "sha512-7UNHa5macd115slB27+pWK12/h/Pux9wl/Zo1ySSqDn89L1Ct7mn5j4dIX/hh3EShrBOj7mPCOxLHySiFGz3OA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.122/dotnet-sdk-9.0.122-linux-arm64.tar.gz";
        hash = "sha512-HnY55YxF2qd/Tnw1hynzfSVVxV111RV1m898l9RBNQcA50n/pnnAjxwwOrxMB4YCjmq7I4x7bs2eN8MKnPR1Dg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.122/dotnet-sdk-9.0.122-linux-x64.tar.gz";
        hash = "sha512-ZhrNxI71QeS1kcrsHvl//3gunRXJbUelPzimDHOxFZGrRuurtzEGbmINiXV7kQbyTQj5n358UKPq68tTlGdKcw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.122/dotnet-sdk-9.0.122-linux-musl-arm.tar.gz";
        hash = "sha512-ZzIRLwBog7ZG3EnKEYIxgW64mA15gWsMbfziUAzNVTchNGgHIqAaTfQuQLGPy+8JJHtb9tZwWfKnOGjSkyNUXw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.122/dotnet-sdk-9.0.122-linux-musl-arm64.tar.gz";
        hash = "sha512-k8/lsGcKJ6gAwx9oL+3NrNb6DIU5IUQ/X1txoOt0/5u5K1pgag8u1WRqY3UgVrsoIJcy59hVzY2yl+g9hHeIAA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.122/dotnet-sdk-9.0.122-linux-musl-x64.tar.gz";
        hash = "sha512-0cJ04wrzTqFJ4S3OFnLIBo19NPiRyYHYiTrIIsJO6O5nOGRIh4LZhifqIdA+Jy3Jr42aX3H3L49fCLcO/n4HMw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.122/dotnet-sdk-9.0.122-osx-arm64.tar.gz";
        hash = "sha512-j62WDOKtJAbQ6cod5MrKDi+k7WTTHIOn13vvJodqNmlYDGLJ/dJ3wtdbHKR9fascNWXp/46zW7kgq7NsYzpYyA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.122/dotnet-sdk-9.0.122-osx-x64.tar.gz";
        hash = "sha512-riqC2pdrWH2RyLXiAGT5HXvX2y9TDtWyiBh8smsnt6M56c2FHvhfkJyp6PssKq8zAKfH45i+eGkpDJLDSckMDQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_3xx;
}
