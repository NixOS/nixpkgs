{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v10.0 (preview)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "10.0.0-preview.2.25164.1";
      hash = "sha512-fYMkzeTDQC6UjLHMh1JDzKYXWvW3OZQ5HTAweiYasSypdxtYrFtGvMdnxjjaFEpNJER4fwfu9MWxIymARm7QgQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.0-preview.2.25163.2";
      hash = "sha512-OurybReC2ZIBbIplQvtMCtjnEMp43xHp6rE8J37LLdax5H1XBP5o5uU5B54Y1H+SHf3nzPrgeIBlNFvfTyTWxA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.0-preview.2.25163.2";
      hash = "sha512-YQJi7qj+OivviA7f1jCEH1+VIL7EEtC53gGqo07Sf+j86lcEDZyKSWfmk+rdRU2j/4vZ0lLf1jcio/mpJl0txQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.0-preview.2.25163.2";
      hash = "sha512-/qHuLGJzGlMwxGtsIFJVLWHVy08e/h8IDOiRlOjqluSAwcqCrC8ds0kL+o7eurQJp1YyPQgdkT73/dmmcsEagw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.0-preview.2.25163.2";
      hash = "sha512-EQMhyJBOpIlH1PwyV6FL1Yjfh9v6SFltGdVsiJfkBFd8b99VlTfqobiqDum/GJRw4m8PXo+bkaNz8o/Jd2ebZQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-Cieasw2gZJ+iZS8lqQVIwhsDEem5ReGEZ0LkRPZ7dybi9fHCK6LT2B46muLsUikx2HBPezMV2mN7ZGw/l3lIdQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-gQ/sJVpO4ruqIMG4clnWzp7CWzOlrXklBYA/DlBHUYlms/SZcqUBV4vva1Sk9L8zln2RAagokBWQYoO9pStYHQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-tVvw3o2ilquZQKFvm24rrBEXR0pscFY5qUakJ30tl29JfNaUIotJUG2fWZ/kD96wCqnACVB5zp2D2wi/STQhcg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-ZcqAA6krkkydoMtk3J2syxpt2r7bzR+iqc+IMFWG4yKfALGHIkuz9XoYTnhAki+rwtL0A/BaDpEc3xA3PpOR9Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-/XqJkXi9hfn7wP7psJBfzFlML/pkWs52ZkxLaQwwXBt3YcbAccCKPz4TPenB/wJ3tN174lxrL5zIvD5+HawAPQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-vXwLf5c8GVhgOPGu9nxSwFVMvCtZULVvbMguMXoLDBfWvHSER/0whkDgWdJVsTGEFiCkhET984EQR+jKj8u3Tw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-oGf1jMjRs4H+HKrbkPSnBCYLYcmM/aMGAp4PC48cwq4b5EkYWL4t9RUcf02oOkO/ZH0Y3aeZmEau6RBp3VqsPw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-VvZndNtHe8lNC5Y0A1fbrESCYNKvpf26qyyNJ3RYh/NmpjVGXsGXqHUodLkhlVf2c9JTbQ1fIKCHw8H+V7YGeg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-O5mWnNxmW3sfzYzuF1Oajvxb4dF4t+F0MdxVWfgyNkxzlKDgSwPiJ4Xg8hElN+istQJiYFw2Bhy9siqTEaCGWg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-HwLZs4+in99u3TEsFZM66Kgzqqqp/gZxvFPNWChGdcGkewAzIo24k5odFXUjaV4rxjEe1rMS0D8nsxspJiv/qA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-B/eqU8l6X24aA6NW3ipNhsJchu2iLkOGr+w0YNmkwiHlwW2N0TWF5O9necwlyQ00guGt3ziyBtPjvm973+VaKQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-jByRZh3dn2XWkdn9Wfkq4dX9zpTewMkEoRU7UxM1WTsXqwYl5EaSOb+u2C+b8eKTrwLi5D5hUJR8/h1ZmowE3g==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-nQ7ny7gnwIvjj2f8wEgdfdVusCtH9Av9AeSxZWgmLEKWqlcE1h0JhPhRQx68cuU7aLlUZ3I8fMRkkPk8ZWPryg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-Iu1L4i7aNaY+h+ZEMBKJrqBmLnPjexOIKNAwh2GJlPP/ybXAKLm+3+F1MhRZ/XllEyZpxDCb4KsJd735nOTsuA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-4ESnA9qlBd+Mil9+Aq9bC7/iLyr2RMdOcpTZdb4JfvzEyGlS/eO/jgx96TG7DExbhdvts+7Bip44r+bSVhukUQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-JfRI6RnrnPdMDVktXNG2xihQyfKjkk3JyNadkUuGaPO8sY6zH8/ETluFV4iA1VwXira9wmaz3s+c8w4GRdtqbA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-K6cqb1rspwgKAhSrUhw35r6peEfv/zZ//jQtlzIx/IS03z/xXUYYUSdI612dlkwAcB5Fc9xOhuvVX2n3fKfykg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-QiElAQWko8o3XcVi7d+OKMbe9LVHu9oZ+yrQHMmia8j/eT2IJh0qTd6tLwXP6zdQ4XIKWsU2KXO/UbJAN1w//w==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-GQujUNYZiu7URKlNquKouh71dzVwllx7fpQnQc6LTYljDeEUKJYub8cWL1XpE7nagtHQEpk7cgGkOi8Mj2uJ1A==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.0-preview.2.25164.1";
        hash = "sha512-yHOu2Pa3I00ufGOKdhGvzMvbeTbbSTEpovFmV1eiPlAs331lZjneCnxf5/jdGpY3bA2ZyzkIIvCdQCONG5vgxg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-9WlHGvn2LER6YnMZUXlhjYdZedtpglBnOJXnAm1T6fDXE7SXdNoKanyIMurp7CIcSzIUnTxtlpYFSWPo2ELMtQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-9+JnLRfcTbGcdHvFkMSH9RonNMg018RN1b3gmV8EGUk5euQdFekozbrDv0/gcgHtczkJU76o2FYnmTnfTgtR0A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-xAJuJZzQSjTgJxhHo5mXdsf2IJyP0hTJEUUlqd+HOmkYMUurgjhyzN9U1j7oHX54rZ0a7MNMqbaLLXJVduJdBA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.0-preview.2.25164.1";
        hash = "sha512-N7tOTYXkPMYFqvLXbBKMPvjcCRdRMiCRYS6wV/x1JNSbrSSBMF84Ev7jbXrSpQVi0j+Do4Z2pxrOnLDU8JZ+Hw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-nJxaKLr14lGnGigfS0IIqReXhJkeb6rCntUkPY+x9cjuBAtz8YUe9f2WHAenk6snYqWbRqR861I+/IASnHZLxw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-ZGTkoeYsP8WdgJ4S8vBRF+UeiLjUk52M6JAqq40cTsjKl8ivQq7zfrqFyGRdfFnC9376GF3Lsg+Z2fbNWRb7Lw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-ghYZEwoP73mW/X8+SlKmhBrpbXap2NzPfRsqEsDR0q4MX6KuGMNiMyBJ7I32mUpbj8bxYOWBktv2Ghy5v4Rdxg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.0-preview.2.25164.1";
        hash = "sha512-L7IYzdd29Njp3cpZVVSgHsspUlhGqFljg3hwxLiAJjNw2hMwZM1SIhdK14IxFC1zTpwrUlcpsbXTrDVZRwMLZA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-zbgLSb7iVnFEfaqlkj0mBozpr7EZy/gQXlH+MLmjKqeUu8URiA5P+qDwSxkSBy3tjHdypydtRwr3yzSI5Y14oQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-8ub8FpQ+KFKdhscpMQmlGwH2GsgF3I8aNEyvFoyeGPJvqD3cXIijZK26aTjH848E4tJV4AO7tJEFk7TdKXnwxQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-qiCczti3W/bhI50Tp5r9NOOlDoCjtaBo498wNzIfRhEt/nzBe8Q1Fnr4w9w1WiW1wIFQPwAI8UEHFN+CPkwlqw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-preview.2.25164.1";
        hash = "sha512-dqGfk7Dp3LW7+o4wQPbVqi0brEJuubJzlsbvCDEF3ISapgmo4IVdaIFIdajEeK0CYDv9ro6CpKLOAILXhfT9QA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-klCs8GuMTDnn99J3NuUhGgfrZ8USjXFvUmb29YovrXbIYEBEWwHAu8dkK9mupBiSXkXale8Fgve2SZ2lic49dg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-Z8ABfKzezrD8oQnTFa0s9tQASL+wsHrrXSLQDu4djyiclc1N18kBRCcj1hBwa4V6Qs+daZqZl5f64B+eTZDlmw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-KflBz+weDQwzryX2ManDUioAra06ojwq8NgAUEpKiuPdFO2w5aLxNLs35ayMxQg27HxmiUYzgFU2XyzY2EqsYg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-preview.2.25164.1";
        hash = "sha512-5IHjU+if8HXHLcC+eYJkkIj02GIwO2DQMY1uXM+P4PisHwD6bDkojHDH6Eo51LnwGZkKttMSUZ5FU+oI2SJXeQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-244dky5rKXLRbqUrR0CSgjkdNoQCQJTMCe3B5chtMEZBkk0UCsQ3la0i6QoaGgHOVnyZAfDLGty5Xahl9Zxkyg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-1s7p86jY7ahEa1TvjVk+sJFqF6sRDirl05nJ3JVKZ9vOVdZjO9SHZkdZzOS6o91T179Yve6vS4ejXIn16LVWDg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-toF1P9FT+YMxulAzCc7k0Ig2K4y7Bz4pzJ4woQwCbx23AUIzHj+SR9u0MCnYY53McAkZ6Xrd7iebFdzCILLQRA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-preview.2.25164.1";
        hash = "sha512-ZcVz2V5BVwsm6JLLvd0ZUwkF6qd02/EM6HRCjcG66xjmClffLqVyz0FyDhgFf4sjub2o+y0VVphMwpKaVjeEKQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-7+0KqOJXhUv7HXGhIOrh+W/Wg1p9okac+fMu6D1IG//dpA/dTh52gFRa39s/Di7p3czUG9Fw9CAg3ayLc9FAVw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-kzhqF4a3QgdUIUShjH2y+uzZGFqjiRxcX4dEjBNBz9uTLw39ESAUzc9/0OzBqeQf34bndcdWg3RCjl++DSO4IQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-FxEfJnXNNTZGdoIkXnlbECdH4Ey/aFQTTkKLwUtIULbW7STri3KLmU0rc5htalma/u0TMoaKjoNFfM8FKhbKXw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.0-preview.2.25164.1";
        hash = "sha512-ia6NWtmLd+Vaini/F85LdVzHb+yl4RRYbMdqvoRYHuIOhz7m84NEf1rqnukkV6W0CDZBWcJXCEhxN1H1jlvBfA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-OrJWaFXVGFuABTnlHpzLE/oSlYTGCpgVQ2XipZO4IdQwLN2t21xdrmYlhNBKFBO92dQyikoIjAROjlcrWE1jfA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-GMyWth75S1zN/YC8vFuCFzjGcoXB6YTwnVp0sv8bGhyeAamjMt/qB4qCPkrrw/Lt6DF1D2K1J8k3Fsr1Qlp96w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-v/g5FTqPmNdTYPWUFmOsJvf/VoxYe4Uzi9AxoW1xfoCfG5rqdkYfI8aIZzPLVXMAzDl5+ksVQOJIlrXujidBCg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.0-preview.2.25164.1";
        hash = "sha512-WcJsD6RRe45HnJ4cUOvW0FEGgC3JyCioPLHBivJMcDaXcphlSsJpeJWH3jQ34YBcmJyirZHcA696nert1mQLKg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-DM/5ZZI9lEF3d2fpj3Yy/w+9aptB2kRtIrcc2DQpVAZXAiMxpZz0mc7+EgkBsV8y7SijBi1i4E/gsfcmuxUxOg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-d0g9fHBn3W0RTBggWPWaUGb0VkhCLmeDfRtf00vRAKvBLqwaVv5uHMlpSCNktT+2dq3tIEJshtvHmtCGOUOiZA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-uUT3ZDtdu5F2R2G05QomGeraLrPz56NuFg+pfBnloIMihQ1mKLnPrOCXZ8z6F4U/WPEs50B0lrk8ck7RNvYpDA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.0-preview.2.25164.1";
        hash = "sha512-UpRM0FNAeRnxPXakMWmn64Hw4gTnFDksUEmaW5Q+uiq+lTHy27bGsa9/qo1GT07WlwlrnSGEL4Os89UQi7fpCw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-v5zXnXy+J5ll82nnFl1ra3QQ+YrUKnBavGG6cuzutJ0HVyQ50i1ggv/yiQbisZB+DCNn97mSg+RBfe8ybsV5VA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-skTKyHmXHtPv0SQMSNdq9/tFRNNS3er9yMIaMnaXl6PDQo1FnO7xQ8Akt+VyRvkVCNat0dNeM0EQ0CEOb92kKw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-b0LeHwc+HxwFR6PHFpJPGy3pAhyXwpJe4+Bm0l9HOWTpaTZsbMh9tp4WxnvsZi8NRkTcyLqJJ3HuiojM1+kArQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.0-preview.2.25164.1";
        hash = "sha512-aEhd15xrWBEM1eta0rE+9qRuUERxISKnqlTktCuwAHJQGt3zn9HN8bmjIKw1EoegqvjxQxjVSnt7KY9g8oHZhA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-yiZROfX2xzEI6pJFjL0IvXnc2YYxgSghNW107ZNx2VRE9glMEUVyvS2UkfoPJgt+9ID75FG2t/gW5jGdlgRoDQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-ML1iK4UD1IJ93oPSLNGKsP5tPIrWK6mUOPMBE5Ilcf3JesVVUN7gPvtUfFgcPzkUbB5LC8gTZpnw+0OCPURNiw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-cX9SJnO4M2ybHKwnwNTcyuCaO2ddwMo7nBIHzE/tpM/4Yn8i9ujlzDBFWb/6QLfopkcTEwbXNvIV+8096TM3oA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.0-preview.2.25164.1";
        hash = "sha512-/rW+Iyj8J2xe+EgOkvtIBG+ZBW3BW2QrU9tSGPXV+eH9U9DPn4zqIA/lY559A0v128XSGW4s39YKFMsd5LGtAQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-LCeX8NNZVbXLdCbPQ7/w8BB70TpUrn2QNc6Ur2BMTYoLJ8vf04PwjAYubRstscxr1ZTH8GSZMhWex3Wi2Pk1sg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-XGQika67R1l8sZu89nEEgL6MasIjKdWCWTnpgoGGvEHPnYLXUKU5KhPDrUpuj8pQTyXfze0pQ2YdFFUoOtaJHQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.2.25163.2";
        hash = "sha512-aaT/dlm95IEGlM9iVu8FQbIC7lBZuwWRuzIlvyDGm4gsPDaH7OQgkhdhLO+yho7xri65NVI040Zzyz/x9elvbA==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.0-preview.2";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.0-preview.2.25164.1";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/72b23af4-a627-463c-886b-3f574dc446d0/5369bc93033911562cfd5d8cda4cd2a3/aspnetcore-runtime-10.0.0-preview.2.25164.1-linux-arm.tar.gz";
        hash = "sha512-zuvxkIUVkXXmAATbqI5GmCN8BwjfXdY7IlF3xwyR32vhEKRunuaTAB4nkzBQ2GN8/ItznR5RDQncpWIDHIZszA==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/7eb1b280-570f-460e-8805-5d55cb06493b/8091831bf8764e9a78eab4ae8bc41d5b/aspnetcore-runtime-10.0.0-preview.2.25164.1-linux-arm64.tar.gz";
        hash = "sha512-IWHlPzBBPye+moGnrtrOEq1SPZ5os11qBR5BdwHSOLE1NWniJ4Rap2qciJt+zRtee6/TpnjivylDja5UDpcNCg==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/495feb02-b2fd-4849-9803-43c5d758e72b/60fa3840af9bb27595f6f7b4b818f89c/aspnetcore-runtime-10.0.0-preview.2.25164.1-linux-x64.tar.gz";
        hash = "sha512-3hTauXgTO57JedNxxfvQHnixBswzDBaNYhbsipewzP7rDU9EOGGHSZdg22A0g9wAFiedxMs/lL+wQsxj0lKW+g==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8bf44e44-7677-4766-8486-c6b2891a4c0c/a616e598413adafe4ad43d5d5be6f8bf/aspnetcore-runtime-10.0.0-preview.2.25164.1-linux-musl-arm.tar.gz";
        hash = "sha512-63zgdkzIi6AL3JV7mLgRBXNNpZZCMplvrqqE5PEytmXDF3Y2oKJ5TSt6AeN9lj6S1Zu+am7jcXoB6AVNdEDUjA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b32bcf9d-2390-42bd-88f1-709747ac6bbc/ad9bee446b2682530b9e9af62770ddbf/aspnetcore-runtime-10.0.0-preview.2.25164.1-linux-musl-arm64.tar.gz";
        hash = "sha512-zcF5IytWiO8HmT16eMVIHyVvjO/oFvyRPjhAj63sm18BCpBijW/QTRLhjMw1G2JSpWYXYVShEd9rbaFDCaoNQQ==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c87f5ec8-9569-4894-be65-8f3cf322c251/b655d57fd66869687306e1e7fe31cce9/aspnetcore-runtime-10.0.0-preview.2.25164.1-linux-musl-x64.tar.gz";
        hash = "sha512-eT46PEnCIehUOFCFiyc/byDf2BzYMVJfNNa+KhzuVJS60hDHPMBy2UfJP8gg/yrXCbCiJGK/P+LJIzGeAHhNGQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/351a56ca-b55b-4c5f-be20-1081edb848d7/de67ebf7b8859d4efde0c849de061a4e/aspnetcore-runtime-10.0.0-preview.2.25164.1-osx-arm64.tar.gz";
        hash = "sha512-nk5txKoZR/3iS9efbi2RxD3+EzB8wgN/g+gEjf95VkXbBDloTnUN1vnOwwSJnl57K19NlhMJNF0PbjKoTQD7fg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/dd3d568c-e94c-4ea0-b95b-e1d4ae804ed7/68ac36aa68bbeb472c042af07e0e95f4/aspnetcore-runtime-10.0.0-preview.2.25164.1-osx-x64.tar.gz";
        hash = "sha512-6JlBZ3Veyju2kfQxTaa3AiF9KFrFj6h0DstlepriFHijQariEXQCORCnhOJoPlNt9UWJU8SM2IHGUeIoR76LMA==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.0-preview.2.25163.2";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f54c9c06-3809-49c7-a47e-dc9e63bce7d4/9d64e0d3a360e8846432efb907c87cea/dotnet-runtime-10.0.0-preview.2.25163.2-linux-arm.tar.gz";
        hash = "sha512-/orwyaw9OeVZFVlQzsv6J0UFIfjl+qRGQ43j3MjEv1H7E1MjysO6W7BF/BNCN3auZq5O2dag3zMelZoO00F5pA==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a228c7bc-8b4f-4f52-a517-ed143f8a7b75/006334cb7587884a9aabe63bd298e61b/dotnet-runtime-10.0.0-preview.2.25163.2-linux-arm64.tar.gz";
        hash = "sha512-BcpaAhJgD6LHnDUmxnOCLXntiWXlEyY+6pBPLQn830IwWDIZYbyTD9uQgU7kHvQlRaOyfAgcyXMe5GAsUUh5xQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/005ab929-04e3-4c38-8134-0b57f86f82e2/bee77f190ace377f3a164814ae5cf34b/dotnet-runtime-10.0.0-preview.2.25163.2-linux-x64.tar.gz";
        hash = "sha512-pkzMyYCfpbL0zLF4lkv/qSuEnEPdKyw5gddT5z8rBaK24YmowqUPxnZSut9mljMTREwI6iLkzRj+h5cElXE0Hg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b07dae9d-0407-4ddf-9792-1a902edf93ac/caacc56b747e8096b126aef4e26802a9/dotnet-runtime-10.0.0-preview.2.25163.2-linux-musl-arm.tar.gz";
        hash = "sha512-EpjURujLJ3aNvdUSV2zdZSba0pp2du50i8kvpkQwdgzb6BfKbGLEhyqyAIuEVYDUcJVxpZxsPzMmUKyu6GQ1Rg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/207578e7-0ba7-4785-997e-339ac96dbb07/9380485cffaaca7cb6bd9a6b4bd4306f/dotnet-runtime-10.0.0-preview.2.25163.2-linux-musl-arm64.tar.gz";
        hash = "sha512-Y8xhpb1TsTJ/1n1XsEhBwKjnlQtdUx/HiQNS5WqioJsIOoCMyLm+Gv1CQmQ3HVH8Myl5H9wEeYiM7vrdpS4nIw==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/7ee3d1e8-df5d-4233-9a69-6b2d6e9efcfa/f1988a54e940a1a6decc08b8771cdd24/dotnet-runtime-10.0.0-preview.2.25163.2-linux-musl-x64.tar.gz";
        hash = "sha512-2Rv7WDmzA3fQmElRHIZoIwvlH64NBeB9dhKX2kDJlNgA3lzm/F9zB8vfXPbn+n3XIOyrg1TslDbGYs1P4UhR3Q==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2542cacb-b45a-4071-b75d-da8faf0be4dc/2d36ccebaa81348d4cfb4dd6af8ed685/dotnet-runtime-10.0.0-preview.2.25163.2-osx-arm64.tar.gz";
        hash = "sha512-NJsqnzTfzRq4GUhO4JzDLvYcMWKalSAlbWQ5FuS9XROE88uvjQMWvejJDNjurGGhcMxIa+OWC5USrHnlZ+5UtQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e209e166-f1ed-4d03-8218-70b46e38b2cc/c0cbc2088f7fda9b584dca195e4fb455/dotnet-runtime-10.0.0-preview.2.25163.2-osx-x64.tar.gz";
        hash = "sha512-o5je7K9AF4HK3skZ9IdqqRTZPDjwganB8bhQ4uv+SVKRn5Cr1yPY+qXPN6FJsoHjkXQrqOc2E+Kx5CdnVdjYHg==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.100-preview.2.25164.34";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c1d0c660-7cbd-400a-97cd-508289238f07/ce3b3a3546e5356d4c32f0e5f4d03038/dotnet-sdk-10.0.100-preview.2.25164.34-linux-arm.tar.gz";
        hash = "sha512-CEFosilqVJ/LoZDWnNVlzEjvpeowy/5htb7Z5BWsrkOkFrU92OW/FqWYvu7RsLqW27e8VUouDizgDHY0oaWh8A==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a7eebbc3-e249-4266-94e8-b48a519630fa/86780770348edc13c7ad5476645b4aff/dotnet-sdk-10.0.100-preview.2.25164.34-linux-arm64.tar.gz";
        hash = "sha512-BJE4E2b1DWoiEfkl9cWy4TZPOzpFB2xwbazTr6aFbdle+2uszMiHRxi943Q553YU/yv9WAw8LpdzfULbMR215g==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c526dc3b-5240-4449-ba07-ed9a3610fe09/442f1cf6e4e832eea0b045f9e108c8b7/dotnet-sdk-10.0.100-preview.2.25164.34-linux-x64.tar.gz";
        hash = "sha512-Zk5WGIJ8T55dUVDNftf4xARPha576Nx3mo2GNNzJYrWecxepUz5XsmgzNLEwT3tm5ZteaOGlARR6wU4fIvRrxA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/665e8b2a-9823-46f5-9469-005f1e9e52c4/a291524f20b417d0179b1d44fa345342/dotnet-sdk-10.0.100-preview.2.25164.34-linux-musl-arm.tar.gz";
        hash = "sha512-gs/H+ppkkeYlit8z64GwvLG2n1lg1jG/vR6ctZ4LVVDC/9JiBGHkZDDRIVuMygl6Z6whXg96nJZYANMHpbuNcA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e637ed7f-4651-4e2f-853f-4e81354659ae/b9022529e8dac680f4abf5da4a20b755/dotnet-sdk-10.0.100-preview.2.25164.34-linux-musl-arm64.tar.gz";
        hash = "sha512-wUGbcT1VEYNf/m5h7/4Xgq9ahCn6vVF9PYQNIZdSJlaByxp6FaHwa2xaiQ3VDnRhs7Du6gok1cIGa/rz1S7sQg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/bcc19fec-7eac-4ff7-a8b5-e5a2150ce497/cc4b1c4d475f054a57ac78c333be567c/dotnet-sdk-10.0.100-preview.2.25164.34-linux-musl-x64.tar.gz";
        hash = "sha512-eJh2U171Zmnb/mORN4/PQNwrj0rfE3vduLNYojQD7K/lvby7DHcVz7DSbtBhrbIFIK0asSUF+WTcgIsrEC9llA==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d53c9666-d853-41f0-9063-3343a366022e/769c062074b7d520dbc46f0103b1fd8f/dotnet-sdk-10.0.100-preview.2.25164.34-osx-arm64.tar.gz";
        hash = "sha512-VeySisULCzR4OHGn2GYqrb+UQ8uSF7kF/ER+a0beF5piIr/fwlpr3T6Au4InvN3wiLQeYdWl0earkx/II31ajQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c382791c-4480-465d-9bfe-c311a41f9945/2acdfbcc4a3762cf516868177d92296b/dotnet-sdk-10.0.100-preview.2.25164.34-osx-x64.tar.gz";
        hash = "sha512-zFc9wPnYRiDwyQ3XTwU455ell9rtI2XC8xGhYrD72S0DGml8icgGrbqKwiPD4/NxnebSJD6gRGRsYsu4uhgocw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk = sdk_10_0;

  sdk_10_0 = sdk_10_0_1xx;
}
