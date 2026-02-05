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
      version = "10.0.1";
      hash = "sha512-dh+mzIMt9nUXWglf7N5h26eZg5MvQZGMoqY2i8mLsWrXiycCqF9AODB8uto+Yh+eH+wPX/B//0l44TLugJka/A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.1";
      hash = "sha512-flYAaRRqwcTWGzKAeATlOpDFf46EgWuWil2z/ik/lbC572R9Bb+pNL8CMstitLw07PxLEtckeIVUxrZaS0FGwg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.1";
      hash = "sha512-Hbru54m1Av0D8lGHGJ1gnU8TFYIewPbPo7cIBmj+XpUzj0TXid2zmYP19ehFjIX3gmy3mnZXWRT/M389OUDmRA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.1";
      hash = "sha512-PLdYmCls6trm8nFOUTVxQgG0KxssYA5HL+6WkNDSRfhBlXOhB349+FJjs/+uWtJq9bvrM93dbDj1abYmxw3USg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.1";
      hash = "sha512-zvIEPvPiT21zN3ShmtYVOFogOPw7rsT9zBDenoThGsTbuu77Vh/X0RR+yFdl27Ec7iAxxgrtB0Kqsof0P+XtmQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.1";
        hash = "sha512-QN3AEmYYq2xJJ9q0bpqHpcAHH19hwpOe6bdmiGBG9OR3FL8Hax6JiVi6qlRIB+9p20mnT1MiuKC7GxCPXWHabg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.1";
        hash = "sha512-cIXpTdQxnIpp2o2EHRQ4hFLdMrBSe7k3/9Ce+0iz7WiIh4kr28xhGbO7fV3VH4T48HZyobNfNeBYfVz2tvNk3A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.1";
        hash = "sha512-n8mpr3R3KhwERUidCsyfpSofXKW+NGnDAgLGQwUp3Duc/SyhNn2YEr3ezBYoTxfXi4tUYMSxwlaqpMwEdrFVvg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.1";
        hash = "sha512-l61Khjl1xrKq1wVJVoUFb72oJON7ugf1OZK6r+XgMBxiAl1Yhm23IleWFn0Cj28ggaA1bgQ7+PdeIlj9JC9izA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.1";
        hash = "sha512-XKqUj0ZvBKGx+yY1Z+lObTbEvfWCtzhUjlcTYy/yJF0DOtrFJKk8PEyIu+Zy8RazidVAeP0O+191ha34Jzr6pg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.1";
        hash = "sha512-8L+yX/6aGFgFT7IYbCK7G8wESyG1qp9gWM9i4bsLKAOYjkNdhAkelqLIK0QdMBvAJBPw6ieWISWFxy/iDe/hBA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.1";
        hash = "sha512-OvXliQbK/L/Y7Hej0UsbkcjDdvGWTuLhQXh4NXyZFiuYB0qxjNYBDQ83RqCAGZemRv3KD3esqQECV80TEyDUuQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.1";
        hash = "sha512-lKecrY73YGL6GCI71n8pOvM08kTA94p2u69gHn6AAjfQuWxReMhDvytqcARNtvqef98pFmaomyCW05COgyLzSQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.1";
        hash = "sha512-4JTjPEY+rHMEXBBd7ViWbq6wpqi+m29lWVvcUi0BYtTwdQfigkGfF8pjDaYlyEvuHxrGXv542uQqfLSfHnWGRQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.1";
        hash = "sha512-RR0c+xowMKF/qxHvKcqwZ5VcTmImKXGRwJgSVpsiWN4tH8Di64KlN6lZSlj1uO6SocaOlyB13Kuee9thDiVf2Q==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.1";
        hash = "sha512-p/Ln/LSzYwVi2XkhhPDi9kmXjtkcumL0Mo82PJRyfG15l9HkjvQlG0AXFW5yrjqo4tyNjdkPSAXCRpF1I/INjw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.1";
        hash = "sha512-CR7uuB7JDBTPMHS1YtUZBbZhlbCDgNiuXPhjVKTIO+rnt1fxKgwBoombdTnG+sh4Yv9ziB/suB+P1DdrW4yWiQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.1";
        hash = "sha512-NDvPitCnrp5x+75klaO9EsbbRHL+MBRy5KuJFiMpd3TtkcbaYxvTrvPp6XxVgSiszXup2zq/Z0d/K4paZ7fksQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.1";
        hash = "sha512-OdaZNmRxZcd8HC48oM2+c2NOB6HEMsaBbgXbXBFPuL3iNgef1CNjVbW810imCNf++HY1TFrcONztTeKc25E17Q==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.1";
        hash = "sha512-4QK9FDp+eB+kt7G1Ffes/N3NxxYGixPDHsj2IMw6PIFONDaqIVn217KI7zgLEiCRI3VDZ4JU/IJTkhY722LKhw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.1";
        hash = "sha512-xift8Jf0S6+aCoYXB73jCr9TEQ4NoCkh5rjsXcNwRnWzTxYEmppAghM0ns06IIATy56gtvp0bHbd4dl9kxcHdg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.1";
        hash = "sha512-D4ALEODccJT4Ts5Bfe/vi+boDdcnSpuQdIod24IMOahkt8N9DgRG8CTCvkyVtqYXFzStqtgqM2LyFxNMghUCbg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.1";
        hash = "sha512-Bzw38ZU4NqQoXOHybxZa/yMCspo56j68OSBlmNLs67a9Oesd8RX9TQSX0VkFlThbVSaDaGSWa4d8LA0gr2NajQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.1";
        hash = "sha512-y5Ic/dtL04mCLoGE+0648ddRUAYpXmGfpI5xRii/7rbRLpitsqE/vPRc8Uz6xUoH68dmr3yIXXkAaC+1kdgYIw==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.1";
        hash = "sha512-K3SqftZ19wzr/8Y/sl6auNzCJ83sQhn9+hyvRN3JklUnqtm2j214otdCFITgkHNM/Lnc7qA1K8UqzkBySeDq1Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.1";
        hash = "sha512-3f1VelSNNDqrROz1C13SV//JSS1vvRnnw1hAy6b0XQKosM4ZjL/z59mXh1mYq+RElBnWFsFJBKbHnp+xP+IBKA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.1";
        hash = "sha512-/SFcpKmGhKPEdZ/dHoQuS7xSdVYtrGFGbypQxLTlQXi0CsPhfgQDeDwuvaYewfBw0GMsA9vFonluFeOlCzKmcQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.1";
        hash = "sha512-HgFC59dEzjpoilmktWb62fjRcyaxmpJUmsKkSUZHFE8ymCTFKg366jIjZ0Hq0WfDfsbh0UeDV21fe1PYpbrOzA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.1";
        hash = "sha512-o+3xquQZ9AcjndRpd60ccmA2kzNxMjBarQFwKtxqEm4m9X6reHxBU3Un1wlO5jMNxRHG05oMZGZ9NIcBHswSTQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.1";
        hash = "sha512-bQMhZGLIQlaHtlxb+1hsTLnggZF/ri8jsC4dAz3lAoon+MAweKz0qr6IpVAxChA6Nuhaop7ulyZTYhm+VzSPBg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.1";
        hash = "sha512-LhjhqX/Jwb3b6q8sBDs5pL7dpThlXEks/MG9+pcuGAlkmPQ+V25eiYk7wjlcxj+xB+A7NidxIX282KOL3Dvi3g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.1";
        hash = "sha512-Wl+YcCJpTNVm67A1Os9tQ56cWMcwTti8L8ZuWUJSSRidYdaiDJUpJNfj7ptYsGNMAKue8vqbNQr3zQdKVcmpmg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.1";
        hash = "sha512-do8X7mhD4IdRKiWiVaxkx0O8iN1oiOAYOBa/+MJi0gz4EOdQr67a4hXvp7ZLuJQ8PIxqKfCpKk3aE6KhIY+mDg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.1";
        hash = "sha512-UCAtWzIxDjl4PwXtxX54Q1FD4pcJRE64dbD7S5lbhTNt1JFwP59rrSoKUaJvXhZlx96Fq9FykXtyRxAmkvLXOA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.1";
        hash = "sha512-BLXeMOfMip9vq8+rce0+DgX8+DRmxjrxSeO8JOGiHJ7oD9rYHdX+pSqaakjwe7y7oMIDKm1MC4nJFFpauHlxlQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.1";
        hash = "sha512-/hDIh0U69+S/8FEYmYE8OoephfEe2nNxz1AgtWVEJ8JW0dn4oBj8kyBjCjI3bojYE/tJIdGOM+TyAuU6UFDQ4Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.1";
        hash = "sha512-JmbpFd85wZikAT/D57wINht5rtfsAQlqQG34NvSu3ajMk9hN1cZ8PmEuysoZVSGap/JGF3cAHP67Z7x9U8DKXA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.1";
        hash = "sha512-cauY/NbkxOxCmhXoJRq99czH5geyhEV0Nq3LBhZ18tZ+837Ta13YcpCMgyRpCh//aAwFzDtJSPhf7EZQR77cog==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.1";
        hash = "sha512-Bxt5GRmRSrp+CKyoVQoafibKtrr/ETe6mbkirLqP8+Twl3bAE/SVYqm53UiPH1HOIQBXCxAGkC8NwsmVAXpweg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.1";
        hash = "sha512-jwy2ibfaCHD1j72o/AHzv4bFtqeUXwpgAsph4URVrhFWXUepbRmV/50ehnyA/G+9rEPvvA1cD2ypSr9iZ1e/Kg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.1";
        hash = "sha512-VGi4l0A3IQNk07slUkXuPgFIFM8UnuP/zk4Y9PLazuu0vb6q2H8LXE+iHoDapExAQgL8h5wU3nBGOXL3S1t5BQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.1";
        hash = "sha512-fmpIIKICgHRHHoxyU8YwMVKfIZZYw5ZCH9L+gLCogFLxHemlo0aYvwe2mIgoVJ0b7iDSng3jbZvgvnc7niP6vA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.1";
        hash = "sha512-YKF4Pa+VPrIWISpLmcKlIwxUVjDaEbp42a+dnFNY+RopgzFH3CSdS3OUpW0XPveSshHvXMDxmeVxXW29FvQCyw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.1";
        hash = "sha512-ynpGm1U2SgbUl5CJd4xkD/fFpHnmznBcNyj3ueZKJ1BbJTHlPqhYlYBafk7Ox7cRTDriDMM3D2fk1VsINnS/qw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.1";
        hash = "sha512-6ZezOJwdDRIfrrPCAknmbIPTNMMfEXkTUJO9vuCcfgHQ8oFjxny0KCXwciqSdjqi9hAvXmKgWMVMNg5o+FR1Vg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.1";
        hash = "sha512-/ZPx5RCi3sfpyLF7DrDK237tZLytYDPEa9Ib+oO632IXilfDjii9yTzpcfISsslqfqtQ11QCZFipns6zDQOS3w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.1";
        hash = "sha512-OUFaWk1hiJoLXFwDfLCH4JHJ/0xsQ2lY4jSEQkvlWdHc/PWbqzSNI9aRpoq3uRTt80F+EgdWOXBxGh6ptgR8PA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.1";
        hash = "sha512-FFcu9QPseX6zA1Tj+iT1xfNCGTFfj7S/9CMA+DX9XEFogLX92ppstCFytX9U+wD30GjO81eaRE1CEtijmFf2xQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.1";
        hash = "sha512-qfHzimy78Plho1+jx9eBIFsSNAU+mMvxpPKuqzeEbIWpCnJDETWNrSbtGnujSE2HBoYwmJ49TPmKd7yM3HyghA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.1";
        hash = "sha512-QVZNW+lsh9meR/nvUHsTQuQ9jCYmJyatejlwYe/CC4wxQ/A3mlcI1WraeDdLNSCVse5WZdJ5hSSfsY3AE5ZOvQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.1";
        hash = "sha512-x1zk7wFbxXSaeHvJhGezULy8sUXjZgB1x8wgBcD31EaDqiQIxJWEfMKTdKbu7EPbeGvnwW+5A8j8gRKPKukQiA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.1";
        hash = "sha512-mbBB5rot/iBZapI/e/pcKyQr+dk/o9AufThK7fvKUCb18ghG43+ndf1HcInYMlfsZNDUFUeh3fkK/LmPDggXJg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.1";
        hash = "sha512-oZaaGwczV9wuWxcqQI2Mo2wJwk1jQIFwDl5y0+A97CX2Lv5UneF72ZKG/SwXvt0lBB6fzA03FlEeGA24blhlrQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.1";
        hash = "sha512-3ktoSG0rgamlYB5FPxnZLWw1bNlJCNr9/WJfFNKGlGFiizx2zA0EjGlLG8vvxqHhCsce1VtwOl1GLdUUIklH3w==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.1";
        hash = "sha512-wmQLkkkEAlnEVm48luVyvy4pqcFWQvgQZuecmPsBx4dzy9LHfqAJUG75iabbZrITfFknI/6kMg/zuKS5mgmo/Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.1";
        hash = "sha512-RlTdys7S+pnl/X7lYgDCSyZ6PxIdUpUJTn5XjNpnjD3zC5SNUFLs496lvJ0gJZ9VLC6t2XfSMOjYz9a+JP7yiw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.1";
        hash = "sha512-eiXRjeXKspkSrP5clwRTWOAkd7O9lf3m55BPi20tkGL07y4YcF9HxVAvyaPbo27VA+nwxOYZXaUOjg/t9X4rmg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.1";
        hash = "sha512-iSfcPVNQJfya+QhDIHtVEiYj4Xo0UP3wJ5NPiDEE94t6Ea0M146YY3QzIC7osQKWfyF7vMEfyFsKMalCBl4lFQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.1";
        hash = "sha512-gxyenkkLwMRnyfQdF/Uyn3K2Op6hBMdW50Pssfh6Zu68vBsRimGxiVpOirJCwtNwBy7wCixAnAYKjfNtj4U3Bw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.1";
        hash = "sha512-4oN9SfJRyuZdWXYKzHDnzJef0Ido/YvIKtbtPNnGtz4eNc4btIUlWdJsu/oSM4gKnnLqEmNjFuo8UKDNC5YYeg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.1";
        hash = "sha512-QKgOoiwk92mYG1vCdRQu4koKpWQ3Y9ERouCGpK1tVoYnmHVWPhYFjHHaL4206ho046gWr1+e0D+Y9l7LCccazQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.1";
        hash = "sha512-aCt1Bk4MXPmKeUFUDnwBYWVmgHNhAbDU5RdgT8X2mu8UIKIjaS36bN7iDu3NypRFrhrQ7U7kBqmbIiYaiOGFig==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.1";
        hash = "sha512-GKAsTBMD9cWoyAfxE+f1SLYEd9GmTvgL+ja4ebk9VElHk897OIq3KkdVheH908pFVk5nMk6VG8tDJ8ASLk0Bnw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.1";
        hash = "sha512-Bb3F5goFfxZTcoKuzBhsicvqi1a6meu/yvRSknv2sEq9Ql/YxivArBRhrAu/qd6I1zjd0P6KR0pAHoQJr3Pojw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.1";
        hash = "sha512-AnuURu28jW2vaqROOgmSTubgLvJmPrvx9hsQayalJY3DYTK2yra1doHisll1gUKZC3qvKBZ1+hJNXeppkQHPWw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.1";
        hash = "sha512-wA4ZHHB2+LGAaPq/mUH/NkOSihQAh9YO3OX7iAuDHB3B/MRJj33GzvH2+tRp9jXcaHh+Ttf5lkNqG8OnPg3uyA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.1";
        hash = "sha512-1i+UpeMReEmRFef0CwVJfYbwsxrsAse59S4kcs7dKK+Md1yiZwu6FZbvHLbCT3H5DFtkXAk5fL3ENXSK+sQqxQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.1";
        hash = "sha512-ac9xAIob4JA3rJy0XQLVG1aBSO7JOEER6mQLlvhqz1/OTmmXfLpOtKHNJyjgEqXS7aROKtBl/kXFwTawP/gV8Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.1";
        hash = "sha512-GDzC0UW+ac41G5pGlmAL/TSCz8S0JdLcKC9EsJgGcp/sETaizV2s2Gs5uGRETE0mbp8dtM9y5mIIiFTKZ775Gw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.1";
        hash = "sha512-7a4V5vDv4BifmfYvswZ+JF5j6YK2VOq5OeJIN2GWLJmVMxVinoqa6/5274Ayoq8SwVSq/NIp4DTrhEZoDv4HVA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.1";
        hash = "sha512-hJj/GO2/WVop763MG3A7FCXxdhGAlcNufi3gHsfTrT7CU/h3bok8MrFEftDGMLV3fvtavYnu07anuOE7NuJz8A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.1";
        hash = "sha512-Cg8BYqPyw9X1IDPoOemNXKrhwLiG6xnvFffvdE0l/W+mbAia0zg8Nkonf/tI7dZOY4d/eGd9f5TTzQurqc4a3w==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.1";
        hash = "sha512-JiDZBYHfDprEvhh3QWNBASUxb61G1btj/4kOKvybERrvvBgAM8dRUms9kwln76Iqt80a9Tv9+1XSqDmTvfBgkw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.1";
        hash = "sha512-kdQxCDmxgc/uSxVbqvqlyxfr+CvuYzTqObN6JVBtqeurt0eiQLOBtGA/IsCFq5aobvMbstIu77HNMgQr5Vlb1Q==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.1";
        hash = "sha512-Ulra8P9i36M3IwYsqfRkaUfqfqjoqRe1G24q/J9L0k9WZmzD0PxqYxpjio0QuHVTmSWi3a7xEpa7KEBgwmBliQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.1";
        hash = "sha512-MOmzynPYMicjlF/sdSYLyEgKGqtQH+gbttOuXWfi2u/VZbUJlHyVn5BUdu+frEbMMFTeUrIg0laHDYN6rw7ZkQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.1";
        hash = "sha512-wPnoZT9XXBOptQ8UkqHR6ytEJxgv1Os98/dXP/944B3P/fWVdyLN3fDq4EOf+FYR9QAIqdH3tHKHgLJBl16RyA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.1";
        hash = "sha512-lQA5qngftZSocjMXUDwG76A3HIt9PnzZRkBCMDHF4mAWOzvCY1nWq4GrfKNFEohakD3bChDn7SWwcR8/FrGtzA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.1";
        hash = "sha512-NwbW1q119szIwzqZSguA9zKTxj9AZHTLtfTct8isPh1oBIDEYlPd+FBAM8/Cuc3jvnzL0sMcyHjW68y1xhC0uQ==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.1";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.1";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.1/aspnetcore-runtime-10.0.1-linux-arm.tar.gz";
        hash = "sha512-5lU5pH1swNiqvAMFAbcCWL1Ht9zIcfsPsr5KK1qE18EdntOXddCIAsclb7K8e5h4LaY0LHhXr2CcESAJKNXq9g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.1/aspnetcore-runtime-10.0.1-linux-arm64.tar.gz";
        hash = "sha512-hfK4U7yVBv/RoIbSjfKI6bC/8+yhKQCtjvRZ8uydU3+TQVZN16bf7mU0VVUJr1FVTGucsWh04x7xQcvPbszM8g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.1/aspnetcore-runtime-10.0.1-linux-x64.tar.gz";
        hash = "sha512-zQEXTFKi/4EH0k62HBjbRGOeSnZLElp1OCUdJq0+RFf1JVGBwE5umqHTpKCE3qAHFSpEd3tS47Q84Pro8iGoMQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.1/aspnetcore-runtime-10.0.1-linux-musl-arm.tar.gz";
        hash = "sha512-bzraRU+hDVsYZW0JuvKP+B0+D/fxNwO2PwN7DUFoz4YwC88v8qINiW/dUZuD0+owifNLV4lIbF5dWmFb5h0W/g==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.1/aspnetcore-runtime-10.0.1-linux-musl-arm64.tar.gz";
        hash = "sha512-CepnOa7tOFog8r0wJn+lMLAoFOQPQ6UJYww00smjIZq3S4yDcynVCJaUP7RJZw9Ak+/gm0ug+HbMzj7b0StHsQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.1/aspnetcore-runtime-10.0.1-linux-musl-x64.tar.gz";
        hash = "sha512-74S4vPsyOhGsxX5UBo4f99qkAL1ciuuJxl+xP7KtnjAphmR0lVYaDE/aXrTAg2pn5eflkdWGYfIM1t3/l9bUyQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.1/aspnetcore-runtime-10.0.1-osx-arm64.tar.gz";
        hash = "sha512-G51+yS76MVGfcX5YbakVASYqTLvgR4b7FnLGPaDymuatWS6jLVFoh7wAQlOcsAz0ZNDjT3D1wsRK+I1tY3menA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.1/aspnetcore-runtime-10.0.1-osx-x64.tar.gz";
        hash = "sha512-KqfrNjlgr72ZRQe0T7z0Y4MDgJIXAlOkM1OY03qmCkB9Qvs3sBj00Er4fqJwhagh4SNKPs4y9P0AnL85RijrLg==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.1";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.1/dotnet-runtime-10.0.1-linux-arm.tar.gz";
        hash = "sha512-s6uWHK46WdCkFBFnlUuDr/JbWnTy6Uioo6qYjL3W58XYrLI5WSm26L5uTwEs7Z8YU/d/t6fwDd5VnzAghIJkIQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.1/dotnet-runtime-10.0.1-linux-arm64.tar.gz";
        hash = "sha512-ErorzR5LCXdDxCtIoRnHMpPyaYRCKNhd5WV1foG5NmgWkh7o5Z2pgwjzO5CR0xegANVLhy8LSIrbBTwvTRZjYA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.1/dotnet-runtime-10.0.1-linux-x64.tar.gz";
        hash = "sha512-4iTPHpIqrfmG+kc7nr3ndXjoWa/t24xFsMU2ItZJeedyEMsCcTdQ9IJCkfi5NNjagkk3TqLfWWEMR0HDVROZDw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.1/dotnet-runtime-10.0.1-linux-musl-arm.tar.gz";
        hash = "sha512-tspt7EwPr0GR0/VWVT4dVbKskeDRNusxmf67Wz9oRl74q9RVSsomy0Gg3r5cCYyQJDglpZTFobQEyjiqT9XNGw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.1/dotnet-runtime-10.0.1-linux-musl-arm64.tar.gz";
        hash = "sha512-IeE5b1EmdWm3TAO71BHEPOjpBG6iFqOKmMbtOfgPm2frs95fIUhn6obnRtiRBb4N4U38JLqMCb8eokLsL4RS+w==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.1/dotnet-runtime-10.0.1-linux-musl-x64.tar.gz";
        hash = "sha512-J5ZqJ01yzHu0cuWLzyOPee+g14LB9sPpmsri91almDbZpne2BIy7yFjQbeoym4ZiAWd786M4AXseC4/sOCtY1Q==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.1/dotnet-runtime-10.0.1-osx-arm64.tar.gz";
        hash = "sha512-73SiKCmEApnGEdQwmNXlz8wfhlWvB3J/Doyz77xazaQP+r2QvhM6Lci8PpDPxh/C077rPUz7mHdZ3RSGPAcBIA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.1/dotnet-runtime-10.0.1-osx-x64.tar.gz";
        hash = "sha512-AMYHFNs3LE9X9ABcl37/3gjVFyh3R/mSdpagXJLap6oVfehAFjKm1cnHydrEBu1woneMESwuPNnaSQV0d3sfyQ==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.101";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.101/dotnet-sdk-10.0.101-linux-arm.tar.gz";
        hash = "sha512-XlIsgA/1Xm9snfMOOJL+F/r4uiL4RGP+N1wmC2JT+eFbVzTv6OEvqMJYGLAhAqfvCpXIVuHImI7nrAamL5awNg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.101/dotnet-sdk-10.0.101-linux-arm64.tar.gz";
        hash = "sha512-kjj40aytONFDMktAmcqh2BD7V89ZnyceiHLh9c1niqU9ToUEram41Hhp9FSi96lpkAahfKDXUPCaE91BdEhkHA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.101/dotnet-sdk-10.0.101-linux-x64.tar.gz";
        hash = "sha512-BENgJFXTCvUcgZ14Bem0VVAQHDcYrLs+xfmR5z0Y55sY+1vHzfd7wwiTapYnUXayOlbpYTPn3oOuYMoiQLxgLw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.101/dotnet-sdk-10.0.101-linux-musl-arm.tar.gz";
        hash = "sha512-IZQSpeOp8Za4E2hBF8fQPKpWb/kY91fJ8oMtfYddgCgdZnNqpEJxq0kr2Jyw2shIYMUTCmnePWXsQJxf4pBS3g==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.101/dotnet-sdk-10.0.101-linux-musl-arm64.tar.gz";
        hash = "sha512-FO8ujIewxxkukNSlS/RNexykk27vBxjEeSgZbk/oEhb6Www42ZDgP6KssNiH/B17gk3kla+pwZVieLbcRIex7g==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.101/dotnet-sdk-10.0.101-linux-musl-x64.tar.gz";
        hash = "sha512-o7Zp6AY3bCncNaHty+9BD0kjOjWvnizYMYBF6QhL/SnzuvgRtoonYLchJqGQNSzGsQdj887Nq7O733vRtd/SGw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.101/dotnet-sdk-10.0.101-osx-arm64.tar.gz";
        hash = "sha512-EVB87W9S86k9oPEjrl6JrZVc88+rybPvGXxoqZvKW0XnmoJc+TymqwPtH4t7F4Mwi701+rnxFyEJGzUVkm8r8w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.101/dotnet-sdk-10.0.101-osx-x64.tar.gz";
        hash = "sha512-ndwNd2X1GC6psKyI3NAr5a9N/ExHs0BsD+efy8bYA/ZV1xgrOnDHoMgXbcAsaVZXFZOUPw2GMWW/enuHGsx5gQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk = sdk_10_0;

  sdk_10_0 = sdk_10_0_1xx;
}
