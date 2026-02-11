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
      version = "9.0.13";
      hash = "sha512-KoQ64Zl4jI04u/unrSjrHrf3Ir7m5ZqDLiYNkRKPxm9MX/9mSbafkgct5+wLz62JE2HgS0xIYr4Gyui4jT8uxQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.13";
      hash = "sha512-wiyoFUO2Mfz8sHb/7fF5Pe24tiQ5BTdlMIWM66Y1Nq1uoDPXauvnBsfTJqCuAoWWZn+6uCqcq6Mo3AeSYTOvpQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.13";
      hash = "sha512-//+ucp/p5+AMXXr0+FSEzYXuPJikRtsMET1Z4NXlKiv6Ia+jhf+OViXocGza68B1dUgbhW7nOQiIpRz81LCBzg==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.13";
      hash = "sha512-oLCpHvldGnBBIrCBKjum5XBVgGDVPkO0kYMgnxkiv0aooNyQoIFWGcwvXLc/a2Stx7fwxZJP8ityb2tqQTmjKw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.13";
      hash = "sha512-TlEaydoNIC772kbfT8uIr5fsdq/KtgPa9MGtP0vruWpnfsA/q8RcuwtbFpTs+q18rRKl2Acamsux3OdsgUPjXg==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.13";
        hash = "sha512-PhgkUeCy9ij6y9erkvdcnwTAYXB9/zIstPPIzMNIeTJndki1YRhDp4D58ZDUs0wVHoaCUwC5LwsZ3gspPmc5ZA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.13";
        hash = "sha512-1fram1Uk51tUU9rV5OldC7b3WTXgt4BCcFbW0ELgwNqt/OfjrTFmaHOacaPsX7JrD3uNgGnHu0zouQiVECAgVQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.13";
        hash = "sha512-SCFCHf/iS3/rPttPHnIdCm4xvAxpEPFiYJlWeNSLci7ppKK5/itQZj0hDNW6iR730TpqrGuUhEpi0O0xkDXCgA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.13";
        hash = "sha512-iYzYRMhvm2h73zt/zm3c+xLEWhkE9P4Cu0ZXz5k9i5/U9kOJKrOLEwG5jJTD6VzSI3d3tLgynY15cWSBai1mcQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.13";
        hash = "sha512-ISuqOfRvQ2TjC96kNmGglT7weQfUnbMGPYkogFSMynUYmPY6j/n+tKltFkNemiZm/FEm1Qy4XLhL1ctQig1kag==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.13";
        hash = "sha512-Wpz0TtIjjzmNQ1OEDbHva4M3KKxpHqdn1s5slkWemK9IAuknRLq6nD79xVSHGTmSIiO94zopNIequr9JSv73Lg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.13";
        hash = "sha512-ZfJNZ+qgpq5znId8jw8GqqlFdgA+ue4elkv2dzWAFqIn77HYq3lspnM1tZokvfoflpY2UqwJd2itts/HgRSxFA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.13";
        hash = "sha512-b2rjmbet1kVdf0yXhZ7/UenTdCU8+txpRhKpH5V848Ai+ZiGof/cKhj59Zic4qCLi30CF7PxR5kBlltfUZ4XEw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.13";
        hash = "sha512-98hF/vy59mvyBEXEG/Xt7W8fDjfErafCJ1OitjIhF2/baa9+wVP4B83TLIbi4qjJ6zR/rdeKhEATCk0XdnOTzQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.13";
        hash = "sha512-Z1boG6zrffCw1CwjHXu2JYMbnquRf3IYb9ExO2BW1k6uGdb/MwV9KpbCNBXyRrCEKOz8XZWvEtxbb4lwBSbFQA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.13";
        hash = "sha512-B718yH/yg8/z5dtkzTNGTQiAZidaSM1/SLKHUra51GGuHwmwM5cojorp40jTr2sZCHtC7hDhlchiHssnt4IhVw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.13";
        hash = "sha512-3FXK4lhMqAGAg6cpQaErizP2CWN6fQQe9lGT1OaD/F16cntB615RXsoJfXqHE1480D/qVsayqYHKKD3XJbI0ug==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.13";
        hash = "sha512-G5p9a3LrwPcQXVD+E8+eH2bLCH7IOWp+R95uAR/u3HeljYLpJqxHu9VN8eCa6MIsoIbjVHhIAqn9uecHX6ieyw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.13";
        hash = "sha512-G7deyfJpygvjlmI3uelBe1hm/0rMhOzXfXqU7VWd0eaOSqxpXXL0coxHDVS9YW/Jcd5M9ldBshA8apzZbXLUCA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.13";
        hash = "sha512-jvZjhXr5aqy/ZWAVJaVWydpCeK7tm62aSa5qbX9DcD++10XcVB7K1O5OSiI+Uo2ns6wAp0MlZcJ5XtF8n2ITnw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.13";
        hash = "sha512-m3Qoxr/Ok4WjQWiVEm8mvLn5rGfoOUllKhmt2NY0itJ7FZ1TrnDFdFEiTv2QCOghLXuEQQG4d8mKHLA+QVblXw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.13";
        hash = "sha512-rbBG8Zhn+46Pw4+grfx3EJTl0Ullxj94rxOexkAiwi9djerl9t4eusY+p7ry+nYQflVaz6Vnp6PDg456U9UdNQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.13";
        hash = "sha512-rscwNYpVf48utaVNiB5P5slc6ouybxOOYsCQfz16XsNMKh1xxz19bPElWmjX2Jo58JNhpquKGXkl26erwXsCRg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.13";
        hash = "sha512-qCPxHYiaw7NrKQUMdWtB996pLC72wnyMAH8Ft+gK6MQWTrP9EMiQQfiO1JVf7FtfwYzYpnJz+8OE9mGa/VbwAw==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.13";
        hash = "sha512-FliT1UFV9fr/CInMJ1zOX8Dg6v1KGyfnwwpj3+gItsvJNYTo7HJSVJNPdl8Q6JkuIuhsNedlElCsMspLazxF3w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.13";
        hash = "sha512-jkh9wn9AxuEh03HaFuy5NWZlq4wuvXoTUHdKpoMuTDWFug0708tXz2SUAxLRzW1nrnVejcv/zCmrwSmNCq5r+g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.13";
        hash = "sha512-0/e0/OFC2o8JQwdXVNzHT73UqMP+O49q0TMwV2pjY1i9Xh+gd+6VsQPwgR1Ekf076ar6ddE9ibtxr7AkUcCUmA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.13";
        hash = "sha512-msUKk6VpzUxBfl1QI6LyLMnbl3wUfIW0iiaqA8ppeiXJNkB05+qBhu6L6wplOv76jK1TQ6YiJXRw7ru7lNUSsw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.13";
        hash = "sha512-vOb3BmNRgIhCF07wR6biveMmsYE07fmlwKBVczM7xVOgx9hWNIUSU6tpwbkL4LvU+H302nYWtoZBI3tfIuooYw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.13";
        hash = "sha512-R5CFe5ZT9VC52BYm1aXZmxdJjtYmpWIwj0/823xnjXilhBbeb/t2SDHT2xFyNBbDEcj4N5ckAsRR0kYICo6iYw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.13";
        hash = "sha512-6j2t3Xw4efoqX4ASqPV0UTLzdCFi1UrGe1k89rODaMNugGKzH0pWrWVgQjVVAxnkeXfTLRQZTJ2S+XlvF0txRw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.13";
        hash = "sha512-BgkdfJpXvcZP8fJ0jd6oO1FLWZfJGp54vwQ5GbJ0n4iHsq/h3zSBY0mEes1gb5fYbwFfS57qAcFhfnEyKRIEhw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.13";
        hash = "sha512-5Aef4qW1w/l2yVd+l9LMXn/hxGuAmwq/yBUgurI73ecHruIjbJTe1QTWHB/D4yjEPYozmtD1PU+CwOWxon9wiQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.13";
        hash = "sha512-crJvcd6tDCXH1QsKAVrrGEf9SWu/uW+QhT3l9nzC0nc6qWhcPDzhTMtfpYVrgyx+TTlJJ8EK8vu+9EiDolF1VQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.13";
        hash = "sha512-6s1yaDaQ2g+AhOSyxjl0q/XKgIzHpRRwwxRBoYkWhNILt+HOQDntx6KUEw0eKOvgEk9kcm0TUmjd7JtPCKVDvw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.13";
        hash = "sha512-fHEI0u4PHGwQuLiO/zYa4vyeFfAPT7FT8TG/EhhsD5tTPx92dZJyGJUgWfpqonSpbmIg4RqmKO7fnU9djG82Nw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.13";
        hash = "sha512-/iG/y2MfKYnquQlIHCaJRNwQXKTJmsF3vi6ZOkx/FSHCvobqFKKy7ekq7OxzG+TWFJc82AN9w7T9UNk3bMrh/Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.13";
        hash = "sha512-IpuFMSEVerqKtjWhUJgVbchKds6uJ5i6dcZybgzzuLgSbwUB6DrzP8qDJSzhvHX9ME26jIovqtVFmcPkUwt1ZQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.13";
        hash = "sha512-hoqLnw6F9nxKbfVObNXdWA9U3eebqMngUk4LatJbbn4a3Wg9nIRecK3UwttJ4Pe8LmcC+m/Kjg5eHviS6S/J5w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.13";
        hash = "sha512-78P9NkXOyR1Jifec6vOdOosJ79GvQenUDMfiaj2t1J00DVKyybYsdkHJ/cz9F2b4CFb70juKv1rIW9rXoOMe7w==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.13";
        hash = "sha512-P8S7Uc4u7/uHX7oiPxD8Joyz2vIyQ5xyoOQBsB5CmOMfGWj3lcnlo0GHQnlUkABCVX/CMo4IhrlBsDhPtbycwA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.13";
        hash = "sha512-AHfButS0DsJd1q13JbUhVsmCfn4LpBr4i8UH3sEzJFcMol32ZzlGLm/WgLiDLPqGbGDPjpoV0yKCZP7RaVwHEA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.13";
        hash = "sha512-f6R/AxZyyGKaRxkMCiOgyLs1nrvleLWZLDw6kjDO4r5KRJHgVXgegRn2MFlRRvOG6Cupf5ZE+8bjcNG3HhV7RA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.13";
        hash = "sha512-yLxv7G+K0HzJdIvKquXnevUr/gdfp+624r78HYaTS11KQBITHMdQ2NjkShAPZPlT7hIISoC30MtROp/Ruv3jDQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.13";
        hash = "sha512-+eE0xAn3Y7obgtzD3akhE7UL63OtQi5ZGXeJ/z36hEYe5GEEXjOLY/YbCWbrH/P1DBPSS49lhIN0D704hkZBuQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.13";
        hash = "sha512-FlFol2XiVeKVkSn7mHxHjBKZLBO1HBlMOoFW2HKON52ic/O2NCxKHRPz2dO3v2aCiNFD5JBBXjA4SnJWD847+w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.13";
        hash = "sha512-Ugaub2wSr47mp3tZQFtn739L7w7Vs+eIE/2Ofv/IrM3V7sU01xGPNNzXWWlAAn9McuhGGgDMhrj8xb/CUjspvg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.13";
        hash = "sha512-9vOvPefnXCm3z6culAQw6xDSnQB01t7FqkFeetE1vX4wlDV9UwjCdRnMvAG7nGvBDHD3/oEZjVq4+p3Fy2lKGg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.13";
        hash = "sha512-1hGfz+sNivAvDrXswyXr2tNZgito7ocFECVD71tiLbzTpxazauC3v1XRcYrm5DZnoREYSYbhTXzbZ+uZYv5sjA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.13";
        hash = "sha512-FSSAE3DQ6e7ujwjDdVhVxdjfjp05c5bJSpt49OH22sENuAd/4zhE4BjQfwFOSPlKU4+Yo4zFvpx6N2GJQJaacQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.13";
        hash = "sha512-wEssgU0NdcOmp0R2pzduOSr2fndQ+44DIEKn1R21dq0/xC0vtyKs2rKrFOlPgP+jYGQZxgaMxP5jzVC0adnvvA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.13";
        hash = "sha512-M+OWgcmimzUCrp5jAq33ZihhvIxrn6kvbzZTcbXsTIB7xQucHvbOG+EJFbEajMn96Xymc5rggREqsfeSeiJnKA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.13";
        hash = "sha512-URGkEq0PV1FoaPj8kllIy/I6Oy1a4+KgtKqufQODp0gXjm3StPSCk+7XNO7+W+2ZUn4mtEVFmL069zfDma+Cwg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.13";
        hash = "sha512-NDVVce9SqukRnhAloEQLWxkqxAAg79FHgk2WYaZpjsD8F3SszNZOkaNmGA0LCUVHgm4MgJuxSxk/J12qB/QBkA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.13";
        hash = "sha512-8fpH37UHmWGfwpIV9gtvVSt2ev1ahJFn1VixL7m7fSOB9H8Zy4pK4qc3tM0AmGplDrL66nXYHbKmLwvad48D6w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.13";
        hash = "sha512-Mww9/j4sJPI1Urau5LrxMQxDEpC3h+S0Yd/AqEoCScpSqA45OtnAWe9aYCaEDNguWTpk92XYCHyrIbuJWsuNrg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.13";
        hash = "sha512-WzGAFxqT9rVpGQkgcvVWzjuSZ8JxGO9BXxbc8HIbjXCbsqbWbf906EtWpC4VOqTJr12aCWiM01BYfch+xWsVlA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.13";
        hash = "sha512-DEgSNz0g7PW9SQ790ByycQijhWqxg+hks+hFXDEKB+VZ+ri9LwuPiQBLz+GTgyJdIaA5pf4PArg9NyEU4499yg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.13";
        hash = "sha512-X5pfG4tMr0IYcd5lLBs5c/bGPwXmPlrmkvHf0MlYN2Tz6E18EJ/Y9+fwM2FBX+8LBjICiV/sMf/kraPkYDWBgw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.13";
        hash = "sha512-woYvJTXBYSguz0iWDHGaRO6Vb218Mk4V5W6CXO/l7hwNatu2ZwHpq829pEjFb5pUy889ywDCi3RJlXEFiwJQtA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.13";
        hash = "sha512-0N8uakngsjtxtAIS2w/EXKP9yX3V9d1suCvnZpAAkcSx/FmmTk+laAuVDysaixYqlzJjsW5oykg6orgCA2rJWg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.13";
        hash = "sha512-dKGNrGIw66xQG6l1SSd8yRM1n8yDUbvMHa/Si97P788vVr8IJ630YP5J3p/O7MqkOS0rqvM4PSRAYTtVRLhmJg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.13";
        hash = "sha512-UTa8PfynMI1ueXFeTrbLNKcgXHxlM4trtyrrZjfljANy8RfG4YBHLQzl7/m5JHqVKDKIdaO9g8qI6B50Aev0Mg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.13";
        hash = "sha512-9I+7dg3RDZtlaV44/TFlyhs0mvKhIU/XcVIa0Z1IS9YwgecVMEZAtca+V2sK2l4dc2IOuvZt5iSLBIysmDCp8Q==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.13";
        hash = "sha512-8mKiRPhNnvQuy2oZUMpuORM0tv4usrryR7ZvO8PnDVWpV6zJOdNaw1RIcosonW1hZbFagaIm4pXObaIwTOqrSA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.13";
        hash = "sha512-a96AFOMjf3LSwlEpSzdG/RQnO7bYHeZZiVcrAs833+YqbPYXm2/tHYiQF843youHNj4XNyvGTlRs7Fy62ZLuFg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.13";
        hash = "sha512-vrodd9MmgUIV78wvYUCMb7HDPZie2vXiPtHpB6gu9obZ31wI6gUErdZh3MTpqL13spX3Br9xm0+qmWnxUuHgAQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.13";
        hash = "sha512-2tl5SZlpkmLyaJUA/dyj7S/BSbf3Fwu6WvOLiCOB6dz03IdsW9jidoK0QGT2N3pQOTvvqZCIzLZBKg2m7S0eiQ==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.13";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.13";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.13/aspnetcore-runtime-9.0.13-linux-arm.tar.gz";
        hash = "sha512-jVHd+WgPZe+rKf70b5glUuIJxPNfd4OBxloQ0puiwgchrS/B+p3izR7nWFZuZskWVZD4a4a3zJp+b6s5YPDC/g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.13/aspnetcore-runtime-9.0.13-linux-arm64.tar.gz";
        hash = "sha512-aoDMuttd7B3z5YTPmbRU+L9VrA2kMvT6z9AaXgI+XFbk48U9g6qY45JC2dctBXdadmHe5493u53LhBIFz9cIDA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.13/aspnetcore-runtime-9.0.13-linux-x64.tar.gz";
        hash = "sha512-n0iV0kefqR3IAH4Imthh3pieUkVak87hneC9BgfM5K4AxUJ0JSf3bTvlX/HUeQBkd1CV9YLka95o+NcUsCG2JA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.13/aspnetcore-runtime-9.0.13-linux-musl-arm.tar.gz";
        hash = "sha512-hQEsbevF7cj/w5M35exaVJolsN4r6LRwu9WukRnOxdCCjljv+oInRJ7Pt0I0ccXFEZ5fRUR5yfMBshBZIwrchA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.13/aspnetcore-runtime-9.0.13-linux-musl-arm64.tar.gz";
        hash = "sha512-nrkNssGNkyzDUdXyLVthvOnKohyPbrRvrXgHlLeLzlVYPSraFm3N7RBhM3PkwjV4PyeEY9i5fD+d/LFqhrgN+Q==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.13/aspnetcore-runtime-9.0.13-linux-musl-x64.tar.gz";
        hash = "sha512-aev3pa2PMQwtw+a1/MMds5GB79OgTyI2nKRbIcT7qMuvR1wQiqw/GYKkU5lcfXSuiaPbxaHLmNp0jgJdqtFC7w==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.13/aspnetcore-runtime-9.0.13-osx-arm64.tar.gz";
        hash = "sha512-QEFDTWtRWSBwjnNtQHDuVTlyLLquqh6DIQgwGj85TWjTTjbet8/JTm5A5XLBl9jmHfV/r0+V4U6972bzd4iCng==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.13/aspnetcore-runtime-9.0.13-osx-x64.tar.gz";
        hash = "sha512-Wrlf3RAjR7QD7nWCB1R2z4rhzYHtOvR4M2KcU6bbXRHkncXG8bRdg/lUZdbGbKG1nkqDRS1vftxrUTSDNuijLQ==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.13";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.13/dotnet-runtime-9.0.13-linux-arm.tar.gz";
        hash = "sha512-fSgy2iZs47qXAnfcgqjhnHFI9eRkXKsKXPOZnxlWXbypoDBWbZ15dHClaHvxoXE3yWCPw+/Ru+jpXR1NHvZOZQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.13/dotnet-runtime-9.0.13-linux-arm64.tar.gz";
        hash = "sha512-mLvQVg0ZZLuNF0op3qOn0c4vKWa3iRqrRIvIMnWl17F3AbnUqH+TuUmozEELMtzzqGHavieGVimVEP7EcrUJ/g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.13/dotnet-runtime-9.0.13-linux-x64.tar.gz";
        hash = "sha512-Z3AbabG91OLhZYsjETOmyM2xm74+VQ+Iww0gV3SqaGfe691HPM6Hrq+zE6D286SqfrJUgN+SzI0apMM7NtOnaA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.13/dotnet-runtime-9.0.13-linux-musl-arm.tar.gz";
        hash = "sha512-oD8yzqiRixjoC3BFsIvaTF4+SkJLrMM5RaqSmRf5iBEh7wiQIIuHrG6h30b3/+Bezax547UOxN/X0TbxWJyryA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.13/dotnet-runtime-9.0.13-linux-musl-arm64.tar.gz";
        hash = "sha512-aiy+qtEfNp7IxpqWKRm+Oha62oKVWd99/5qxCiMY1g30OhTFplVffajcFb6j/Dt1/f9oYBtbSZocpVy+J7np5g==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.13/dotnet-runtime-9.0.13-linux-musl-x64.tar.gz";
        hash = "sha512-AmbU9781rB1V8+86kj/BHQpD6gL6boJVYSE+/JXSL1u+seSzunoeO4bu3WYBE3VZ07DVA4jR/mWtLIPMizOLhA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.13/dotnet-runtime-9.0.13-osx-arm64.tar.gz";
        hash = "sha512-pO8rEvltpD4UURU5qcweKX8rGUfeU5l6rwKAPQ8LWN00TxItR3Mx3hMn8MJzZjTtkNjYRQdd5JC1LeMm0uqJyQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.13/dotnet-runtime-9.0.13-osx-x64.tar.gz";
        hash = "sha512-vwlb4jFVi5yo+nLHwKpF6inFk1mGxevQygM3u3eKBA3uoBoHlp+n8aKTADjmG3efVYD/OZNKhLjt/I7qPpHaXQ==";
      };
    };
  };

  sdk_9_0_3xx = buildNetSdk {
    version = "9.0.311";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.311/dotnet-sdk-9.0.311-linux-arm.tar.gz";
        hash = "sha512-gOsCypKyAOn4AcejRL2d6auyYstxMy5AZnHtzcep3YH6l9Ypug2y0R86ctP7ttpxnuMwgR/u9hG5OG3zSkiVew==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.311/dotnet-sdk-9.0.311-linux-arm64.tar.gz";
        hash = "sha512-WM520czoVutkooSztKTRZ1V4vg1uzkxUmHxVMfOt5wlghNnYXKGvLuKDYZGOjbok8jD+zOkUWk6mfs+2bkNtPA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.311/dotnet-sdk-9.0.311-linux-x64.tar.gz";
        hash = "sha512-72I59LVqCL/R7agvh3uTUNi5jSSKaTwexK+FovCdsZVW98xNSy06j/DPng/K67Psjaq+F3Sv80Z0Cqz0ux4Tbw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.311/dotnet-sdk-9.0.311-linux-musl-arm.tar.gz";
        hash = "sha512-NA91Wn8pl//5B3xRl21W7+unMBnkXJnOLtEUFHrSY4HkT7RNsw0BngtDJyU62u634skQbe6Z4fIgXV50+qPRkg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.311/dotnet-sdk-9.0.311-linux-musl-arm64.tar.gz";
        hash = "sha512-//+AQRULlli+vEo135wqsur+aLe9ulJAsm84F85fWwx/B+19FI55MEcLHMt5EZnPMXnGuIhtRtsw8Y/PXSDIIw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.311/dotnet-sdk-9.0.311-linux-musl-x64.tar.gz";
        hash = "sha512-+OiDhZdGVJJ2mhP2HUXs0KE3SvI8uc70LX803Wk517hkygM5sMMU+PdxUyxAQlDLqB4IOBNp+sqVv5t2niipUQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.311/dotnet-sdk-9.0.311-osx-arm64.tar.gz";
        hash = "sha512-mTZjKSuLUrVdYexskHtjMBDzh4IoihXj+zYMBA47H8KytE4pQ5N7AvZ03eJ8/mDI/uS0dqkL8UnNEgPVmtX1Rw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.311/dotnet-sdk-9.0.311-osx-x64.tar.gz";
        hash = "sha512-kYToX6ibudOkvopCJuP2g/2UBHt+7BGdvtGE02fCN393xJs4zOHBeFmyjggsZGciXb9Xcz4SKvcYOIUpgVg5TA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.114";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.114/dotnet-sdk-9.0.114-linux-arm.tar.gz";
        hash = "sha512-4MLA7TB9s3MhFtY14viceZBxZc4nyrd011ta32mKSvaiYxi8kNTNrRsb88eZN3sOcETr8EeFTetAsWcVoFVi0g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.114/dotnet-sdk-9.0.114-linux-arm64.tar.gz";
        hash = "sha512-2fkXWZLFE399AZiTRt5vVV2fhdp2C8uhKgqoZ8UrIZH2kmkZd2TdpunRFq3o/Bg7P4MxU9zKw/VknlosK7P4Dg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.114/dotnet-sdk-9.0.114-linux-x64.tar.gz";
        hash = "sha512-iw3p88ESfzA0cwwmYHX1aiSABVFP92Fe0V+B08PMLHbTYweshZTYL2oJ7EemvvasZpvvGNMkZMOPE9VQ6+/O0w==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.114/dotnet-sdk-9.0.114-linux-musl-arm.tar.gz";
        hash = "sha512-Z8VaM9hthujw18h+YVZKgP3w43xHaBX1kAj4JCeAu46wjuGVbpa7GuacgD7MvVwIaouGhK0UJf4eh7GSiOqSRQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.114/dotnet-sdk-9.0.114-linux-musl-arm64.tar.gz";
        hash = "sha512-CjHH3LyxkU+j1fXmBGHVBmNOFuEZbtZ/fE8yUXPfF9BhI9+KihiHDUBqLd+4fbtqBc//MsaBzv5r4mmUjJaBGQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.114/dotnet-sdk-9.0.114-linux-musl-x64.tar.gz";
        hash = "sha512-OiSjHosV/3PUYw+hXaQBm5YakMwIoopcxXVk4wMOxD2h4FuW6szGciGOUDqp6jwoobQJuyZX3RTXzI93OrTEow==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.114/dotnet-sdk-9.0.114-osx-arm64.tar.gz";
        hash = "sha512-7hokzeu19sE7v/kWTmB4twJP8oIm5+fSu9AXgQhRS6p+RMOzkc7KTIf5YJzUwfn07rNKDwuj8I75gRdT1ht9gg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.114/dotnet-sdk-9.0.114-osx-x64.tar.gz";
        hash = "sha512-jRQCKXtFtjzoTxBCgq7DXURMyWgnxRK5pS8vZmEbsvVPNa5sPX+SteZq832rm3bLPyuLj3bxpqnrHON3S9yAgA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_3xx;
}
