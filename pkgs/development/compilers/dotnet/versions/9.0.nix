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
      version = "9.0.3";
      hash = "sha512-E3OzOfnGkPJUNSSgAIKyVov0UTyOjfpp44id+42x6RGg+FISkRrpXJizOUuQW/JMKy5jLrV58P0nU8GNDIWayg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.3";
      hash = "sha512-axhmM35J3aoGr/VPqXxkeR+Xr7CP9uqi78w+lD2GTv0LxkOY/DYuOybClrLMC/GNASWFnv9KJuWx0Hzl7XX8UQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.3";
      hash = "sha512-3zbzuylEut+zfT7K+/rfGs/5uS7Zwmdo8/hB1qjp83S5FRR6XvT6B1qr3wTSe8i56f3GAbuOMARTfHKhk0dktQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.3";
      hash = "sha512-6MfPN+ZYnk81tb12TPEPQQAiDsbHBtaBiKRS7S1cLC6qTrktjWQG4W/T7TBSaL6wndqHzXjeF8cfy/RfT9HCnQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.3";
      hash = "sha512-dFzsw20Gl0SziOiYu10IGn/QSV3eG1uzbzABJ1ONcD2EzP1cp/iFRbB0Ya2lo1cofQJRh7tTqolh/zCfFtxmZw==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.3";
        hash = "sha512-hWQxrHph22NhpeXOKYn86XZ7IY6eih6jmtbWZVwk8GGCT4ATUC3oHMPLAPNY+jrxrQDJ+DqZo0G+c1nVz8AqFg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.3";
        hash = "sha512-OejdEW8b0RWHu2UudmWjlJpMwNW6ywPxin5TMUl/5pKXlhNN7lSvec9a2eCzbIEYRHXj69QNsw59+TVdT4ipSg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.3";
        hash = "sha512-q1jXEhx165CFWk0StURmNsCTqFoPaRmFiyt+8NjR25FXZnAoTrR68oIu7Hyt6o5qI/IHHNgrmxCAWHK9AOaizQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.3";
        hash = "sha512-gymxE4/tDO30aCCcnVJwJMLvV8Xp+aIkSRz745hVnEpLJaqZ5oLukK0fO8nPZtm++v/YNC2LoW5P6Ru9HlYENA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.3";
        hash = "sha512-AF2bDbqA3kgg6rqnb4qLyHXjP9GMP3fihlqK4QW9MahOFURl0A/3mdN/K0b761HYVaDILW8NIef6yCkJtMEW5w==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.3";
        hash = "sha512-8pyqQFpZN0NbjbmkwXwTPvGEh31i4TAQYchTJ2UK85UuY7Sm4j5oXen4Q/OVkY0g8h0hZWT9CACuQ3Jr7NfchQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.3";
        hash = "sha512-EjRtRo4tH/dmuyv8YM0CgvPf5S7Ay3tLNXRxc94jqck+n4/OrGIHBoa/oPGwJuMvPSCxY9zHSWIJn2P7A272qg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.3";
        hash = "sha512-RvGwagxPE4Aoe35Q9uCIonR5WEh2m/Deg8lRwF1ZIYzOwRvJrfQJINWS2/THLjH8Y0aK4/UaIMhPVnQ4gjVB/g==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.3";
        hash = "sha512-tL9b2N19J0mV3XKayoqknO5MnpHy0mbCAicb00zJtNXsvl6Ju5vbJDe6e3Y4wY7WjxsQsbciLqgcVJ/nwkkkRA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.3";
        hash = "sha512-5GVD1+N6Gh+1hgrEANxFMC80rA32BeXduOrPQlHDfnLX8uMvjie/A3LwGHtHKuTKu1jB9gM4UX4kFTrZZAEl+A==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.3";
        hash = "sha512-w/eJ7+woFCgCQbCifjYKZ+mxhv5FfE9hrCv4I8p7jthDCsHc9XxHXs5FQrtXQ/Fpx73TkMutQZE068ojI3ZpOQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.3";
        hash = "sha512-xb/T2/FNBzYlYqZ8Xvq1qexxU6WyVwJsPF3kEPYKEWClWD+xasDN+WogRpmVkkOmPG4Kv3nXm5yU+yJHMWjFcw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.3";
        hash = "sha512-UkTqMJQ0E4LkE5cVf8b7YZV0F5N5BT/JikBoO1upsqOIsDzeLmCuRLvwYjOcGaJZqcKbO1Q9SZRLAYN7rJOXTg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.3";
        hash = "sha512-FIw/8TzRHRerOg0ZUP1299DeAKsusBRkvAXECemxHlquJ4RKYx418sTg9d43MVebOkJPHxLyn3LpFdLqR3hYpw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.3";
        hash = "sha512-QKqWFWPkDEIhwc2HnQ1pqdOWBFWfQsc00UpJfpLGpwFpMsQXtOYa0VCO3LmO5Xm7az9gzIFN27mCgJGmlDYRDw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.3";
        hash = "sha512-4+fnzBJAnb3EAcpAaWD2wIxHyXejdhy5kYA+PoYlvrRJnCAlEy/UQ5rZe+Hkydbw+X9dmCdwKgrbDmGPWEpkTQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.3";
        hash = "sha512-ADttt1LWnAu4tLXaX+TQQhpSqwmmm1xUb0JUG5kHigQ234GmfZVnBxokns9qUYHLn8VQVjWPaaJwqIu1IlfvRA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.3";
        hash = "sha512-ZgxiEEJAlPdAr+b9H48cHpwkgWBCUaxoIoq/27TMpctO+2c1GNlf10N8zsWzRPSP8l3COOP4dhD4ykVNVyP/hg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.3";
        hash = "sha512-N9xe7QguNlCPbkrz+ZuHEJwrZFg5bgeGGSAvbsixA8apVDRnAdGA/5moF0WiLYdQkKUvt4z9Qi6EvkE087J/rQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.3";
        hash = "sha512-YrpE6XlixeuXL4zwLmGAm2oJoGH4SSnV3/XP9TXZcS+dnQXrePeQmfXfpePPoTASDGh8dpuQgDVchbm225CLrw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.3";
        hash = "sha512-9a23B/josuFTpPfdJ2pxcgf0HAfiyOIcOwYWsWfTAAnv/4eDGFUPYEynvmgqRcNVWqrM7VTjLOKcIEEzW3uRtA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.3";
        hash = "sha512-7b3tW4P7JJokRd7o/xOy5oddDMLlaRdH/HRy6tDCe4wAg5kJP4uS+ckcQvCHvJcDEUs6Z2mct4F66EcP3WYPGA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.3";
        hash = "sha512-gaMaIyedjAu1N7KioXJ1Mu7DKPXZSw52tZiW59MNbFL8vgl1kuYsvfgAzfo1CbX/VJaFGIGVtAbsjU96jcbFlg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.3";
        hash = "sha512-fgs41TMsbzZYO+Y8nsBElqdQRX8kKivlky7eLmn64CKcyCK2XwEXo9gCd2V+M76lCQZPbhld7Ve8WGLEJwioDA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.3";
        hash = "sha512-ihEXtbA1PQkMU97w4/FgzffkQhsciQtElkfHC07OnBWdXd24mQ6Lw9zGMO8qnKwhlyEUf+fxWEZ2ETp1qMQ2Og==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.3";
        hash = "sha512-j1zHS7aj+DQwfRbuxEZ6rgU2iC2rJBF5SMQQQczJ0HOOUcD+zXlKQ+H+/Mf756oo6wA4CTvx7uHwqMcjvoKg/Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.3";
        hash = "sha512-/iFwjJ2QtAYbA8tdHZ8+O58qBS++vf4oRFfvXAR0BpsnEG8vOKqb5LJzgVEO49unCHDTvjXB8wI6ZPICOC2+vQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.3";
        hash = "sha512-PDZm7kf+Eoz1CuhuwnsmBNL/KWjNNb1bRHGgdc8BMlRwyK1vmWkn5QY9lie61rWeXTO5C0VYt1MpRo0qZveUMg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.3";
        hash = "sha512-+P1T1dt6lqgyuBJolWBpwPeJ2FDFcEiHAIcHoEjd3Ivzp14fMm3k9gdI+oQqtT7f9EZI8nXrEhoO1WPJNAxfWg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.3";
        hash = "sha512-yjF4CUHrK/P1RoUnbBCm8GuNouO3V6X/fz7R8hKjyTcaOksr06tqWeBdU+FZo3Z9yeu/g/PrVNnMe7/WBPLstw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.3";
        hash = "sha512-c8tP+xT6eUb4J1nzr1pPrIBWqSp7Boapi5ogx5TW0dyPCqPcEgfCf6U/dMnfFB7KkXuEuKpria6sqx74KlKTuw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.3";
        hash = "sha512-se/tJetx17Vs1rH1UQxfDA/mfMcAbiBrLhRp4p/6O77Kv+GFmcldJ9BJqOt7j/cAec3LEQm6mBdjdJJ5d4ggSg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.3";
        hash = "sha512-Ey/O923PsDqLoOfwzh4I8fD4Uodmuc6cY7cWqd+fII+4Fxg9xncR/zeqXTJnYzvcGP0wjJIaObxMJYQr+NqLOw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.3";
        hash = "sha512-3L9jWMQDTdm2XwhQdUYCwI3UHZOgEaz6GxCm7N+1aJ4VzJtUJrAk1AJYDcQ1Es5SBzn9azHaD5Jvr7sgs3Vfog==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.3";
        hash = "sha512-y8fpDWmKabnPsYhtOl7DEdqx+nxOHRc6OaRHdj/MXx1uvJj0IlbWfAGAPzKkxk5dJl8Ml5SAF6nVDKr2E8AICg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.3";
        hash = "sha512-iwzSMJgMTUSir80c4f4cvvbQqL67pbqmqjfI2Y43++22AOGlFFK4yzT4ZlUUSu+b2CNwKUu0l0QFyVJBAr30tw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.3";
        hash = "sha512-0JZueJahMDZ7GMHpv2fWEyTBTJKpNwyurEIljopDrszGz0prc73DbvEPRhfks5Ts95OraLDARA7aOVBzKWIlTA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.3";
        hash = "sha512-00TnMIRZ/h6v6HVdNm9JdSsvQpJLWwlSGF9HDSV6S6GlpV/8Wq1VO40tmdvkqmyVyulslh57Z8OIWKt79TCr6g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.3";
        hash = "sha512-V8iYp94QcK7OddGI3JcNO2a1bGpDQMjj+o7ggc7j01T5g6Ld/BYkuy8A980GHhR5D07k4AnRyx2T/iv7WXQimw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.3";
        hash = "sha512-8dhnW0JOG2f2TeaVwsGOtaI3L0DPn1eOJeNbK80q8U2PtBXhO7V1FvDpc0tCfkah2A5vq54yU9dJrfz+TshZsA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.3";
        hash = "sha512-ix+dWoJN0G0UZaEMCLN2cKAJxSXkyBvUSKOBfdxxdGZW1sv4KSGcP+nDv3NCAI0TBXoR6lyCvqtTJqFFngFIkg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.3";
        hash = "sha512-4Nx7jIfPLqqQUwBH8NPZV2iSh1bfwxWphJDkftnkdp6F6q2pg6CqUDtv81PDlUsXzzJN7xjqlRqs2bUJkCcmMQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.3";
        hash = "sha512-CEJfXQRzekYKHXs4myO8c4u3GeLate8V78VGfrh1wuP6nrgfHZG0QDbmCwC4WXSxSLsOAzTo48Iy3ML2j0KCYg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.3";
        hash = "sha512-kERcZwI1UGHWdU/ms25Hu6fMOtyYCMOq8LtCGSFr48mGeqfUC7ecZ3i13rR2ZHjhc2pfaGzYIL8ktTdnYOttkg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.3";
        hash = "sha512-LjlALRLaNMxpPyd+bPILZPjhYWxey8Ix6f1kJ539TKKSDaBXfcSD1yB3ZUb01uSIfG2zeuhv/RE7y354PD/GvQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.3";
        hash = "sha512-CCODAplWwLQyn7fIEU3h6GVylLWakSGeDgcTi20d1nYLuSqyFqS0HjvrQmVqLu8X+5QuJucNDdnf9DZB3+CQUA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.3";
        hash = "sha512-1TEYraq+NIt40JGsxj7vc3YzgySqGs7PphTHtsZChyg61KakjWmqYFjK/6lBiIF0ZdSyk+OdBboY+gJHdwH8NA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.3";
        hash = "sha512-XWpS9ssLxRPR3/RSdNZ4+4JxeqytccTbHBx2Zk3Fge+PIyYp/13p1Tw7hDG2jYK14wX2U8CMLo6jW9FqX4pOvA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.3";
        hash = "sha512-FbIr84v2QAo/TPu71tdK+0RvI0WGXfElw+LJ2DSDjNLH2mattwOHw1XIWnbiXSbD2U5e9B0GPWFyjJbwMz2bYg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.3";
        hash = "sha512-Rp+KNMyyOl3hFtTjycRcwGS57qC5fw6af0uFRQRwblF6zy4r/Fl0B2UjLq3K/IV60PqVUjuJAHmntfOCJBkFdg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.3";
        hash = "sha512-mLBibW4OgxV384kWAMVTcDSGlSKl7kLxQwqduf5idsxuvdFgbUbuI9Eg4RzlCpmB7VumPR2EDIBG5tTjLXtnOg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.3";
        hash = "sha512-1bZv0kIUBxlvMkyEw9GhGbVepuJuRKtMUrNjpsyszkb8ZrTbO/Q90jwRAS0v3VKAcLn2hlsOk8npt4yT4rC7fg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.3";
        hash = "sha512-djCk7T/QQf7KIQe5mwQq8hheU0HpW9RmJbjIOc7zBWbjVx7srUcXyRZumq2aR5Vxc19RK3kYkwLYuR1LXOwNKA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.3";
        hash = "sha512-IMXYYRZSd+ffRf0HbW8C9NMm7ect81J75KfWzQyh7jGPuf1HgIQT1LiSMupFnjr0dC9AvLHKR21twq5XUC/PGA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.3";
        hash = "sha512-8G6GTIn5RuPlQsdxXGZ8mPykyXy/DKRpZIHEwBSTSE9By6P7PaKjHS87LEbIL/y+p3HD6jupiw7rtXYdygu/gA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.3";
        hash = "sha512-W2gEOuabIfQN/1MnwANGMC11Q/pyprR650yE7rIO9pag00au72CsCue7mOmFQINP3wa4izko0kDgTnZRJp0Srw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.3";
        hash = "sha512-cdvv+v3Dy80qVpc3ZQRRZDQph4jg9+9UG1edm6eFmY3hmGaZH3UYPLSI8MVfKyu66amhCswZso+R4+DC20GiFQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.3";
        hash = "sha512-0JaJ2zI7djauo5KM3BVGY2NCRC22T2KieI49CW2PdM8dsOXB8S5z/RGeqmZM9z0nE+gePDDMpqM+6ZlUP5Lwmw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.3";
        hash = "sha512-RuVssBRwSNdejDmCOP9G/3ZX6hrXb1llzqlTyh9S5atOViWb32LBm/MeDUfVXCP3/KozvMW9bN+akyilG7vIbg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.3";
        hash = "sha512-RtOnNqA1moJVpe1Rg3ql1rGXQxlVWkqfBBA4TFE7LkzFWqWkaBsiMPEVir1WyWDnXNDlFE3wjRGcZ7m5OeHcHA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.3";
        hash = "sha512-eJprsqC/wK0ss8dzUUzoyt8+lCXaAaMLUHwLsGLP2hk3HRTHwBqt/XbjmlXTx9elcKNcFmPd6JJIyEYvxS4hZQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.3";
        hash = "sha512-k3BTKg8G6MRq+VSM+oFN6P8h8Yistf+DOmVEdGtxopIq/lvEgCp9c0FBA/dKkBmLFCSRvZcPSrPY43saVB21hA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.3";
        hash = "sha512-gaUR48gxtKwzKk1itLIuCm8Px6XCNcolqj+/Apw4ORtZAmY89vGHxI2wV1+51Ngi+0nfx1SCK681tzUyPMK+sA==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.3";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.3";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ce50fb55-0885-4427-8636-74a4be7a62b0/88b3a34f6713ba012258bc43c8f6fb2b/aspnetcore-runtime-9.0.3-linux-arm.tar.gz";
        hash = "sha512-KnUI3peV2COKHU/35034GVOMpH1v+GY92ye191FNz0h+fu0i2MhCWMrT+zAGZiGmx54I87Bg8V1k6FFFs3au8A==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3ad17a72-66ec-41fc-b771-8094284b066d/ebf2d0da156c97776e9d27ad699d96ff/aspnetcore-runtime-9.0.3-linux-arm64.tar.gz";
        hash = "sha512-igJweLRrbrs/S+2is/PPeWBwG3G58rZwTBfydSJ5x2R1XK39MPPi8+OrJoaeUKNcVnwvvUH9mNd64vb+zeGLUA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/30d54f5c-f3c6-4ee3-bdef-75e7cb0a40c2/cdb0ba537467777ff193f8f3cae6fc76/aspnetcore-runtime-9.0.3-linux-x64.tar.gz";
        hash = "sha512-OKO3OmxB7m9n6RCOv2hOwIL8bfqpQeoiX26yAKHjSQnAX6R6CHw1wY6rYHNQeW7NFsCfLjd026WQCDyTdC45ow==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2ed3b832-349f-4c3a-93c4-b78c10419da1/ed7d2f3d5deb8bf9501c9d62bd0481f2/aspnetcore-runtime-9.0.3-linux-musl-arm.tar.gz";
        hash = "sha512-QWvwcsgXq8oHo+xeNSfYuvAfeYwgipCRWZpNGCbz6a228LQLu+xZdUjgcVKDzBZvXp/2GDZCbC3lxya0X1/Ivg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/41ba2cc4-4df1-4386-a17c-4741e1f28b8c/7a52866c6cc1a00cfb4d2f09f7d80346/aspnetcore-runtime-9.0.3-linux-musl-arm64.tar.gz";
        hash = "sha512-YyL8GnM6VB+U4T25HNJ9l29Vc0aJ1Aw/37sQoFeldffgKzKx1Kt8h5zVmTgP3dfgoX1/CtDrNw2xQvTzx+tb3A==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/53087890-9ecf-4a5b-ab19-30f6d4e68472/d992febf2434ee68f9e63e0c599130ee/aspnetcore-runtime-9.0.3-linux-musl-x64.tar.gz";
        hash = "sha512-E1hakZNQuiJX8AqQrC3gMGselS67oMf5A51+yNoTVUsuPIat0B24PeTmRwCbijrGbDpoYp53AbRjcDt524bkrA==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/9209345f-0826-47ed-8761-de661e135630/f600961b518bbd8f70d6210332fca2ea/aspnetcore-runtime-9.0.3-osx-arm64.tar.gz";
        hash = "sha512-D5GnMRggce1RF1XoUh2C3A4Mm9G6rucF4W3bLyNei2MupwdGW4F6JAeZ5f18UktQ46H2q9fZpe3O6QJeRz9BhA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c2e9f12c-01e1-450d-b1b4-e5d09de3d94e/01baa500c4071fb47d864d7f772047b1/aspnetcore-runtime-9.0.3-osx-x64.tar.gz";
        hash = "sha512-MqrK8+vUGZA2L/WhI2v4PHqeQxyIFppryyp+kyIni37mE/VlqIMHfFND0hfqascVvsH2luHJ6BGdxNpmSRn9+A==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.3";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6a2bc9fa-ffb0-4113-993e-902e2049ffc9/fb2589c89729fabade52bc737605ed93/dotnet-runtime-9.0.3-linux-arm.tar.gz";
        hash = "sha512-IrNdykDbqKa8ZmPGPASj5u31nwSx2zv3kqHmS1c8OJb2XjIs2+jBUiAJwugdlP4O+Fq0NuKWHoH018whI7oz4w==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/79e65a77-46e2-47b5-9bf4-efa8a6426308/211a9c0c2952d0bbdb0aa5eb1348e2b6/dotnet-runtime-9.0.3-linux-arm64.tar.gz";
        hash = "sha512-CxiFmADHXSk7BbWJOLfD69mnql1bFjyNWgiqhPlQF9LQEU3W86aIvOmXTEPb0HOpMJd7fM/gZXcgemfwAxnSDA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a58fcc04-99ee-4dea-aa5d-d6d22c4040dc/4433f4e97ad4658bd76f52acc1cb9c21/dotnet-runtime-9.0.3-linux-x64.tar.gz";
        hash = "sha512-SxalfpRZL7lxJCHtkMAl/DtPkDn66je0MrbYo+jK8ZLerXMvuEu9yp36TtQN20YHjdPCcQgBySrujiHAhL/WZA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e7fd172a-a601-45c2-a715-14cd18c2cddb/93a3a7689181ae8847bf940d20e56148/dotnet-runtime-9.0.3-linux-musl-arm.tar.gz";
        hash = "sha512-vYB8mUsCqgyX4AFJLBYUaJT2qh/e8S0Jef+wyE2AnN+VX9NRAWu1nVCY7JRfw8znlYpv7c0OMB7ygVlwDjgCeA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4b7b3320-dc33-4da2-93cf-de158ad5a41f/9ea1944f72dca2106dcf1477e0b7e2da/dotnet-runtime-9.0.3-linux-musl-arm64.tar.gz";
        hash = "sha512-I4URQWnjKymzoTsnWkQa8e27TBTr7VL/j0XxGsilce+imEvi75HjjmcAOMjinbjFhf8S0eBVAvQSDk3QXpi3LA==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/cbcb4e59-932b-4edd-9a0d-228e1c0753d8/5b2d904fdfe7381c3f6e857c409fd78d/dotnet-runtime-9.0.3-linux-musl-x64.tar.gz";
        hash = "sha512-hTOgYfT61hE1JprnmH2b3IAAy8SZngA5Lw6dI01A4gpPTnU91XJDc3cjSaiW8qhOO6huh22Bqb8GiIjkIa+xPw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/041326f6-a1c8-4af5-8178-df0248ede629/a4a0f730a9ea09b73c30e44b3efd54eb/dotnet-runtime-9.0.3-osx-arm64.tar.gz";
        hash = "sha512-toCPaXBLItVrivSv1GlZl+IPoTyeARbSi12PMCLZwDnDr3WRDSUyhzuDMVJpl9UP/RtWQtNvHj7dZIXtwV2ACQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b4b321f3-ee2b-46e5-96eb-8c809a901ecb/252a64bf8c5b5b196764c5b301357249/dotnet-runtime-9.0.3-osx-x64.tar.gz";
        hash = "sha512-9gaI88dH0OdcPywkuQIbFH16pKtLWqk5uGHVWEpZC/mx1uiFd70I6ewjQ3/KopXaYz7wQGWRy10UrGZZ+HJhZA==";
      };
    };
  };

  sdk_9_0_2xx = buildNetSdk {
    version = "9.0.201";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a2cf96fc-f298-41e2-9dc6-8c0861916597/d505f4b28a7765d7bea6d2883a7fe170/dotnet-sdk-9.0.201-linux-arm.tar.gz";
        hash = "sha512-aBIYY1ghrUlYayCg7rA9Ap0V8s8seVB0vT4np3P5CheotrrJ30TggyM87PNiu/7n0Ma4OiSRfmlr3orX5S8RVQ==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6d91bd91-9bb6-4b3f-9256-83f8c982e817/9248655502cac509f9c738509913770c/dotnet-sdk-9.0.201-linux-arm64.tar.gz";
        hash = "sha512-TreMdgg1XKJ4CZCTRZLElXntWfCYM3fEwsmaQJGXAmRkK4/uksZekbrrbGvCIGbWlYCF6s0ahQBVtS9tBENtWw==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/82a7fc96-b53b-4af4-ac3a-ef0a6c9325d5/84e522c31482538cddf696d03c5b20af/dotnet-sdk-9.0.201-linux-x64.tar.gz";
        hash = "sha512-k6gITvONqBDDyWUEwg6iAgprdVtzoZ96zGzXOotirOCt2hRFLRHmRY9z3H1Y/60i/NFR8RHSMgyyOhD9VNy3cg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/905c96fd-1e89-4024-834f-dd2690ec6eab/6b3cec8a13b42bf55f65f65badf0b89f/dotnet-sdk-9.0.201-linux-musl-arm.tar.gz";
        hash = "sha512-ONvoFPTs1SgfeCEFlmHuAmX7IZzeCF+s/M1Z6fs0DAOBhEkGTf6kYi3gwMbjkMoZeVFb3ne/MMvnquYUwc1PKw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/26b8a5c2-b79c-425f-8356-d8f0d231bf45/0da5d6f19a28a5d07ebda7fe5a1ec536/dotnet-sdk-9.0.201-linux-musl-arm64.tar.gz";
        hash = "sha512-DKnTE6zKGUcW/62/ck4yV3AEKOkrW9CSBV2d9jHNOiZ/PFe6dV115B+3sCeEgyG7Crbf7gN04OReVJkLNLxnqA==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/1de65d68-6aaf-46dc-b103-5461e03b8d81/160ce3ce92da0cc3eaf465279b6b61f1/dotnet-sdk-9.0.201-linux-musl-x64.tar.gz";
        hash = "sha512-dW/ohdWRYEDHeZXO7QLoUqk+7pRIn7JSHZYT2oCxoGbAVTUmxbPWwkvNAxwQ6YSK2A0nt1lF5GmZCeat/Tm6yw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2dfd9746-db33-464f-93f7-6101f0f85968/6d20c7591ed80ad5c8b8039860b4626d/dotnet-sdk-9.0.201-osx-arm64.tar.gz";
        hash = "sha512-Il3C3Gfx/EHAUgnkmjFWUbIBlv8Ch/le4IPkyTLJDu17ePaCh6iJpB+z7RH0jQt19ihf0OgWEvmEtZz6c9Cnww==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/abc40bfa-5976-482c-9143-e8ac8ed267dd/8ec0035953d18fcb07aa3bb033ca35a2/dotnet-sdk-9.0.201-osx-x64.tar.gz";
        hash = "sha512-azGDM5p7T81pdXMfDEB5p/oaYYvPejNYOqNe2NvtXYQeXxfOEYQWwh/qcrq/q9D8LMBCZvNq+dbHvIxVIMtagQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.104";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/aa05fba2-27d4-464d-b95c-49839de3bd90/6dc2b2e5628a115458c6d0c2cff4299a/dotnet-sdk-9.0.104-linux-arm.tar.gz";
        hash = "sha512-nU1KaalG+2Hp06CzpXXPnrh/QZR3qQrLAC3tXGo0xut0bRQQNJPjMPCkP72C+keVkbZKsTvB+SxhnXNdCGLjKg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a8072dab-fea1-424f-a90b-12c64f6dd881/1e800a277f917b5ccef8d3476ece7bf3/dotnet-sdk-9.0.104-linux-arm64.tar.gz";
        hash = "sha512-vKVVZupf10qeD3V8ri9XKCPEUEafRWdWBCmHsn6dFfvlnhmTdCUyqC/fx/sh8mpj50tMgO0X5SsS8HOLRh1w4w==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/33664896-3281-443d-a030-394719c926c9/f0f8964a84b092b7f7277ce9a6d99d9d/dotnet-sdk-9.0.104-linux-x64.tar.gz";
        hash = "sha512-mbaxvNRtPNWYlhOQVL/WwVkJt66te7LxnT6Xu/h6Ql21vORQbV93v29/Ekmwysr6Z5ybycOx5PKrLnnLXQsseQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3f9a99e2-ef1e-4b82-9f31-4bdb4d9066e5/fd05e0620afcc053b79c51e770ed01e9/dotnet-sdk-9.0.104-linux-musl-arm.tar.gz";
        hash = "sha512-UCIu3nGuUPrElwskV94t2Q7D5il8KcVXbvHhfVI+bcsE1goTg/hr7SiNAgZygnPfbcD93eWVz8+DJlHMo2Gcxw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/7b3014ae-980c-4756-a2db-4e1cf8a5aad0/43e168ffdf16a261bbd44926958996ff/dotnet-sdk-9.0.104-linux-musl-arm64.tar.gz";
        hash = "sha512-aKXiCpBt7dWOEoyQEWzm9B/Ls9Zzc5ejBJ64H/aozMEyMm3RR0gChFNe4XpUW+Xke0Hf20gvUMFedvW4TzG5/Q==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4c76ef5d-d592-407d-8551-925a7479bdfe/44d4204797f4a435a00dcc63e4920f1f/dotnet-sdk-9.0.104-linux-musl-x64.tar.gz";
        hash = "sha512-6I0FTAuRIJ9B0AkSnRhsMYgGbuC/xf8FacZIlgLTdeY7UhQr63Vvfwnt75xg+nDV3m0Fz3sygDiP2D2T6CzKdg==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4db0c5f9-9a8e-4878-8711-4687108f9157/ab18273765fec69310b3c0efb6b72eeb/dotnet-sdk-9.0.104-osx-arm64.tar.gz";
        hash = "sha512-IUW3BRSRhkRJSKadEKlUUcV5/3MUx4R3VV4G92WaeSFyYw20oW/SdAH3IPXplOCCvtI/Q37+88cZjxyD5cYddw==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/fe6987a1-394f-4f04-b9bf-52a9ff020ca2/de9b3377974b7e24a910d1a4184a609a/dotnet-sdk-9.0.104-osx-x64.tar.gz";
        hash = "sha512-JbZGUkQLjGAKOH8Sbcu6W8ZkbduQajwnY4sJJkqj/2aHSc/G46HlMHDJcojKcaWMfpHx0QpPD0FpotBOX4aksQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_2xx;
}
