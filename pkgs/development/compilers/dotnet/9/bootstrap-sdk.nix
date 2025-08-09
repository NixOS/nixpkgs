{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "9.0.5";
      hash = "sha512-npNR7X56F/j6xczrnBrWGUkvd/gaFU0CaLswiMQbGnIi1MYJ2woFPiLe7bJnlL2xhLYlpgob6o4Cu6oY7N5uzg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.5";
      hash = "sha512-mVdknn4KHJG9tfUPpwDf2/kYXi5nA43FsOFBYJEwxgv5+lsKRXV+0hMhXHHItSHwWv6l3KxKhXWzBIXdC85Aew==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.5";
      hash = "sha512-L/1jHi6pAYF68CUlwlAl27IWrVECmIb3VnDC8oWtEVCBsvFdrt+tjG5SJHGOHVfnNlDvC8dGAg5CNHQB19/GFQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.5";
      hash = "sha512-u4CoDTKdSfJFso3oje/YhLxEbwHz6OsBnupzSNXwetmdC58REHsNHfEXiEOoDh8eyc/MXNBrkUjX4kPQuiSSOw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.5";
      hash = "sha512-bMyx4wFS2+u32e6rhVJ1qbSvhiWw/Qd1AB2Nd9BcQYJHMcwPAfLSvmUJHltzKaFurGDRKDCzm1Kvf/72VRpwsA==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.5";
        hash = "sha512-lVHFQ8K2gcq5xN+mrzMBuE1FFsDOVrwnzfaGneSZr9aBt6pFHiMpa3B/IN04NcnV2ZEt93qnsj9QsxU3F5cxaw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.5";
        hash = "sha512-e2BdyeR5hL5tyTUY2b0LmRPVB5NZ/ioCVVbN+G7ZpxufulVdvHGR12SrweElzipvT1hUSse71RjO2UB3nxjurg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.5";
        hash = "sha512-X5jO/py3v/DcQO4P5TknH++LPHcjheooI8fDCm3KQXejUaVMv3GXFbeWtlpoBjbmhchS95Ye87OooPsLDTOntQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.5";
        hash = "sha512-sO9udn058dZbRQbNq1oKILhQ18cCZXOa6DLh9JgLqA9baoUfY5OfZNJfmS/kfOILKbCUrZ6WTtHMgZ7ycPN0/g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.5";
        hash = "sha512-EAWf5+sR/zL7che2L5IrQTpjBjw/n1ZOFSebZauy0E4sHMFLJSb8KgWXzQG4wN5juTJbMseiU8VbNOS3tnXDLw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.5";
        hash = "sha512-ou/tAJJiTz8RkcGmSoHi22LSrjJL34GicrARl5WR84cVxVmPKjinwbO/6ys5UmHqg7dlSsZXretTdWfu9EdVhQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.5";
        hash = "sha512-4IcCNgCcWEOmV+JuEyaEzyJpFhJq3ktDwDPVoMf2c6fNhtl46YgjGjGdLw1uLHu3UYAcJI0Tlvd5kizHwoqEIw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.5";
        hash = "sha512-AMq9q2VAWgNOK63kxWcbvBc+wUUB2a2gK5yfeNpj0pK9rb3i9np2tmm7RbXEDCkDr/m6hR/kqm1RkbhvRdofEg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.5";
        hash = "sha512-Ndx5gVPDtSfwCwFEXm520IUk86xPUQ0yzU5ZkOj5Enkn2Tt3eIC0rI0Stjzs52/JYo1oHM9Cj0FKoHvm2XX6+g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.5";
        hash = "sha512-aE+vLS9/ZwCaunIpKgzPYl3siu7eglD40YpT/ggX97+8JidaS8D/q8/nJ3CMAFwkWs6RfcdG739YY8TvcfyYbQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.5";
        hash = "sha512-Xa1BhvYwDZP0ajkx61psrhbovJf97lUKXg58LJY+TA/9xURTUcMrHSn5BB+wPHDYtBNsJftserTvG+HeR+NXQg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.5";
        hash = "sha512-iXbcLp5noA610tVVbvppH0WoGw9Tk7x0sVmbEhTfvhtrgz7SAYvnJci8XMaWIUNTVterN0w50E6dEHUV1mX+wg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.5";
        hash = "sha512-69GFvWBiC0BXfgDZ6QhMPr7pUmrepsvF+C8I7X/Co0KpHtB70/89nshsY/i1H3LKp0vL+pfbJFRjvTrf+L2Sjg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.5";
        hash = "sha512-MmwaKx16ig2VMYpnGIhhIDYfNonXUUf+DocK7hg3Ur+zghob63ZQ4diPaMv75gJ+f0TVWHUDuwIn8u4apKE8ew==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.5";
        hash = "sha512-A+ZcBjMxZRcWNYjBUQ2EoX759Ls9x5gWHe3vdzfWF2YCg7GB+vGlQx2UtdMfkaGoH/nkCXl0saghJSuSWw8+DQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.5";
        hash = "sha512-urCeKcia9RhVJJOBROuCXfOBTB3qbAO85uyYhglLGSaT0XAHzQ1p0iFS+nZrFBdHTBJ9Z0eK01mIW03FNAFb0w==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.5";
        hash = "sha512-NI+qfc8De8XP9ppO1q7vWBOqrDIrW2/Sza/jUN5tObfmJ1tycjpChtNOs3mSrbU3Z/UYrAQkvupGYvL+gCZSQw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.5";
        hash = "sha512-Lcuf3n7bbcm0qc2lqzMdrQHpS4NHcUPp+3YVrfDjRsxYquSooHb/JtlslBmLhOwzUMUD3y9pJLAd3pk2K8+iDQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.5";
        hash = "sha512-CM/Pt1M4wrBxhwu1tC2smQ3b89bK0tHeHbw7bb5N3t4S9TO1OihQUSNpKYNYUcag+i7MQACkJ6ar9w+QCwUj1A==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.5";
        hash = "sha512-dcr6pOXx0PgN1WGp4qNoxx6/VG5DxhhbOaudgoVnL1xLup53kjIytNx3K96gHVzpvVTQKGt9RgomX/bTwYuuJg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.5";
        hash = "sha512-zxFRCxPWBcsHfMhX4j+yqRHnbeQlR0NTw8JEYYO4d/V7hgwBL3obJQeTTdP+Xh68QxFPJFqAQTCJTTy/T406bQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.5";
        hash = "sha512-aUM0/okMRohpeJmvrRHbpyF69SptLu+DDufJC3APk0I0ok88T1HSlG/vn5Apit72KTOc70vJVMVcaQcNAN1R7Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.5";
        hash = "sha512-xN6i+Ov/DrFY3S9W5jVW475scRokjdiMITS05+NfPXQC70zE/kfVujdXVQlU1a6qcNVO1p70PdMIzvs2FRtpVg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.5";
        hash = "sha512-Mt8To4crSMlcaHP/BiZuUAroEYQyOazOx6jzVo6H3GNlLKY7rIFk5cgKLXxKVF2fLcnab8d/DbBY1ZRlW0DUeg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.5";
        hash = "sha512-V7LGhVXf4viIZlEBldjN9P5zririHYIcF+0WOdWVydaOvygXoY4Ni4q8vjFSZ6elJAtremagj3hIZyXQul2+jA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.5";
        hash = "sha512-Ohgbw58CYKcYdo/wX7jRSwbgmZbSadu/b8bKeuRFQMSg5T0UH8yCjSqZOptt1MS/8HmpbEIA1ftgkT9agt+OvA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.5";
        hash = "sha512-SHabZtiO2X3nJDFFO7kgv1rBpoSdc3oIHqQ2B2CmfScUO5vKu+ICDPl8ppNblEO8QijdU7Ro/doHY0J+sCxGoA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.5";
        hash = "sha512-eGGCJb+uBv6vOgtEe+ED6KXtAXbCcT9xTpDwugitsQ8zBhIwI/WurixXw3TjmUqrvZxZ+HJCPoRl/kMmNuioeA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.5";
        hash = "sha512-3LsjkhMoNA7EvYv7O6OrVrryhyegoSBE5Y5Se5iJ7HAXFSUQ7fIYGihhGxy/Gfr8X7MrRu5JGkLx9inxSoB85g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.5";
        hash = "sha512-G6euOgaAfYCYWmWlDU2NFfpZ6tiC7/fDiMmb8YtlQVPI87JatLGWduxQQSqdhwKMDJuQZob6tW+Dv7a3LZt03g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.5";
        hash = "sha512-dj/5fuYoWKYLwm0RMvVUDM4arCBwLXBIZvYZJRTQFlv9MFxwVrmaeqjL45UVI1RgEzhwLLEUR2MQM7vMUP/QLg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.5";
        hash = "sha512-9cYhk+OCPeVyNyFEbAweEqYHCIkreEWXzXyP06hpxGu8b//n2hLrjXv+aErRjVzGlpLZoRalMyzREx7naSEgzQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.5";
        hash = "sha512-sFJWSzk+HKZ9vSOgN765Nru+XAyebFwgKOvAdynCv/2hvluBYbS8FcLkydd+n+PYDrw+yXf0VPWlzpnWeSmz1A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.5";
        hash = "sha512-8Wyh6qTQ2oZaJeGP5SdiWaXoMc6NRMmhHTO1jd8H1XHhgBRXXbkeSHOy30+HInhTiLo+1h5zeI6WBZl559Aa2g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.5";
        hash = "sha512-mH97t09X3T3JlJC4FfWdX0aG3hYfvmBtA09ysq/eTXEKmGJ4jtl6I+EfeI9dVPFSdYkHlBpMLmbnyfThTJqg9Q==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.5";
        hash = "sha512-tBjTfNRXttxWvq296At7QvA++n4lr2TnPQP/ub5wfsnELt+IIjnc7Kt8c+qKEJosdOP0TOKiQoyYbYKrH1JzBg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.5";
        hash = "sha512-pJotYqQ32S9wPYYlw/xgMxrOS/IGDAxWnHNtynxxbyrLGe+Bvpu5mAWFOieTCd5R7PGgCStLL/RCCzS2HDo4/g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.5";
        hash = "sha512-PX4wq6bS5SJraHVSM8JVazfoPE3YzgIht7zIvFyobXqRKfH26DFmolor1vGxlFoboyOxIvjaG/Ky8nXo9zTLUA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.5";
        hash = "sha512-Dnl6fzn9mg5UnGShXymf1P557chMX39XUQZ8GnoTYIB7Nmni80ncNO3z24WcMDvr4U3AZJvk1CARRLAb8sk/Sg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.5";
        hash = "sha512-7OeO4DIkZcGk4RebYl7T4CKXM7JfVwpYFbkNqHDw8JkzqlLZoVKRgx0jKxXZbOXQ0WN+rJttGKdBDeiZ3zmbXg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.5";
        hash = "sha512-tZ9zT1WsKnq5YQhRn4VMGESI8ESDdUAcjQX2/zsKQTW/jpTHUWxhmT/M6EcHp2bMKzct+vF32HCJvZfrbCw0iA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.5";
        hash = "sha512-m4VQm5xFePhThG2c63/d3SvGi03zPEFmQcKycV0lOqRHlo809ahHkhq7taiftuwRTfFy/5R8+5TEsaAOxQ6gpw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.5";
        hash = "sha512-fgOU249WCVcsLJdS6BJ1auevUutNXlCqcsyF8wECB8Oq8SSTMKKFFJl8n02n6ZoJoGp0nsK2LgubYatGq6CaVg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.5";
        hash = "sha512-WUqvMm7lDZ9qCfDUQSTyuBr3julN+SANxShfxBe972+qO9VIH7JRL2u85hi8IKP6L13L0mVX2rO6iswQfCZE9g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.5";
        hash = "sha512-2Y+mmx4hJtcOwNb4qJUuqv0ekrjAyFS3zCK2a6T2TpNQ9ON+ywbnkjQfqwo+hs9uWE1TBiXS1iGgJ6k/f0W3Nw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.5";
        hash = "sha512-AbfmNGg4zIxlpqakXSdmFYk6k3JE7P2j2z2qUymYbuCHyzS9IqwRIL6zK3aHhUS9b4BWrZkRGbrvq+t9zYERMw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.5";
        hash = "sha512-przDLKwmZAQ3fdAlyZ7QGwZZt3s86rgqrcNO1+nmXcCx5ZD6ZlY7Az9QJ4yXkSARFZ7Opk2jep2kEW7Cfpv2zA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.5";
        hash = "sha512-KiwdOy8CONzPmGpfSClgu06GPh2W/6Dhp9IA6cUXx5TBi5WgnoDmd4Me9Q6UmGISuR6hCHsKiCWhh/5h9pJDPQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.5";
        hash = "sha512-VsEjG4O4eutC8yMRK6naQco648zjpTNl6yxP2fCqH96hq4epnscbmoMio/Bxopt7Xi01y+L78zEcJF8bY591bw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.5";
        hash = "sha512-g0Sd+FeVygI2RcT/5DNLcW3c2sePB3aMzc8SAnPI35YB4wfQSbrCeN6B5pw0rZAGP5F6FnnVRfZUTJgcnWCZ3A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.5";
        hash = "sha512-RUBFgRdKBSinOH0IlR8RW5RJOf4jghKTRbVRUD8JgcWriAfNkBboyCO9EhuBEs7219qMlrI5VtQxDKrZi042EQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.5";
        hash = "sha512-OPTkSCy26Na+K4J2xpIHmW+KquH3QUguRR3PH6pr0pggL0Cs9dvEepp2yC3oy5422K6yijhyBQ6DnRGJmqh8kw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.5";
        hash = "sha512-efQXE4FXpKHFSaW2/qEG6QHZfe2QnOXzyhVxQdF35HcExk7zhkRzdQigtQ35ugDfjfG2E0bnMijQgAowJ/OjeQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.5";
        hash = "sha512-2MkjZyR4eKtpIwYtwa3/aJD7v8dz8CfE2wQO0+HX0kiwi/UbUp+R+l6//QcjEm8z4CLZUiR7iu1GoVFtbHVFUw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.5";
        hash = "sha512-nYw2JUWOVAWFEkJ0QF6YPOkB5/YtauREJqPDvu9XOETbozItpvO+qkrEfMUfsZzZOhg0pDJzYrLH0Y1DfA0QOA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.5";
        hash = "sha512-7RIDa9js+tIxcs24Ph4IbI3/bmimPcDHhWuO9wGEU0LC2FVSZbUnMOpdLUih5uOQYHx2upBrGqDXzs3U1YjtSQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.5";
        hash = "sha512-DWQNw2TAkz2IghHmpdBmDy6fjJwUT0xpfl5KcN32EmXFgODbeDnlOHyGrW+DnOg/jeiBwidNz5bLH0Yeqkn0iw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.5";
        hash = "sha512-niFnR3jx4KQjMUg0MOP2OZAN80qoRnstTi26vwU6OREoVN7n+9sa3iRPaT+XyyUa+/egzbU2TTrR2zJ8+dNrzg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.5";
        hash = "sha512-AKZVJ95KmBq2a3LGiaBLwByTpbeiVOcQIbOpbvUxm4v593/2AfH5YkhBO3d9DkX/WcmTIxCuVYArLKuIBBr5wg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.5";
        hash = "sha512-7FzK7ZFl2uIdoxbry0OhzREpXD1hw2JscEnScAqakRhN+VjxYwegvwSAHqIBKWIoP4lwnFrlCWi0a7Tx6uqPvQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.5";
        hash = "sha512-OBtv2h92NFsBd5igAFCfEKhEPLoaAzlWEOFq7DgIwxSK0dRgxsyoN1ucuFyxcdhoeoL/tgbCCln9PPhFiOFKzg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.5";
        hash = "sha512-206fJvhhVksd4A6+vl6SJQSOIBI0RnX7LTpTzTZTI623ujzvNeRKxnvfaPjvic3p4y5U4ylY87ZKnmDyxF4LAQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.5";
        hash = "sha512-pKjelywn3XQhcEjlRdH+KG+itTvvh7md1Tr6+lH7RSiQewicsTO62pRTRPmEPUxEqRQPcTfSKVgC/xqvv1cWrQ==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.5";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.5";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.5/aspnetcore-runtime-9.0.5-linux-arm.tar.gz";
        hash = "sha512-eIX4bcjP1VVwFzn0fhxHQKzPuyqu7vYpwp/XXCEcpVbt+HN8lCcYz4t8+oiGAN17qBk6K+G7vwdUztlS12IXyA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.5/aspnetcore-runtime-9.0.5-linux-arm64.tar.gz";
        hash = "sha512-vR2xRaKbLu9EDroEkcW3C/KeZ5PrqrRT0pOb06wWH3wz4+Sx5lpzTdT9RBUTV7TBUKTPy1recknL8tAyZtazKw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.5/aspnetcore-runtime-9.0.5-linux-x64.tar.gz";
        hash = "sha512-tguLX6a0U4BlFmzRJm0HXGTEZLKBFZ2YvwMTK/NjR4zMEYWppRc4y+N9hnUoIPa+St1SCBIKgN+yv0qLWNIsxA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.5/aspnetcore-runtime-9.0.5-linux-musl-arm.tar.gz";
        hash = "sha512-YryhSVOANUVOUhIuUGVy3SbtE7Nwfsd9zArXqzntONdpMXBnbjjuvOslKei1avpYePHAh087DYOR7AF9Jjhnrw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.5/aspnetcore-runtime-9.0.5-linux-musl-arm64.tar.gz";
        hash = "sha512-EuBQLBGHmpPlpWjRm0o7UKCWQluSRyDP3E0s5TI0URhULqLdycxAn507cG9srClSr/o9JTF8vyQL1p1DFZ4c6w==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.5/aspnetcore-runtime-9.0.5-linux-musl-x64.tar.gz";
        hash = "sha512-iA1sUWr0bdoGhsDlalXK1djDS/48rNvuaKnSGl/56e6TpsQn7wqr1MRauVqncu3JuJkn840HYZ22IZyT5vbkOw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.5/aspnetcore-runtime-9.0.5-osx-arm64.tar.gz";
        hash = "sha512-t8U4cBgq0tJOBSfDvtbUYmdrOuFfqE45fuaMhLp6IrqnJVrfaBZvQclyE3gWnGOGTcL90HozqvAWwjqHoWjOxQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.5/aspnetcore-runtime-9.0.5-osx-x64.tar.gz";
        hash = "sha512-Zimt0BcbjwVBVbcLw7jcbOmfHZXGtlVoJWQcDophzagfIdB7x6p9mT/1H5VE72maJ+yhL9LV7rRnI63i/Sb5mg==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.5";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.5/dotnet-runtime-9.0.5-linux-arm.tar.gz";
        hash = "sha512-AK62AMDFfFA0gGXYWM2F7GW3K7HBN4VD+RCPPNK18z1S8/A04UL0XpLHbBceMwkMJUTjZh0B6o8OK7IPEdW5lA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.5/dotnet-runtime-9.0.5-linux-arm64.tar.gz";
        hash = "sha512-/9f20Wu6ohSUtxtpLFSl45jzHPYAhw4CgjS9B2EsttQ2dMY3H6hHC9fxG0CmhEPSLjmoQVfKuOFvUsXFzu47gw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.5/dotnet-runtime-9.0.5-linux-x64.tar.gz";
        hash = "sha512-Ap8d9YDEfyGq7zykDlwfuOVIVJeNE/6IVw33w0CEmf8LnblsSSwD7NtDqCqiTbvoFJHegRkTWSrGKsWN7pdbDg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.5/dotnet-runtime-9.0.5-linux-musl-arm.tar.gz";
        hash = "sha512-zOCaJMC5hw4yk4mrKq4uduwiu3g4ZUhQqxe1aVH7oAsVygaS42PNXh5dENHh31poVH08IWFDa4VweNAYK+/SKg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.5/dotnet-runtime-9.0.5-linux-musl-arm64.tar.gz";
        hash = "sha512-3Umzt+5BW+Vm10qpn151lJ9k5wFA1NEOHu01SPU4LmJdXhfps7Qa5WQykhXjwWghEKwXMvMT8rOpDAh/elo5TQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.5/dotnet-runtime-9.0.5-linux-musl-x64.tar.gz";
        hash = "sha512-gaJt2RlTpHQgi0tDz0F0RC6flQJDfyV+Zuzv5Pm5ujzPWziZ2qwGHjoKzBQdW+IHwD4rERNvR5GykRw+8+JIiQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.5/dotnet-runtime-9.0.5-osx-arm64.tar.gz";
        hash = "sha512-EqHeE9GnLC5sUZjoOheOG5Mlx8Ropzh8XIopsIVxYL5ROVFgI0hc6RCOJukaNfqCUqjywNWdRpGxzkbWaq2lfw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.5/dotnet-runtime-9.0.5-osx-x64.tar.gz";
        hash = "sha512-iz6NtMTvr5StbZRi1KcD9ZusOQuRd4d5nX+L55EHmK3ISpaDzanv6/s5ontBpTDptaCC3dGf2IT0PRZ5RsfMRA==";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.106";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.106/dotnet-sdk-9.0.106-linux-arm.tar.gz";
        hash = "sha512-IxjIV4THukOiQ+D1Jix4zCmEqV/O74t4VQNYU9nHtCC362gcjfiiOWmSbWZSxpN8+xscKWHgoVXG8UUwIkC00w==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.106/dotnet-sdk-9.0.106-linux-arm64.tar.gz";
        hash = "sha512-GAY+1Tnvz5emgms6NnuSV0M4Zj6BXkx60nOhdSSnq1411AdZb1zWscCjfmlbF6kVYgwURcqJu4UasP80rMo09Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.106/dotnet-sdk-9.0.106-linux-x64.tar.gz";
        hash = "sha512-+XfJCl5Ww9t7fU4jhEzbSW7pZr0xrWP4uENjp+/yij+xQQk1A4G9g23bxn1nUPP33VVHHkxdALAhQ0F0GFb7LQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.106/dotnet-sdk-9.0.106-linux-musl-arm.tar.gz";
        hash = "sha512-LJqqzcQ+Lai8ZNtRe0q0Dzh/kSky3Cbpn0Mzi//SzthnRyXtGF5gqzF48OTnI+xfwpd09iszes1HUhvzia4Wzw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.106/dotnet-sdk-9.0.106-linux-musl-arm64.tar.gz";
        hash = "sha512-g00TYlXiwiDnwDJ7xH6JMmtX4DUrarAau6Bzy9pNTSkzy8auREDyuZEaUq1dBbwPf/s255D56kVhVn3T4ivVFA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.106/dotnet-sdk-9.0.106-linux-musl-x64.tar.gz";
        hash = "sha512-KPWtrtyl37HAElwyN4lIXJclkaZcvVGPtdlR1zEx3h56kv8JcTYieI0CrPeJBvp0ElOMbH6bPEv2cV9klf+CbA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.106/dotnet-sdk-9.0.106-osx-arm64.tar.gz";
        hash = "sha512-2145z/0yvpm5oO4oxu3pBjcYAzhpNwHRGnAtBW2v9QW9gtTnyPDLNB4g+gK5dlYS6ogIr0DaPrxqFs1tP8HqPg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.106/dotnet-sdk-9.0.106-osx-x64.tar.gz";
        hash = "sha512-wTKDAvkLLY0SOqCyfiCFcd17LMIwTgexqZe8BmRMXqMLsdCJ/A0/FO+kH/TQm5FA1Yqo/TtqGYeXXVbnUL2oDQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk = sdk_9_0;

  sdk_9_0 = sdk_9_0_1xx;
}
