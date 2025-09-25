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
      version = "9.0.9";
      hash = "sha512-W8dh2WCiNWN4NAyhWaKGrAM/ZcCBem0Bp0EMPOEDcMlFrIm6ibjCnA7DxDxWPM/W1Kyzt5eLToqTXhhdw/4QuQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.9";
      hash = "sha512-jhI8LV56Ba2Ft6tzbpdUqf0eH7aMCEZvVQlurV7EYUoexSzhqT+qb5t7S8YxU/57R6psvvnA6uMoVahh7SFQhw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.9";
      hash = "sha512-iO2vcnhfd2DmDdLf7JwJDZWgH9PSSsKEYkuyRKFioQSPYGr0LonWcB+tlacP3LzQjSUH/WSL7sNBRybJMt34hQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.9";
      hash = "sha512-T8yCcJrvW7U1Lr8wk6mhRbxr7tpv1ixLmmSxKFRRSAX5jw0fFDwFP6UftrfFG8joxL91n56vvkMuO1+cZgDIMQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.9";
      hash = "sha512-69+Y2iyi+p5X7EOF+iGs6foOhCpA1JIfXxaimipMh3U+5vUU1g5jf+BexzCidM6FgbhkFCEt5lw1TFMrxZiphg==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.9";
        hash = "sha512-l7spf3TE7A5XsgA0HRkbmYDM9S9F0MRCkORxp+wi36OxbKrxkTg2YoD7EjZGPFD374ZRZY5ExZWhZd33Y9P/Ig==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.9";
        hash = "sha512-kyQI7HZcsIjNScBcpy4IDk/OSa8fcdRgJkQLnMaGGBoM0ou2d73d0in3Jh0YIKwDnmCPI4O/54+kDB7e73TxJQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.9";
        hash = "sha512-zH+nJapjIL97SGQnVe7lSSnB4SCNvLaebGkBe9/4j85Z9F37DdX2lPRFrDAhbN/RnBhQaf8iKqHZ2O6Oj+pzLw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.9";
        hash = "sha512-zzTkfpsabKX7gw986tFP35KUUSdvnJsPTYoH5fXAGP+wkyeUXEkRdyq8rMnDPOgNPvD58iOotmjcwO/SXNssLg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.9";
        hash = "sha512-nbbjJS04mF4DB41P92BNuzGfVoxnxaoDUqDNsIPfd7V2o45/QhM9rbxzKEA8CxajsQ0g+l/LDp/Fpv4fkKe5sQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.9";
        hash = "sha512-ZBaxX3Bgg5k3El5i0Cd7VGOhbp2h7Zvz6qa1RpTFoBFlekxAf2x4KgqCWVgZTHBd+Uuq2Lf/Uwi3grEKPkOZBQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.9";
        hash = "sha512-bi2NGA67gk67VROUpbdo3ilm8kFYyilNLw6pWzkr77/urDVZhiw3gu46STI+wC+lwTTZx4j50H4h0mnZv567aw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.9";
        hash = "sha512-OV1ZU4dAdukE8my0sxxueygWhUfhHIVliQUtDZYjvXRhR8IAKX5mOiD0vT5b+PakutqBght7Jn3Kh/Ft/EimqQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.9";
        hash = "sha512-3+wb9BwPwaqkIu1ki2zf4StqhWHNbMzxVKIEdbLTYFmHRb9J8EidVSsE9mO/0EjIrI5B3hvHgDQXQTodn5w1WQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.9";
        hash = "sha512-5esm4aBp1NtzxfujLWxm3FuKSzou/JFFOa36yfF0sPJRe5aNjlHJ7iKIdVY6HpZTcq6YB8APqL7haRso8fT1ZA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.9";
        hash = "sha512-xrgbfVvjHKKpLd/JPiDR6ubhC+igwzUny21PT92jGEQI8Q4XW0odmlsSFTxvcxNBJqFC22HrHx8YBjai0fIjcQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.9";
        hash = "sha512-tJh+NJffHrQCRxrj9dV7RR6Blnpr6MfNRAcGAwM0NZuU2YaVrhQAkaXYIvKcKxG84e9eFCH9g6+PVNI/WCAF4A==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.9";
        hash = "sha512-WogVCntUYVpqoceJARNXWdfQAFj4EgeaKjNJqVRIp4oqoQA/FPMJ0O08Le7gAJs54yn23hbLHd6qwyWE0Iln+g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.9";
        hash = "sha512-YAAE7p296usegl6dDQdsZw0/iktpvsaDWT6UKb0xNypOtooHrlm/NDnKbck9aMi5oaZjbu2KIixxB6JeB/V0ag==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.9";
        hash = "sha512-30sfrI/hwMtS6Ko52i0OuQYxIVJUt/8dW7Mrc97Rjm6H7kzanMtGDdT3aJOyivmWZNuOc81PrpTrfRttLNhhKg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.9";
        hash = "sha512-Dy4dOnT/QrFkSAFldlDnIsD+AU8f6/fGKa/OL7uAocllb6kwE2fSZ7HpDYYWmreVoIjiyuZ9e3wBy1HTPDe4MA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.9";
        hash = "sha512-gVGT7ewQ+/2PcJ5BMyKOLkHUvCy++Sr1ZCiphUTO4nZq5Nw6D+M88YpGEYSN7znS01NDacMyfn9SpmzyIdJIag==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.9";
        hash = "sha512-kFNKIL6LWxofPO4JkcpXu0BDCdRmRHu1DgQJwIf3ONOv4FKILb0jLftw5ZhpMVYtzM0ZkpMt7p+pcJ86yM8MTw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.9";
        hash = "sha512-8it9shRGYYMx3yWp4d2K7gjuQDhcPJDlBi/7HQH4CYt1kOp28Feq0u89kxsOAuEG7aP620kMVOjUXwvx8VTgkQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.9";
        hash = "sha512-2yYu8wPbzfXQBU61nU4/tTUDLPSj80jIjNCz66sJ45mjJ0xJkdOaBOlyJ2lu98C0AUwkJ0BKRM7FJ9WTtxSxrg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.9";
        hash = "sha512-7Cn2JMd5KZWw0n6QakSjUsIO39YW9swm0y63M+m2JkCtHdTnBT6CZGswleGOBinebMJXrJcBv/m2eTYq5R4icw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.9";
        hash = "sha512-3nPmFqr69XC1HbUbzUgo3gGz/d5ACZ7HC6aVKiiPp/EL7ze6Y25+1KJY/E04lQ6KqPi9MkGww0hxrKVXA3ulLw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.9";
        hash = "sha512-J8in2qwkMY/iuLf+JQXz7yegNGvi4Evy6GlFcMw/UZ05wMmpGYT4j0yPo0XU2WEsjmZbIXTkdqGSejerJ/DMDQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.9";
        hash = "sha512-T8gEze69wKZuJJq3hPrLis2orzgdsFIHF5gQYYnvlqjshzUvA7CFJ/lQIKxVUF8nXxAvbXutN0znT+OSVRn6mg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.9";
        hash = "sha512-VU2iPvoScdX72B+jgCd4NhkFzGj8HX5Pq4/TTdE5QglEFg6gJT+UtVhOWyL/orVpphx5YmMvw3edS5cFDhkWaw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.9";
        hash = "sha512-FGmeDfP2ys1zJrGfHpErBTPtXXo7aoBe9MQsndijsygBiJIRLAxY+IYCd8EM0NWjuWrhiTyZFxeNG6m+8eBG1Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.9";
        hash = "sha512-FaJsi8Yedy/eE4I7aT7lV4/L42kB1Omp0REHCUEtTXsdY+X7S1G8j2/iy7G5wG/ptgjzC0Zuzg2PHPa3OCel4g==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.9";
        hash = "sha512-A9veAnV1k0Chjs4e3Zj5qG4QDPuH3EX60S6KrH/xTiVxoLPQkeBEIERD8DK3LbA1sTgqZpninVdZ5WunGJxBmw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.9";
        hash = "sha512-R9z/YVnJ6XhtsUJMl5TQEs5MEPEtIEyQoW7gU36y4uOqJNDT2n92dIffNv6rXig7VxilNS285VlvZh/jx2dPpA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.9";
        hash = "sha512-z8hZUGhxelmSl/s0yqBkc3n7IUv8EUg4FEetPJJss2qjDX+Bwhao+bLYqCzpMugd/2iDD4EhLznrIkxl9ZJtBg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.9";
        hash = "sha512-fJn4MpQtw4UUCgqVgqt9cTfc3xsmUs/zpzwoVgDB3HO7h/evIOIOu8bodG4FRySPmumgmWUuNYYIXEy0PTSQDQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.9";
        hash = "sha512-uWh3vHt4f7pBzW8JZIt5IyD9p4IzjQvWqw4TdpSL33KN1s5r/lfiy9YFwf5iNVxVfC3Djo3N+KE1mNKBj2l9Ew==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.9";
        hash = "sha512-WUWAi0jtODxARVNj5mdG55eTFjmZGVUQeS9daagsjFDUZuuPGkb6bP1fM7z7jUCK9o718jfUyAdE/L9Zbp4PKw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.9";
        hash = "sha512-eXZKZxY5E5pSztmIF9V9+TURwZd3CMF5zmHoRennOM054pzFSouBXlWTOlfWRNmIM+MP1Jg0IUxgIJpDJmLBNw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.9";
        hash = "sha512-frSOH04K9koPazK76I8ZwM7fym0qm4L39+M0KfTfkjky5h1pyF0wyU1bYGC+S2+yZT6nFW2zHqhurakc81USqw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.9";
        hash = "sha512-1kYCnZNFFJ9F397Z3gl2SwcURBhJWPiGzBvO/6iMm4RC6ZWUuk91qhM8FrVJJMhoohEkwXhmlsuxBaNaANIOYg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.9";
        hash = "sha512-3uqbDc7fIJItKIWxh7wGabTa0wskjFuIXjA3h2zX4Q3/dewAZ2OYH1LCth0AMfmOMlJxBHPjSRdCElzUHX511g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.9";
        hash = "sha512-w9ftFt+wK2g04eDOgXSxGSqCpnquZ20G8breOb3sBM0S2YnOOo4A64/yvQbvXdSYhsajAqNNSRjo/Z3nQ08erQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.9";
        hash = "sha512-e8tW+vdm1DDGpkJr6Wb5WvDFnD02q02255IwEmO4wFo9Qj+bCpUHMlCPda4HAgknxMh75zk+AB87QwOvluaCUA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.9";
        hash = "sha512-E4XDkM4huvFvu8w7icD/oIUivcF+15Ro0mea0Qq9gvTIMmCLdwUNe27yb3PDc6CtC7MAgANlyVAGwGVVWer9jQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.9";
        hash = "sha512-K8QFb8DhBzFouXazTEFy3Y2TVE2HjY3XTeuZRHwk6ySHos+TXZZA6EHXhnn+u39zgTMQaSD7LQIswHYHIfdobw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.9";
        hash = "sha512-09cNAKRq9I8jqY+7KyMvKn1/QRExtF+KGO4NvqJDZquH9DvHowIhbKc9sktEEiviJ25zEI9EXT8VIq+6Y2iUfA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.9";
        hash = "sha512-nGpqXHHhhWzlTBFsK47TSU0H7j3ShOTTlT6iaM7qquoCur7+ycLSW4g4GwcnD0mPAX/0khW31WLbzosQSP1+nw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.9";
        hash = "sha512-aeVhbXDevdrsKqRyFqiNwY0YXevA+z0VYmT4IsW51UtmnvJ56iPByoJYdSrz0leYTSYROZofTJmx2bkQ0uKwiQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.9";
        hash = "sha512-xileSZyCIhYQJy4IXAsMZ+OktYWnz5wzTNsTKseA6q/maRZoqNTLNu52gBT4fYlMHiAKMahXymVuPbS4sGwmIA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.9";
        hash = "sha512-tPSjzec3eQ5yl2s31JWBMQ7eU+uYwHwwR11/IUnkJJhYucFtOwEcbtsN1YQhIPEUNFqDJb59+/UZ1SyAqHe9eg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.9";
        hash = "sha512-cbIksRu6+gRPYnaSSeXzUbsmPqShDmmqO8y590qKa1yL+SELQQwQ5NyhsMw6b40VpAzjNtB2IQsTW5s77+gYzA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.9";
        hash = "sha512-Ro/9lBic5EUjAd5tEgQJF5KDtO4B6a/g2CiHt41S8tMddQ71VHuBAvfH9HoHrdJWXK9kkBzqV+gXNqsfariD4w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.9";
        hash = "sha512-HLRXCdV8JHuZCDAyQC4mW0h/dx8Al9h1zZw7HQBd7Q3RZb29myQr0CWvyXgunMKkMBOI79SvfJe3qKfawwyerQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.9";
        hash = "sha512-4BWz2/9630bM3jT0eYeNWUeFTzS/aUnDhHLu7oIabp7DuRO6QY8uOQHdfqZyuRrDloNTXWGskMIm8a17NHAwvg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.9";
        hash = "sha512-f8yHrJ0nPQ6VweI6J0F9SsZbzFaekmX+ljSpyz/rHo3RwtTe5ag32wBxJu6yweXkW/co8zFKQyC94s413/RwLQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.9";
        hash = "sha512-JT2kFQLUwkaGjEWYNQT4w9xCe6qgn7KnkVswIcmq+BCsnj1GNkR5eiTS1J9WMbKdCOafFuxR+4GeWJgBUrs2Og==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.9";
        hash = "sha512-l/3rxZ4z7ektuLBC1jy6q/JrB9avNZLkY/TakGRmuV0klv1Uepbj8lJPnYm02IOlYJ+oyhWGFjeVzAhmTmr9FA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.9";
        hash = "sha512-SsKEfphdtBw16QyRLTAbVht3LifNGZ/IllQqVSX5DG7qD2BxJ3//qoboNOmpupf7JsZQe3fWKObWoNdcUYpmGg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.9";
        hash = "sha512-isb8z7xhoL13Rtm8ZCzVCTWf5fWjyMERGkDqQNoQics33WfcCp3HgVRL5Gufr63lg+JFKz49q0C0LSa59pkSkA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.9";
        hash = "sha512-aHeIlK4Ve8U503fKPmZghAIeN3Ws/9iRLmsey5ObIS4UkR7+lFZDoCFAcqWKCi+UAQERLudqorKkHWLsAWytsg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.9";
        hash = "sha512-VaEZPPqvJasmjS2URZzIhF89xVqx4FywxeWaXTIhNSJ6lbgyZ7L7s558fii+L/7nTQ2fOXARKZykSHeLvPBMlQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.9";
        hash = "sha512-M3umAJUMNf59Vb28nAU+QLT30NP41jd9HaJ8MQi4Kf8ncJ6P8obpwSjMgS71ZtqSZBT2pNXAo/FU3xjzIQ6K4w==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.9";
        hash = "sha512-EfonSMd6dCLyyUuscaCtE1h0NTYE1RjeLPVU2NHXw3vBRy0w2lSTNqJp83bT+2rejSpw3L0FU0jMmt2w9UhbhA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.9";
        hash = "sha512-0fcf+gMcarIvA1WT9bj2Zf3as4lz2xUAp2KAM5D/qq5ZYcH2WqIJHH5FTAcDNZ6fFziDad+ufuR0z2KCjNiQ2Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.9";
        hash = "sha512-QCrojepAqm6pzOipcLvYOz0WzlqrfW9rQa0s9bjQ905i1AYIxGE65yg8jVJwDkJofPp3sKSNIyQXY/2fb5ffKg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.9";
        hash = "sha512-tISq/TnUjXKtrDy2AKTjQuavexCpspcuylFZ4ySov3HEgCGmPA8v6JYhIRR6yAKuAJy0tvL4wt8W8kvOgPGpog==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.9";
        hash = "sha512-VaPzur2V/itmMg81CVVTNyJ2JG8N+HceVL4BLGEiF02mRo8Th9JOTjU74YzpURJ+W0Ubdt2AR7rLWSmBNCGMKQ==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.9";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.9";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.9/aspnetcore-runtime-9.0.9-linux-arm.tar.gz";
        hash = "sha512-3ipS6kqbhyrb4hcJ1uHYhzHkIFcDe4Jvk9ucmLDujRDrMVn73IQhNF8pfPo11pKnNr5l4WRU2y5NNAs7uSjM4Q==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.9/aspnetcore-runtime-9.0.9-linux-arm64.tar.gz";
        hash = "sha512-zS0k4W7f29NCh6SuJeClF6rxu/oP/U07x+rGPYXdVE1DsS0IGqJBmvE6wn/bUk+Rjs8v36kWA5rtZtUCMYpy7g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.9/aspnetcore-runtime-9.0.9-linux-x64.tar.gz";
        hash = "sha512-f/G1F8RbLHcg/BvoCIQsW39kT/kTjyIYYmIOI2YNtSi1lh95FDSqdYhcgI7LO/nSE6M+j/PqpHfffWJW0hWmxA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.9/aspnetcore-runtime-9.0.9-linux-musl-arm.tar.gz";
        hash = "sha512-joG2ImzqEELoXG8y/t5fVx4Zq0Sr68soQbclKTCP59PYS2d8GdEvVzo3eA/cOw/nvDkiw6Ac8ItdV6WcGOrDGg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.9/aspnetcore-runtime-9.0.9-linux-musl-arm64.tar.gz";
        hash = "sha512-4y2qLqw+0y1yyTUY8ytx88DvfqUkXwTo6eHWshDaFJNAB5ZwoQiFzEDYsSKuiY+Q+cnqtirGSVA9mvEyeW8UaA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.9/aspnetcore-runtime-9.0.9-linux-musl-x64.tar.gz";
        hash = "sha512-rZBDC4/Enl8DVK+JPhVd6z59nmUKCKgRJZVuVc34ghQI1OnWAq5tJ7Jd+HBe0qTKglDakIax0ycKtffQmQ5Ulw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.9/aspnetcore-runtime-9.0.9-osx-arm64.tar.gz";
        hash = "sha512-HtiNUoiZPve4Hc9mKUJoTTBx0WC0p3pvwvC8r4tgjCr/hi7MuB9CjxhBA127FAaeDuV1JXLjLmqrAYqNOq/OXg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.9/aspnetcore-runtime-9.0.9-osx-x64.tar.gz";
        hash = "sha512-wl7EpMuh2GfWvXkH0LGokDyLOMNJyy1xvnCgcukbWURrhCZ2DOvWpfOHHzWpzF3lDpf3LCBF4D5lAV5kJJaiSw==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.9";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.9/dotnet-runtime-9.0.9-linux-arm.tar.gz";
        hash = "sha512-rJxs5NQ+i8YuZT00XTK1QYaUTvd4cR9/g1Lfvj5fuoY/jgiHcdKe+/0t9x2hUShhshAvddKnS7KI1RCx+ilFhA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.9/dotnet-runtime-9.0.9-linux-arm64.tar.gz";
        hash = "sha512-SGjAZGfLXbDHDUA3Yxdl1jn24Pq3gNNjHwSyL/Ov7/iKpbmQBIhtoG9uRDlngZI0xFkV0pKcBm7dhST+JcUdCw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.9/dotnet-runtime-9.0.9-linux-x64.tar.gz";
        hash = "sha512-T69+YViA42gGgeGBCOjxKIB0/UPmrAzRwkS1bov/em6ovaKnHs2EvACRCUq8v3kqnaH6rycf1DEpdzZC4nsl1w==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.9/dotnet-runtime-9.0.9-linux-musl-arm.tar.gz";
        hash = "sha512-1EbSMp9px1XSzzCXqO0mi65mvHMegt0otm5oePqhPV0Ik96QZv+eX+qd0g8Fg25oIgnNXrSjlpv4d3qSXeTnfg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.9/dotnet-runtime-9.0.9-linux-musl-arm64.tar.gz";
        hash = "sha512-kybCaV4zt8GECzPBUJFn52Y5H97uETHL1kuNwSLB/l04y3Dp96bc808yylipYOlTWlLQ3XXyxNMwBQQxE9vJZg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.9/dotnet-runtime-9.0.9-linux-musl-x64.tar.gz";
        hash = "sha512-o30yHsCQ8PlHJkYyCT21xohfkT2gNsvUcSL766vHVMFQqsSYxLce/W9kGW4RFKOXx+OW03Ause0AWA67FQ7Myw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.9/dotnet-runtime-9.0.9-osx-arm64.tar.gz";
        hash = "sha512-wJWKMlJ9/h9B2lctqQ3d7SpTTx5Ore31EpZS0QooFgYOMo1VG2VGeJr2cVlGJxL2lLXEL1Or7izEYZP7Q6IfIw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.9/dotnet-runtime-9.0.9-osx-x64.tar.gz";
        hash = "sha512-YsL2HrbB7d0y6hV3nGBWo/0zy9FP1U2bMAhjCkn5f4lQJs1Oy6g8lhAw39eDyuSA/nw2E0KNKIGlxa9O6n+j/w==";
      };
    };
  };

  sdk_9_0_3xx = buildNetSdk {
    version = "9.0.305";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.305/dotnet-sdk-9.0.305-linux-arm.tar.gz";
        hash = "sha512-dxFj7TY8UaGrImqxQqGw/dCcZ14uCpedAsaBbLVC0Jwm01PvIBIbp6VtI1NN+WsGRcuUoGHXMWpWPjW8PnOwug==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.305/dotnet-sdk-9.0.305-linux-arm64.tar.gz";
        hash = "sha512-u9pgPRChNOT+9FlyA0kZN7tPuu7hkPi23see54KSofUoqELtRLems3tJUXzxnHKFUQeMxrIcCystbYEfyV+cjg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.305/dotnet-sdk-9.0.305-linux-x64.tar.gz";
        hash = "sha512-+RQOFB1zHTfem24eqwslcm8LneJNKIikIAZJiA6eQ2ceuziXokn0MkwhTVbrPn8O8M+lazKFCpwDgRsh5jd7yg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.305/dotnet-sdk-9.0.305-linux-musl-arm.tar.gz";
        hash = "sha512-K9N86Ycyoe1dQQO5Pnz0Jb4RGsXSTxC930GeKFCQ6tZ3QRxTY1EnvmRTG6DFHRja8W0yCv7aigBRfwoukuwrhA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.305/dotnet-sdk-9.0.305-linux-musl-arm64.tar.gz";
        hash = "sha512-7wAN4jGjrsvYTFAEBKD/9d7+9PZRbzifLb5CTKwn3J03xPGFa7p6/Uq3ltw5stkMULdjfzqaomjCRhWD3O8Yqg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.305/dotnet-sdk-9.0.305-linux-musl-x64.tar.gz";
        hash = "sha512-94d42Zee2EQ+EPV1uXpxicxjLhAjtWcQ9fuazQMCZ+GpKsZtM9RAD+4i5eNsitXVm30RAYV+IRcOt/1UA1JOCw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.305/dotnet-sdk-9.0.305-osx-arm64.tar.gz";
        hash = "sha512-V/PWT88Dz9ysTkzg/ItVMlXdU4AHtuBdr39CWihqBE3lT/Z7HMyg6WAeZ+MigQzAWQIe+AWwLeg9WCi3hylBzw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.305/dotnet-sdk-9.0.305-osx-x64.tar.gz";
        hash = "sha512-asCTTDgBzp27WJJ5k0joAtZN7q9hqlaYJgLZ0v3n1mvdhVu9FWaWJhsGXwxq1BQLHSlC17z+8MWjDCO/1f/QYw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.110";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.110/dotnet-sdk-9.0.110-linux-arm.tar.gz";
        hash = "sha512-7MKKzj1ADdYEjkod5P7dCjpPNEgkBI4gk4WZug+Ar6b0thBYQ3vHEQaaWQnu2IoIg7TaGG4KwQSr7AxaNJg9Dw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.110/dotnet-sdk-9.0.110-linux-arm64.tar.gz";
        hash = "sha512-Pia+La8ITGul2TLmqBbhXPyZfw2o7PfyxPyYSqJdXKOEHSvxpLuUirXisonvJ6N6Tz6rhA2WDu9oaDbJ0lV0Yw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.110/dotnet-sdk-9.0.110-linux-x64.tar.gz";
        hash = "sha512-7UOpQly1Qk2W1PTMFlVL6G+nqezUTPEC13x1d50QNrNmNLZv2IX8qTOAAxgYdBsxj5UyKjynHg0Uzr2/6yLkCA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.110/dotnet-sdk-9.0.110-linux-musl-arm.tar.gz";
        hash = "sha512-VGJHpI+OUm/UmGlgTMA6aHdFgobl8C4V49rtf2MdTtd80qztDIstg61nczL068PTvpW85VPO31F3qtZsxKXx9w==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.110/dotnet-sdk-9.0.110-linux-musl-arm64.tar.gz";
        hash = "sha512-StOknkxvDoLRMcH9QuHWZ1kYH1M2qnBUsuUD/B4/YMVpFDadpT/8B4hisOtIjcw/RIVOXp9k0haU2HQ2C+rwkw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.110/dotnet-sdk-9.0.110-linux-musl-x64.tar.gz";
        hash = "sha512-n3rnIENhsiIZekinlrgobNrfWI6XLXhlZk2Ev1UqrUTexok9B4cce8Qx2A7l4zxn6+VBh6VD4/nsiKStGs1/Zg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.110/dotnet-sdk-9.0.110-osx-arm64.tar.gz";
        hash = "sha512-Sc1ZgBa1hO/JRG/W/GEnmeW0YqxB/cmHmaavjHATIaBhmYJ+HlDRJp8ddFbjkysR9gT/O0Lw2anErHwgR0pJkA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.110/dotnet-sdk-9.0.110-osx-x64.tar.gz";
        hash = "sha512-3i/spTBHsFyhcQZ/2h3ONPE2elQ/K7xqBwUXS+aA3U1rxrmcfYzPaL/agi9Jj8ZFm4sMbD0j2tuOMBFRkfR5ug==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_3xx;
}
