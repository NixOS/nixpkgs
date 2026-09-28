{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v11.0 (go-live)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "11.0.0-rc.1.26425.128";
      hash = "sha512-uPsCerTJyOiCI7tfVUTSxOFmnp+VeAW/69+Fv42qACSpp9rhur9cvWquPvPx0Zn3OEzUvdPtRYAyRBdVY3ZYXw==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "11.0.0-rc.1.26425.128";
      hash = "sha512-8Jahn0cZslR6IJGAG8TfNuytUDfuvFLaVmySbrIaK5jV6aHA9ZF7TE7OenuJ7HI+tOz1kVSZFWeHhSz5svV9wQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "11.0.0-rc.1.26425.128";
      hash = "sha512-dZ/pOWV+VA1F8U1wUQJAvTcA7yyNPd4r3Xbr61qy1T97n5lX1AXr9Zexz6zyb91axZAhF2+UFoTUmKRSYJsP6g==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "11.0.0-rc.1.26425.128";
      hash = "sha512-50X/bSzzuI83Nihc+As8dP+9LpYxnx/z77eXs7giPmvPAoqY73uJuUOJUvyuUKP7cejnDjK1yIfuu5idGSuM7w==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "11.0.0-rc.1.26425.128";
      hash = "sha512-h4Lb45Xvx/satTfgQDWqnRTPvXYUDoAbhECi7P3UvEQJ+6/ds+Q0wZuFNeKdaGkJSDGQBFYXEQQhpYvcjIxYDg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "11.0.0-rc.1.26425.128";
      hash = "sha512-IhkhoUu9QFuaPvj+xouXXOInU1bazgYuwjYRHOdvvgvS7FpHT12G2BU8XhhaiUPqEZ1FdGI/D40mJyK1CvaNOQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-MXamavgxPIuX9MCsQJKfaSOO0cWDJMJQNoxazjM5oSpMGDDmVH9PNBnQqhsKV3sKNPC6Kc+kzYht0BVXZrLAvw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-b1vOv5csjimGfY/RYcG3//FM1jaInyL+A65U1/p3qfG5L1LxNOj31Q6EmHEO/9HRCUqa2SCwoC+ZuMckqvv73Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-emPGSJ71cJopLbkc956vyI19qDikp6Rob3WVJSBz/JBoYnDBd4KFFwKFw7yOCzQdgJ52bz5apYpOrdf0ZupTcA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-ad0TOIiCRRK/9ZIphF8G3XgkjOVOgvLfLLWjDzYC9QSstZ3q5mxf3ihU8mpZ5gqYFGesDhdJNBxaAkbV/2MnbA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-Ri6KqeDkRtfS1eMTwsBhX0DsZwxsCKZqoNTU+LOvcnytQAy6MIq38KdPqry0HMOt3DWZs3FkU1eM2QB709snYg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-j1FDgPY3JgC9Qo46f7HqH5h85yuRqimXw/jinQIckh+xMN+Bqbx1DPV8a1LX9zXr24pb64hLyAjO3LUec4AMfQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-laCtx7zVetfzdQJRQ3xR3SEUdubWMGhVDWMDnoOMJD5fCHkAg/kpvnHuKCeZL3NpFY57PieSD1oMne3jpQhRZQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-ZqZ++ABE3+UOBkpTcWiP2G/uTPJ+HeyS47j7B4v/Xu6ebmLTGtexEJOQ1w5gsGxUKmrdBtbipIaE+0J87rWXSg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-uzR+ncX45PQrthDF9esNyNLe6qZH50HuK6MarUmmM6QBGdKDndUv0e2lFDR0pbeSrK3USRB5O1rPOywk8vPA9w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-DgIFZua40Vqv8Vq63eFjvmTGHm9QW4sWLguFiP2I+n5/7cHSl6e6d/BvqUWafz8Sq9gd0IJtM9bHRmVhZeWF+Q==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-2TvIoFSDGvqsiZjCUxchJxjeFrqaEPSCCEamG0d2rM8BhttKs0XM4bWfrEVh9SA5eD+WZICtu0cN93FdRDZj/A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-ZmwA1ignNmB4a0uG2wL6W02iFkAtaI6lNQDtC3q1m08gFJA2ddDWeHk/ARg6BQ8I89V8Ih+TEZabZKNb/VGNLQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-wpZmNTHCde6fK4SCNzKfC178z8a4lCbZbg0eA+nFcCSy0zjwBhCog9K/QNDcJfkn/yLiQG4A8YoAtvlGyRGk8g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-xySNWQKhoB8O/2qMtE727wTqkYVzNNUpHhPRNsmqYhCT8GWPalM+aczF7EzstrlFynkYImIiv0+JsSH1LKyFZQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-qo9YUKZBynvvTq55mtILsrP6KFpopAp8lR1l6pQ3IJcDxFN6stK+jhxM9MYn2ZCTCP0efkynL2P7h4uqAetPIg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-ld62RDxw+aCEEwTAf08+65u7SUbYeJUy6xj5+KOoEiy82kOwY8981iX9arpzCvWsD0a5H4cNaQjJHpxKIT6NSQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-SY2zwiqC9rS1u0eWcCcV7lxm7G/WH66KbeFyPxuDpL8pW3L6n7dUkF8sVo7utreirybeTjdVcFvgbLQGjnvO2g==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-CnexmN/RVZL0XJgOARL/IhqomdwqsfmWUCgUg4cc5Kb6QQiH+GNlhJkt4sZPvO24F8JOUFtHMbq0JQGEB+A/gg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-EHTWXUr/MqYfbC43D/D5XfQ7Y03exPV5/r1Iyd+iK5nsBc8VUEE5hY+55gyWOtdbSOdXMqbP8QxSJU620aTBEw==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-aPJdF1IY1yDdJdms12o7dJANg2LJQ1fX8rEjCY/ep1FM2nGJ6ceM2awAFlk4kktolPxJUQZnNyCfW9pt+7XDVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-D1+3g8nilMgtZlA7geri/ItvN1f94I/NVDfx1NHlq6DxReOXGcqzgAU1v0+7+TdNc7XYwaOsUOARNfQxuUjD6w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-mQfR4VezBRo8Vy/xBbdho4VE2Cmb7jRvOJ+CFf/9d4JD7+pEBuYtr3sWhczxzq9QaqhqcvWIuoH3dYclaMNrgg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-ofw6h8xgdoXruGCDb6xB9Voj5sXt144HAlXDUMmyUQITfFln5y9pU22zMLuAIyHVOAwM/8sIx/U/IxCIwPD0vw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-XS8wJtKF9rUJ7iVJep1QRWmLEJA3VAqcDjNKclLmGj5/J5KdPP0nI0iG90gHm0jIsVJv/m47PUowrSFqw1ar5Q==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-yBOMiAOwHclMXFUJVru9XZoRstBoPsm6D+Dza+xAGJYbv2aAdbwVVOdYn3ivESCf8ZtoxDTRpBo9rM1LMKQsGw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-W8L8MxW/CWG+IiookQbjpf4nasZ+LDtcOPaGvva4RwfmDwPpTJeEDLvOu2V1PGYYg2Yu9NeT5SoX3OWU7++Ehw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-ioxs7p+Y00LNYHh7cR003eLfqbnMcUCccor5IeaJ6d7oNBrJu5pcQZRakvOVwis1MuX3FqXu+cMdLEMNj6EIPg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-ABuveKbA9DkoQZr0XKDAaokcg2ua4FcuO5s58HYwTgCD2USGG/rSu6+FvX9NeCQIMURjIOFJ0d8pw0GZtDVizQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-3DLRjy+lcOkWnoZslWANjc1q3+32ABhuJtn4gX4xk0lW3XpS8RvzF46DIMqtDmjvLYNjGW4YnSu38ZijERygoA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-iN0um3Ns8MhhTuOjNA3nhuTK76lsn48p2WZ32n+uxpclxudbqNv6Lnv8FPUw4p0AW/3dAYFiFKTbJuJ9ge206g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-qljfPxAtH7TAgF8H92IIJWhLNg2tak27+ap8B7Vrvnhi58xhFHPPw2t5rGI9/chSPCE3/c1iA34EPAACZDiXOA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-HgncrwcE32D5qvru5zbNMhHaVeQXIF6AvNEheh5BAV54htAPyXu2BPvQFm7GcX3BEi1JgXl9vEZTkie9sMixfg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-IvljUhLpkRuz4ZfxU1hp2Lx2a6V2PqZXi9m24+odkz0ezG5Vkd2Jnn5pNbpwGoCFBTb/bq2A2eWciW9hDqDLGw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-R8yFdZ85WMPXakViHaJtYbob9hUL75mQOs+BM8fPdam8YvglBsTA1xPlRZUXXCrXDfy7cfAAjphmMj77OFk8Lw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-AEHYyd8k10BdoQZzeswN2dWL47xtoQIm2UvtX6SesGL0+7J4dQFPFM13cBL8g9tDfZBBxcE713LP33HTYgxKGw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-Zq/poOKedESQ2T6ZgcUkAQyjJisG4z6xQ/Cy2nGbSLx7D4gb0Aoi2zQJ3P69aNuynuoeGp0VDQM3NJOM4Cet/g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-J4gLUPvq/iW80jeGfiSnob/u5QPY0oZOvcmMw5NZ02LG0jfpLxUFmg9FeriVpjkOSPi/t+4xJ2euOud+EzO3wA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-/SabDCicwjMqkHnPwLhSGxIIwYlfy0NmVSakM8p/GCw99nYKeQlRjY7SxetyoMXb4rhAiVQjlIzit1L9nc1VFg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-j3T36gvzqVEbovEEqpYk78fj1acMjoMIfdVuj9ebLVMYxyHvEWy5RvXzMsKDDqct5U0EyRy2MfiWJ5KBXMRJXg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-7Au7xcFf2soxy4A/GTGXc9I1bLsPqHbyy1dgqrjJvmqitUUYQJZd002ylQZiMF1t88vTsj0XblC2TiNlVCYEAQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-Ya9Ur4wk8Sg6kWHzUOp6zhKoYQ3DjhKmacJU1YwtpHMXocWzO1HZg+1zMwyqGivApQ+fPrpd10exoO+M0EcgCw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-arhqz8omlmqroUuCDapl0k/FQxPdIjJiR7IzN0ZZ4b7YYibTpV1s/4dBZJYJonMvpJ+NQdrd7OppJaMRZFx0jQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-JLPMDFAnfA49S5aPi/LToXuIPVWnh3NrvLyEOD9EEfNoO/jnm+H9HcBQ4U1RLYSrpwmQ4GLatF93E1JavTSqlA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-VoptYXc/K2TkjaBjhWhIclvi23gUhDS3l2BN3q8dGby1ptN2K25UhN8xTewNBjJGURolmQMiApznQ3DqhE8ANg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-mWPJy/+0gGGYbCmkZttaz5iWjqNyx+1pPWowckBkmePPPYoWtO7TJhaHyoYQ6nncJ7oSzekbj8W3Hz30pJGiXw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-K8l9hbErzL/WQHOpihiHKlfMRnyLGmSwu1bFT/3d8r+b1bG7rbpuQj3PPd5YvzRal7vdAKIZyvpZndQBivvVkw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-PPp/wFOVZH6iC4Dv+vLtzz55hUo5qcqudvRbrOEV/VWyCCdkUesjpH33atJV1vbVkXzLixI2FKWfnrapcUeqOQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-4e5QgalnYn2/E0UTvfOIY4bqxX9xgXT3CdggU9iTdkUFCvsxMQcX6VtEA5TuYB8zVRFUjJZb0qd1gWHBYERlFQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-TyLljZYlOLZFktCJGLT+topp12ab4Y46o+uqQ4a5xS0uUm1nta7ScatfQRGGa/G6YcaHFZEDtxEbXvOkY3JuSw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-ihFD6fFZ28k7RaklvQWOAsIlSuuxUhY4d70MITdh+adQ6jAlBbhTYD1huLmn6Tbg+zum/tlVi2+MRFsIUPBIyQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-RpkI5jtZFnGYR2dCD3wCUtzAsUNl4RjYyRh/s8ZPDnW4bMU0ndSl+i9gsDbBjoFYemNgzTzpH/L3peu/7oi+tw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-8YDlh3uvkz2aBjFZAqTJeCkBERaDOpy5If2IOIMp+CGPaxQj616ysbEDupCaU6RhaIpQqszZ605G7EeETDtCCw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-OGibzmVR9AcwKXNoDHd/x5RAg81nWmOyTpsKjpMkqfIdO2BWGRAJTs2R94BBiyVPbPM9RUaq0UEA0Jq6qK/n2Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-z3FHmUYVCIByKipp55JT7apT/3HL3LQJgpTtAYL7VBIJc7x4I2DUSBEsln53MtvNHJZPtsg4PKUkLSqku7Epvw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-1nnTZrfQAhgywbzr5ASt05TAic1s4rgyMhp5mpjPhnCUTVf0yPKzMVNgb/VyT6+vghPkBio2vdhFc7iZCUopWQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-wmLLvEJuHeUs2f4w5YyfS1ywcygeUNFZakp5+mzxjWLX2on4XC1gbw0NtJrs8GDjBbqhpaAnsLxJxhexGxpzuA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-pOSkrwaTm7uHHSPF8qJliCLg11xUQItxTTZTsk8GXMD4BLLqmtiV+uBMDTqyDAYXJfTv2HJeE3ssunr5mFfg5A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-iYEe5GSO4w9Z9ZHoC9kh9rI8oaKFbvXDAXLift+aZ4O3Qo70AXPv0zkej/Qtw/xFzpkiNAegbDu53pOM9+KdSA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-owUbkgkUpb0wvy9mBH+k8hNRh4qh0kA1XURjAnIt3OjycTpS67NmK1fwsUff194NssoTKVeJtPbu2v0h6un43g==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-YIcCrCWf1MpI+0/C2c3AqqVCZAkCnRKRJPfPkDunFnEcYRyjGFdSRC5Ul3iDH3Uc1MNffh1H5x6X5FQcsXWlrw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-ZABWRbdtnijJbZlyfZ4h4GsHS4AHU8vfeBnVlmKzQusO+Uyu8td70eMLk35Pt2VZxWVG/Ls9t7v7IiO1jRvRnQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-WfdKjInxiZhPlwUdZkGhdfaG6h4pmnwYc64R/beIit1DmcI/erzoWSK2/raYf9+usFpDoGa6OaWl7nbEPPGCyA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-OtfpAxwkmLQZeN/UA5KKJpGZ+PMY9fsucSJ4RMiD/t8nyGCHtj3raTfx9pQvIbPaouU8NnFBrQzuoXXzOANoyA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-u6Za5XLGPDF+eqyXef6C9nFZ3ZlXCJFuhH4vI2hlsVM4FiMhtUTmG+NWxY2u1ytnWPfwkzfWa5jaTIYbGzOgBQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-EFhvvHZQQHiDYOdizRDc6D0slh0Az6jw5Mvd+NG9N6saOUMdwiHE05Skz3Hv/dPjB2/KfgXbwWJyN0IODEFddg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-6Kzs4gSYg+8BpRj0a62WsuFtLhOIj10at4eCwtY0qPyUS23fw235Me+bvtYhe0/+5H85jfaKhuIcYWzyaWhAxQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-UZv+9bh5FPMBKb1LoAV7JSd9jdttpinC8cuUSIQslzP5EQLLdoLdjV5rwdWacghzsg0S/8DEsC8ltDCY50gpHQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-9NO3rgdT8K04teJayyMzp2/lSy8+aklP3umPzVXyuibhde38RoNeUMojkjaWkWaGCl4MsDQXxp4BBEbaDal3Vg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-mrTd9gaLPBBsu2Uj9Yb+V+QIynBZE1QPUqo9noi1nGjSwgEeVlWt2K3feLx54EpR2Wr3M8dD3ocbgP1nHqS+dA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-LfqoGmVLvGdV7Oh2g1Zuz5peBTi1yEv7uPYMNDZM4UhXrWETypn+liPM2EMx0Vg3RZ5omdAe5+zSgsZ88Nkc4Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-TMdAseJSOeJ7SG9KT4BbheJ5D6M3neKjVnkQ348ShP00Dz50Z8TJ4UnO/D3OOUpjCqJCzvLbOlRw+ftk9zm6OA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-I8ZKRRVIL+WPpHDcq+qe3/4UN5G8XKr3q23Q89WK/SpkTdsXZ1xPfAY67I3rfMBbijeRzzLoWCRnl1D71ZuGtw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-F/1JORP0sh3lNvMDTSr+w7l3psGspjUzVwqlhgkBIcuXaYIWPqjX1qwch0ajdl5vAtJhIXgyRsO9bEbT1IwtJQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "11.0.0-rc.1.26425.128";
        hash = "sha512-VV7mhPTeTP7yT7XfIwVe52OAw8W3wiE/MnhLLUg6GQyJgGwuQfPe388c5V2MbR3M4WF2QmMehDnRM+pky7tDlw==";
      })
    ];
  };

in
rec {
  release_11_0 = "11.0.0-rc.1";

  aspnetcore_11_0 = buildAspNetCore {
    version = "11.0.0-rc.1.26425.128";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.1.26425.128/aspnetcore-runtime-11.0.0-rc.1.26425.128-linux-arm.tar.gz";
        hash = "sha512-3T/Cz/eZ+nVMBhDAx/VEv6aMhDMjDx1+7Z+VIXHfZzNgR9xrWvjOKg1N0+R0uPa1gt5QJUj8ijZ2feaCQVkHuA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.1.26425.128/aspnetcore-runtime-11.0.0-rc.1.26425.128-linux-arm64.tar.gz";
        hash = "sha512-C7Ui3Z0p6vtRuDFQzUFzLsM4Y8iZFobWOO73FDO9lOlvtE7UPsyX5f2Goj0HA/q2f/8RImqpwLYSayDlf9mwBA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.1.26425.128/aspnetcore-runtime-11.0.0-rc.1.26425.128-linux-x64.tar.gz";
        hash = "sha512-L4sjKj4F18RLEVruWBXKhbKZKhrHMvVwTtRzOAITYppeddIHmRxYIvTxGGXJS2NY0drDZTb09BIq35MXUhYDag==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.1.26425.128/aspnetcore-runtime-11.0.0-rc.1.26425.128-linux-musl-arm.tar.gz";
        hash = "sha512-VFPW2DT78BSIXjSuuisEOIpvkX9+0UipVKQZv9+7klMFbifHoY6tZLR64sYhBmeLtwccUjC7iMSKZ+joKwjQZA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.1.26425.128/aspnetcore-runtime-11.0.0-rc.1.26425.128-linux-musl-arm64.tar.gz";
        hash = "sha512-LzIuQXl/VoZnnk5x1Av7eTfvtGwDaLukp8JjVle1RM/hjEm3VybT0vsQ9uv0XNx5SAhGj+fTmbNEPzYR+E+cTA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.1.26425.128/aspnetcore-runtime-11.0.0-rc.1.26425.128-linux-musl-x64.tar.gz";
        hash = "sha512-uu0Jzt90jQkR0UxTCZynsyPLe0o549ShGD3MoR5wmrfp+O7p+AnIAfaE0JrIn3aGA1jpy8P7jnUWiq8WhsciEA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.1.26425.128/aspnetcore-runtime-11.0.0-rc.1.26425.128-osx-arm64.tar.gz";
        hash = "sha512-3r5JdumFia1N4xv9GKde9lkieIPEvXqh86+6eSnPnZNsmwRT5ze1R/lQefk3L2dEzhXHY7P+DjcgevqUhpFv5Q==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.1.26425.128/aspnetcore-runtime-11.0.0-rc.1.26425.128-osx-x64.tar.gz";
        hash = "sha512-MonPxwAQzl9uOfWDnfvFyTejNPirufY5Xs9fSXaTPTw3F2traZqEhm6Zs9Ne3iLRNYOU9dDpYX1+BpFoiY4tnA==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.1.26425.128/aspnetcore-runtime-11.0.0-rc.1.26425.128-win-arm64.tar.gz";
        hash = "sha512-5duFHnLf9ycC/6i2fUylAUXXRY5iRCCTML2udijuzhSkrAmqXBhFbbsYmebxzjSusdZ7I8OnaDVpXEAVZrom5g==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.1.26425.128/aspnetcore-runtime-11.0.0-rc.1.26425.128-win-x64.tar.gz";
        hash = "sha512-mITHJtmep/lid8nGPlNTiW7TovQZyBhrJuI+2ztGoQCDt1ZvyNEWdUuKHXBJMhrY0Yja68jc8vGXETNzQD7GJA==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-rc.1.26425.128/aspnetcore-runtime-11.0.0-rc.1.26425.128-win-x86.tar.gz";
        hash = "sha512-TdVPPdoWD+ZPFkcU4trRct89rnRUNndziuuubD/IIXxept6Cq+PUGVXUwiORH5cTXPZdAP9MVUORkMtiwg4FdA==";
      };
    };
  };

  runtime_11_0 = buildNetRuntime {
    version = "11.0.0-rc.1.26425.128";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.1.26425.128/dotnet-runtime-11.0.0-rc.1.26425.128-linux-arm.tar.gz";
        hash = "sha512-e8CYPk+r+g44RKZ4dcQlp5ZPkFC8o95rmy36J3F9efdDQPBbLpbY3tuuXuRejcVxPR0XZE7SgDSO8qsTuZaxaQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.1.26425.128/dotnet-runtime-11.0.0-rc.1.26425.128-linux-arm64.tar.gz";
        hash = "sha512-8eYqlLO5qRGDPjXMyOJGADLi3xyTbSJ5ljDjL2EynBsbuQt87d59N/7z1cLR5ZxWI7Kx9u4cEbFcS2jgoFnGpw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.1.26425.128/dotnet-runtime-11.0.0-rc.1.26425.128-linux-x64.tar.gz";
        hash = "sha512-z9N+dT2RWDyoumWHjyeJTPTijDkPS9DBe+9msAO2fvB31O0hIsX75ut9L57wajj3pjwtoxHzWRlEbRZj1x/h7A==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.1.26425.128/dotnet-runtime-11.0.0-rc.1.26425.128-linux-musl-arm.tar.gz";
        hash = "sha512-vwN1aZPLUgaEpZcQUjX45BFcju6NONVQnlBSkIO1KwMa7FwYE81B7ruZkeZe8zsO48ilGkMFcCcENADZONu7Nw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.1.26425.128/dotnet-runtime-11.0.0-rc.1.26425.128-linux-musl-arm64.tar.gz";
        hash = "sha512-8hMJABdSSEyZWIp2t+KTkUfw0YP7EXPDIv+UBcLLZLzYE0pabqxTYfOZqq2EHt82YFTlevJVjaEVauUyheVNoA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.1.26425.128/dotnet-runtime-11.0.0-rc.1.26425.128-linux-musl-x64.tar.gz";
        hash = "sha512-dvY4mlKCFVoLLobl3ZRF28gQewkCkfEthb5NnUwUfVraN/aH9PjvZ/WkBDLDrf7Y8Y9TcjqAciTTHIyJY+QCZA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.1.26425.128/dotnet-runtime-11.0.0-rc.1.26425.128-osx-arm64.tar.gz";
        hash = "sha512-Zf+rCX1uNigC/h07NAoiFXAzuGNaadp1wqpl+g/KngI8sRfgjUPS+2oP2g9wr+eHQSSb53eP80xPuuW8fJYL4w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.1.26425.128/dotnet-runtime-11.0.0-rc.1.26425.128-osx-x64.tar.gz";
        hash = "sha512-IFg9dzZGQs1xsldeoIcxqlivzztZeaan1uQ0vh3daVZSFEj7JZs1cBVu9vrnksyTX269NdYjmsLjEPsDDqWqWQ==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.1.26425.128/dotnet-runtime-11.0.0-rc.1.26425.128-win-arm64.tar.gz";
        hash = "sha512-4de7+NX51dqwqpVUSpTqKODSsF2DM0gUWu1Zjso8r6yzw8MX+0rLVbomKCsSsbkTE0xKoEaK6stfPE+/nvDN3A==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.1.26425.128/dotnet-runtime-11.0.0-rc.1.26425.128-win-x64.tar.gz";
        hash = "sha512-cU/47cGw8P+YMUOeOBiBgswMvCENURkwE5Xr+Atj9JAGLN1MR8LDEahUHvO3d0pzWFXndkm1ezTGaN7tl5FMZg==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-rc.1.26425.128/dotnet-runtime-11.0.0-rc.1.26425.128-win-x86.tar.gz";
        hash = "sha512-WBx3wSgEusxCbUB6hhgHTQNYRRIPmP6NhS4SxKF+FbQZOZ9vR+nEGsexg+T8Y5vI/dXSfCrH+TMY5I9WmFlAbA==";
      };
    };
  };

  sdk_11_0_1xx = buildNetSdk {
    version = "11.0.100-rc.1.26425.128";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.1.26425.128/dotnet-sdk-11.0.100-rc.1.26425.128-linux-arm.tar.gz";
        hash = "sha512-8H7PbX/3CgmkEPZ2+VKL/T3e8bb/96f4od1IgxUOymsnsoJQv9JNTGHZCdU3/Td3drS80W6WWJDxD6GXilqBnQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.1.26425.128/dotnet-sdk-11.0.100-rc.1.26425.128-linux-arm64.tar.gz";
        hash = "sha512-WePIwZN/EiGfQ3oF/65v661+iBVerIPCvJe9tZCnCSnf3QtYWJjgI804g/9Ehlv7jN6enSZdPk8bpJ23cgyV5w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.1.26425.128/dotnet-sdk-11.0.100-rc.1.26425.128-linux-x64.tar.gz";
        hash = "sha512-YIUYV3qrnbM9uS69dPD8m/vMez1HNhn0cxrKLtuoCvbFcaONW+aZSGL8Rnn289E9t2dxL8tvcKdoOXShiCSgzA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.1.26425.128/dotnet-sdk-11.0.100-rc.1.26425.128-linux-musl-arm.tar.gz";
        hash = "sha512-nd6vaHmUWF+33ksDf3nR0LyYqDEzIkyBmj4V+1cxQIX3K+vmXCtnx0o6bSxoW9fJitnKmcUNOTfQRyfwJ29wFA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.1.26425.128/dotnet-sdk-11.0.100-rc.1.26425.128-linux-musl-arm64.tar.gz";
        hash = "sha512-DesEJvCm5OhG6z+Uy8Iuvm+tzuLMTwK9NVrOGMOYs6Uo1EDjqLzzRWyLqGwEmZPx3OsgHQcg2y9utBaY1JrccQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.1.26425.128/dotnet-sdk-11.0.100-rc.1.26425.128-linux-musl-x64.tar.gz";
        hash = "sha512-UHqA6CBrG4nmL1nbnAP4IZLVtGfycuWW9TvTMr84rt/MeyVn540VNZY9dpAuX5jX/VdZr2augIMVT6c6QV4jaQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.1.26425.128/dotnet-sdk-11.0.100-rc.1.26425.128-osx-arm64.tar.gz";
        hash = "sha512-lptvOKDr6FPdYy3J7wfdBpDMlr/lHWN50J16QF9HFgKrXl4JxQX5N4Nvqe6XF6CAeoyChZnIeGVSj9lSyMaViw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.1.26425.128/dotnet-sdk-11.0.100-rc.1.26425.128-osx-x64.tar.gz";
        hash = "sha512-nah3CxK9t4ww5w/p4wqHR6Br6zqO+bTbRSlXcW7v0HRtb8CE5lBrvX6ioeiJ9mYtuFeNt+yrslQodHYC4NB0Gw==";
      };
      win-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.1.26425.128/dotnet-sdk-11.0.100-rc.1.26425.128-win-arm64.tar.gz";
        hash = "sha512-/FeY9EpfmF2v9omfD7QMj59tCvCqfp0AlNTJPJGcdg29gpcVNqiiCM3PesHUOGji97ZBaY2xeElX7+idoSH6ww==";
      };
      win-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.1.26425.128/dotnet-sdk-11.0.100-rc.1.26425.128-win-x64.tar.gz";
        hash = "sha512-ZJovp5sliKOgxZqeoFToAPzbd6/kfmqbYLIsUisR5L7xmSQj6lmtDVSZtQn0pXUqpp35ZMNrmn47z/0qB0g2HQ==";
      };
      win-x86 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-rc.1.26425.128/dotnet-sdk-11.0.100-rc.1.26425.128-win-x86.tar.gz";
        hash = "sha512-tCfMf3qEKCYu8J7sOHpHJmVOAQ0lQ/PIbr0X4zDO/376jQtdhuXTdEfBDbARB5hRDZwMK5K3sGwpvrVjBYtkAg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_11_0;
    aspnetcore = aspnetcore_11_0;
  };

  sdk_11_0 = sdk_11_0_1xx;
}
