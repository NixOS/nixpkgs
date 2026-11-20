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
      version = "10.0.15";
      hash = "sha512-scmS5owAPL7EYn5egcNtAU4AbuMFmOCkpf26W9m2GRgosPd6bL1KurB4jRADbfc0jOeBjuII6oxK3/EnOUBstA==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "10.0.15";
      hash = "sha512-X7I3C9SAfrviW4mNWZ1zJMXpyYGZ5e4SS5mr8JdksZqgxO2ns7pDNoUoAXFQq+hBYIIw/SB3LJuJunUHPl3/Kw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.15";
      hash = "sha512-k50wtKJTncqvk8CT5+oL7iWg3/dGXEUQareA7vSNJ3662kdLlUXdyW1Z+PvFAERYPIzrV+iD9GKag3Rz0hg00Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.15";
      hash = "sha512-fS+R/OlE7AEqsnQ5FzHYUAR5dw4l3jF4eXpmk8dCCas0BFRd4LNlpzZ4BYcLoOOY3IM7JuEoF/1gwdgr8rfF8Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.15";
      hash = "sha512-cZNLf6PwbHrXOabWzdqJ53E/kuDNoaB0V/VP6tk79KBPRH93QRMsCPJMP18qb71VW2PvbQWIIHAJkIdfSbn9ig==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.15";
      hash = "sha512-q/cuZxi8XPwa4dpK+7y9t3KoL7T6qQZUtIqqN96YKx1Kcgr/bhD0K3U+OaLlrWVn6R23UrsEr8FARqKYVuE3Zg==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.15";
        hash = "sha512-P5eDJA2SAVcYOAUbUrBxBRf5RLPFYOkP+gTch/Tq6U74V/leCJo3Ct+KdLjwFNMmbuOUpGLtLMrtEIYzUn+zyA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.15";
        hash = "sha512-btXdn8lQ4CPmQjM8TQQMyTaSQlKLcfTPOVj0BsbJZFdbR34hconW1RWdXfKjfSafHIZHOv3IJo6yu9GEbYgS3A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.15";
        hash = "sha512-wdBX6mEaOy+d5ym+jb+vQdal7ZIL4DaAvlRdk4OzAvmMSEU742SH5849sNfkiRVhR92+l2bmNNpXKDhEKD8EiA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.15";
        hash = "sha512-gkB3UfLLb/+9KAb1/YK56HRKoieFkj9MTZBTLn0GRVrCx5WkoogVSKfIpIoxOWf0LJ1QbgrT6GOv+jueFAPKhg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.15";
        hash = "sha512-dCRuO3McIYAtevwTUa2sbCxAu0ckBHElMekY0gye4871a7/zySLD2lP2pUVHMvCSvT9WngI14uKWDkGwRQVsSQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.15";
        hash = "sha512-jB2LHwuNvDCwr3EeficLj5VJdCN437LCWGE1vmsdZ6XlNQW9nK6JArLM3i48KyfKGXSXMnSaRAIAinOthBBN2g==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.15";
        hash = "sha512-7qTby3WNTpVspUpR/h9TpAsPTOpIz+xfPsrNszInOmhvwtUTJV0RtyR8v+mfc9/ah5ZRESCJtr6rwzD8n5/2KA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.15";
        hash = "sha512-pceZPmZqoJyHaz3FDN5FWeKwVC3A4zB8w+1YAjSjIvz96kuDIGTJp+xjd7PJ8Qptu+mMNAZyAGWO7V3iQPP5Xw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.15";
        hash = "sha512-7NimvNw756immyifxM9KNQI+gUnDEyFIhnWTW99l+ZuoHHWcoFqXKj63xekxenQijsjg35L5Lm/sjkW6/p68LA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.15";
        hash = "sha512-a8qwN8/SAElQAJeMTnwaVHtw2ECseopAKZEpdxJ+KiEa0WDHOmFRQJw6OwSXMRnqn5q2jL+bp8JgZDdofuDiCQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.15";
        hash = "sha512-hnYcF8i539at9SWnB9t1b0ENkIt3lMsao1o6rlTA6ng50/DPuRCdvV4cNuQ2JCCWfaG64wC6iSvQf/ZomP6d9g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.15";
        hash = "sha512-OZd0v8M+UrTCS9Ly2rz5uebluA12p+i52jmPzb8w9Wed9FnQKVBf3Pbv1PdxP4BbAffoD/PJhekRYa22rUX9Cg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.15";
        hash = "sha512-VHBXj6SxE5bcH6VHC2I5WNOzZdZlWgzf9MiTL4+Is+orxNN1IHuIn4oFOM2B6DMcebMkil7PKP9cR1sw6TQCCg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.15";
        hash = "sha512-BJzXfF/BPPqhLRyV7CAaIgLJKSSFT21Q1fTGf7KxvtzdN5Q4EOfWBSCVlSUoLEJthPiUje7fIjvUbwM6CZ0wBA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.15";
        hash = "sha512-6AqVp5hOHLYjCjGLHU7n0yLNDFfU3801/s6O0mWXgvNa4NLRv/DwHgFlDdS8zls6sAyhDfssj+uSaFmuBm53tg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.15";
        hash = "sha512-LGkfSHnrQ31v096XFtd5DIO9aTzHabZYhoSmPdnH6XZsnvXmklYkMKIXFtmicqLpI7jFKCXd6kMEfxlVGDhmSQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.15";
        hash = "sha512-J3llcLiMPAo2OLdbxfPOgC3KZQcpgZ+xmdz+fKLQIfyaqQVNWP9bJ6xhR9JOybv2OzaA5Ep+WRI29/dq5+3k+Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.15";
        hash = "sha512-4Nhb9uYM+qubw5jwNFEwnYhKUMJ5cw2Oy8boxpQqTU2JJXz95yM+eQ5Qrc32MGKjW60fb4s/72ATiBay8Ts4FQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.15";
        hash = "sha512-fAS+Dc3oVZcSZLdRAuoQ4aBQ2JSQMBp8teuaRa6IdhsK5WYLgO0gdSf8JhY1ETigTICd2FzjTugIwE0eSToGTg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.15";
        hash = "sha512-wujrtKDQSZr6NIR3ZSfQsiD+YhxPGyqcGW3NjsWvFGdk1DRqz4E3C1KUjNCKrm3PT6ACpr9hBNtTzLzXn9j1BQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.15";
        hash = "sha512-ZlNDi2WJ/KScjIrST91R7lZrfLJ/lanjz5LCFBooyZhq8B4ZLqBq0WpFTWrKDzuXzQ5LFsQ+agH/O9S4IsdNdA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.15";
        hash = "sha512-Gmzy3WsfnIKj7X6QiTIK3W5MXAmK9/sTJ+dut9J8Qp88YCaT5MU4/VwS2woUSbqkV4X3lUdRRLzL80jrAxyC+w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.15";
        hash = "sha512-cmNIUcsHuvIX63TkXuBDnDgwIVNUuxaE8v36NMza+3BHDLIcyv9OF7x3W6g5IjtUQvsP+Bsji+/oTJZBT7CM2A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.15";
        hash = "sha512-ZnvLOchqzU8Gx8t9WNuMETjapK0ZN2/6S3y6saGQNRPDvbhszoUIZfKbo/DdHd2SqH2G1N4Y9VxZ2RD9Bla/zg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.15";
        hash = "sha512-NnCT+hi3aWrNi03qZ2AY+QeemFz+HigO4qNYiAGuWslJZi5NsVXFplIgbBu6mttq7xLlFmglcJy08Kky0LSfPA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.15";
        hash = "sha512-NdFrCsJT3SoSvAafvCKq624GY+0ZeEbJUUANETisZt2LNzp4UNhkr2fJSleKq42JN2ZGT76A4p7Da7T7BbmLpg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.15";
        hash = "sha512-uyFmBiC5sVKn7/EIraL/ZL7/4jbEi6FBvfnZ5yh5hkBN4vd+72Dgggfl+wVOSdkCQWKj0Nq/MSRYNYZFTmtgng==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.15";
        hash = "sha512-NpSjpYw9M+UjcI0k4PmwBIST9gqPhx98QiR1xRksEYhX8kyWwmnrPD0OphsAky+sRZdn19LseeQt3hVw4naxQQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.15";
        hash = "sha512-p/B5tbzIAEcVJObO0AT6eAJcHbFSznh6JNrvraHoz4R09EGu1ZtXcRQ+CWynYyBCBDv4cwKKDlgukhSjkTlUEw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.15";
        hash = "sha512-OY9hawrAFEnh1F0lbKMAcXRATMTPOoMDWwa2S23E0MPptyLgGcBVQeFEh3Xa2B3SMHlBDYpjKJAbokrJXamfow==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.15";
        hash = "sha512-u2aoKAq4ibayYLDoa48qERtNo6bQZxVNr+DCj9PSa25nsXBVzbNxnyRbQWcZrdAGXe9j849vTxhqBlKhrzUrTA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.15";
        hash = "sha512-Ak6y3EEqwNT/ZL5WEAoGbjxju8MisXpnRxYRynRifotaKEadhhWk5/z2KTvNbnRyAvMqrbN21TSnJY4NxZShxQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.15";
        hash = "sha512-anqQh9ckfgYD5J6MwL0AnjG3jtdYTCtedjK3q1AcnpK7PconVt0S8Eeqg2YP8YLkHW43VLhAZ0wrU2PFDk+Kkw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.15";
        hash = "sha512-mI/C1nlTcTtrU47p+DDgJv4GexQSL5o2bbh4xqEEIR3BibzKn8ILZSI2rl377iXBx8tQVEVhNQGY/b+iwsuX0Q==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.15";
        hash = "sha512-BQfAouXzrfEWfpqG24dHDdEFqjbWBAuAzjXWg+6NoRl+gxNmvAGo5ds9XwhMZfoA3Kb0kU4mzBudQCUVzFXv9A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.15";
        hash = "sha512-tmgxgee7kbb6ERE08Ig4BKt8hwPvag0GDeYezj4l8a1R73QKXtQg3LLwThbdiiUpYZn9GfUoywWGmqrcuIB6Vg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.15";
        hash = "sha512-HQwM/fsH3IfhF88JAf61wKl4VD6CO8E/rRYpSY22JN0w6jCwaFFYBIkwnZfoEtKPBYjAoaWqkn/yo6eT69s8Lw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.15";
        hash = "sha512-gD7+XB8vflUEf+dFChhWiqWy/AAN7FrQC00JsVisjBx9tJRQ/JP+HndC2NKU25+NknaY4EY7af3Y5+qUbUoJbA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.15";
        hash = "sha512-Cix1dsoYT19/BK1WE4TskqhGBWovtkn99RDxjJkdLt6i2QhQMGG/VkAiYmg8/Vt8VAlCc3MbTBebeM8+mJo0MQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.15";
        hash = "sha512-Bxj4yZxW7h63lNRVpshqjVOB56XkecHGiH5OrTuVzNHj84bQ66TNJjI/rm4ccSin6ziNzwfRkkN/VJfIDYw/mg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.15";
        hash = "sha512-zK2GyqW6fuhQq9l4H1mR15sj+A//hztmxD3v0naMAfwualkTGtfTq0icF72PyNz3slYnxaip5iu3ttSj3QbIAA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.15";
        hash = "sha512-rxtESwR9IAtKdJ02FrtHpp9NftHRiqETlmaGrhV+Zo8y7AJaBR5AjEyjE8GVtxk62oZZqHoZ/qGaMDAL22Dx1w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.15";
        hash = "sha512-ebiDf3DHztbbT+JOAszCjrMCjYLJhyla1aMSoH7K6R9tP0df+Y/DXd6adk4CxC9bybEWKKqFKvNHuWIrlt+UjA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.15";
        hash = "sha512-qmngkzoRdmxBDQnDuMiFcAJSHbndDOAu7axjHO0xx50V03PUq6DyQQxVyIJY+Beg5AwZKMw8TPZz8qq85mxBoA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.15";
        hash = "sha512-qrVl8vl8AS+MY3QKkHsJVb/uKJLkyM0W73AEV3qRdlAc4Gq8Ts72Wu4q6Fd5VxqrORbCxMhIrIYgQJ6LiKqg5Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.15";
        hash = "sha512-Agvs+RUfbhh8VHqyfrSC1PLDfl99NxnXe35HEKwwjkH3jwtwSN0CosrqPywejUZXn60dzDq2I3JPK7holLbkTA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.15";
        hash = "sha512-V43dldTuoOqwzj+h/f3Ke4asd6BhqA2Uwe1RrernK/yYHhfKmTFcZvlHHJ7VgRlhRpXa6EAKL2Nct2pRkU2/qQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.15";
        hash = "sha512-hjmvEMymzDzFJDS56/N+STtUaghnxKEzqcz7JUOzpQlQAI6MOu/Y7ZT9kw0K8FwHoX2dYj+wDSM6FDN8VshPUg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.15";
        hash = "sha512-Xf11FFtDwG6pX6F5LSzzQ/vX34XIwQVtVPKUainOn96Tqc5JoyYnmvbE9425iAGJh4HzifFTr0YZKsQcZ7LH0w==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.15";
        hash = "sha512-fPJFHROvWAFOVqvFF9f2+JBasV8RcuRvu9hDZIz2Nm/mnkjbnfNSMnpDy2XZurjuN/fiiC64spsB4P7NWe9T9g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.15";
        hash = "sha512-J8TsmON3LmqJhoazQ3ru6DcD3XMOvVT2uMCDRjoDYwIbgFOgTyJKDffJwUMhOJ9TA+UGvrXBMF08og/yC5BCgQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.15";
        hash = "sha512-UDRfvR+u0bf/7cn/gbFxOG+2Py6pAGXHBK4p//mrEGJopfTQ6cohTPL7LCcXdyaaOSMw0ggYfUwKh5EyjzTQmg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.15";
        hash = "sha512-FkWUXcvW3zYk4GOBGsx/BjwfOmZ7E2fGD5Mqpd9dB06Ty0KWwVmDlM3clnPi8gTSLduF3bazLCrvbN8MCWN7Lg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.15";
        hash = "sha512-baNkHis40XEh2XEdOPTJtqX/yHntmsBm7QSNTvYIObuaKlXsJmF06nBVOM3E8iNpRHpQwregEOQFCsjZQhM22w==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.15";
        hash = "sha512-Ug0Q36zsJiyFQCJFjWe/niTz5HCR8KQOmU98HmhlAZjy8Tp/bT5H04MZzXdNz5TbvlSEqiJCOZ5lT9SUj8vykw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.15";
        hash = "sha512-n9c7GRq+Zv91X8FMul/ZG+jlI/sN7ibL2S3DREQPeR9X54NOHZTWxY2tJX8Ik6Vc9sYTNAhsazFQVbhXyK+W9Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.15";
        hash = "sha512-9C7IqzWTJkodw5bK4G+3XGCkwDeaTkG/sB5eNoFeOE5CdUDr40M+wykO5JcMr6iHaX1ilVoHxj6u6bRJAL7jTQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.15";
        hash = "sha512-bHM2OclAV6vZlGyUebKdxKhPbOsBTxtf6/23bCNG3g2eBxCAuy+HU2IXAi6jFbY+j8gZ3uSobhCY6aZ6cjdr7g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.15";
        hash = "sha512-Rqi9sp3stYmKVVev5f4F7WWX/AknkNQsQmPOJ10mA43934PCXrObkiT4xGmlRBQaoAv/9LEx99NDXENKpMlgqQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.15";
        hash = "sha512-xrHAbD24dZjAt2BWjlXKiP4CGatb6Vw70z8kWs30GdpQWGn1M8nPZUPfyAnppgLavHerIw8Hi5D3G4ozgMMZcA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.15";
        hash = "sha512-5XLmA4VF93j8Gvtnh8P/Q9E24qAX7+rh4k2trsejbHuW6PkvxEzjnoZew3lv4+vRM345kkoEvTWbgMSM9+Rx7Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.15";
        hash = "sha512-EJ1Qv3iyGDMmnHAOVHiRwDXYCGTLO1Jq0+EnNnqLh6fWunT5Xz1MZA5v0BPWDjqGUuE9Z/V0xm3E8WvEzAtYmA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.15";
        hash = "sha512-i9/tW1JXz2B7lPk9XxJl3DT5p+uK7YjoyyVt0/QST3BnU379bzIqP5ezkiymhfUD0SeWFe42eDDaCv3dZMlVZA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.15";
        hash = "sha512-K1wEdFIwMPoG3lOR/Wr1ng6zg6MOSC9Xe4K8mm9BQTY4HFn7Wvg1MoIT9/kLoUrLWrlds5rtTXLBcl1+RAnZhw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.15";
        hash = "sha512-GbC1BsO6jqVOj7LrAagG7x4Qi9rFt7ylOEHqXmZw+k9zeKMAlt8A4QBHt0C6XDg/cN93LBsL/WWTPEZAnEWJ7g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.15";
        hash = "sha512-V8gSxJdJ3p167B4PbNNJyTckE89iv74T4adJmX1V3d+Ko8HmXVLZxCoYJeNjO5mER9wmG83OVoFzKGGwPe772A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.15";
        hash = "sha512-MEGAkRGHrAXYA2t/Lo0mDxH+/O5NLqgWTcVh70iOZJTpoOCL/jKfOgDqYoDi3W9WcnviL4DhMl+5lWC8cxttSw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.15";
        hash = "sha512-ynMqKTl21Mfoo+PW/0YQj64sTMlxuMQaTAkyfj2kYC5+JCAwGn59cBWaslev3l8hX4dFB62VwgMXBEItTTsn0Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.15";
        hash = "sha512-6SGRVVrUH0xToHEXymcNnsvaojZunYTYNFZmRk1/eYLLTD133zbCAQxZCzHLAIjKS4AEMQmor8wDouuNloyR/A==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.15";
        hash = "sha512-1NDKdmctkXJzc39c8j8uZqH9h0We8C5K/wrh/Tum3aVURjKHEcfr/q4yk4QFPTpoCWn37hAw3o++PEmhn3cJ5w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.15";
        hash = "sha512-NO097kukCfYvK0lblA9MEgxEmmFH4a8fA19Azy+ch92Q+YzeO4l6JRCrpSyRk3tV4taZtjQ9ELscT/KfXwOzAw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.15";
        hash = "sha512-Gj6wMMIyHpVRXpriPhsfnOvG7R85Ur0jtW+tZe/NZC8z/4Xdtr82SfDnSGSZOadT6W/2S7qxRpDl2A1BEAw1Vg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.15";
        hash = "sha512-pFf0GF7eF5DW53tz4IDhyV5uq7DXWWvsHn9VT29SKVkRDwAgXs0579BhDkWAnYYYlvop6JWcl1C9udtyjreREw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.15";
        hash = "sha512-Te6OIIdulPAg0PUpOqhu4sHxIiImsBjMpoDdM1Ibe2U4OAOPPKJYP9IzvrrSyhhr4J62pA+tFPhg6tWzqMrqCQ==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.15";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.15";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.15/aspnetcore-runtime-10.0.15-linux-arm.tar.gz";
        hash = "sha512-SHpwfo4WCAQk4jn7juq8yqnZGlIBlzItKN6NHcFe0h7czi3hX3fuj6d24n8UcIr9xfot+rx1zvRZhyGX3mCliQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.15/aspnetcore-runtime-10.0.15-linux-arm64.tar.gz";
        hash = "sha512-HYKmgihxwOdQ0tPTubJ2V9JKIIPrmZwveLObDNEIYheMssbSH5QVec1SG69XOKeNM3jldUxYlak9dUYTXrQOxg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.15/aspnetcore-runtime-10.0.15-linux-x64.tar.gz";
        hash = "sha512-cEdRxtZxtyCTWhiEno8QzbaThUnpzyVJMFDryDipXrXLHKqZNtLtrjuFxZdXeO2SbptzbjolgthhQRurujIpww==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.15/aspnetcore-runtime-10.0.15-linux-musl-arm.tar.gz";
        hash = "sha512-t+zPkndG7vszFffFK3iM7eLpts4EERxBUk6tTIlDDx3cV0k3OoiVHtdZLmXEm1FO8uG2pT5jeYWni6nr+8WK1w==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.15/aspnetcore-runtime-10.0.15-linux-musl-arm64.tar.gz";
        hash = "sha512-/BH7OGvoQfSx2EsaleaLuVF3+tIo5W4hWlzRlu8kYPP7NUyPL0jRMqpx9naCmq9APi9Ub+XiDC048Je+DGTnuQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.15/aspnetcore-runtime-10.0.15-linux-musl-x64.tar.gz";
        hash = "sha512-DEYIJZyZI2vLhgwUW4eUxyxoF9AdTtCtITK3jNkOE8ZSc0Htt4ezjZ4DgtgGthv7sXC5lRzsaNEEOED/F2+pCw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.15/aspnetcore-runtime-10.0.15-osx-arm64.tar.gz";
        hash = "sha512-aLjSAb4S49j4vZ47D1m1AJf7Og01svWZomm7Ju111bfDwArs0PxZebwiRVlVC2lKvgR9T5Ysy1i1DphfB+39cg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.15/aspnetcore-runtime-10.0.15-osx-x64.tar.gz";
        hash = "sha512-WYGj/kMoWwJ3RY27M+xsPNtWH23jfvfMLRWjtcLWCGJYhxJMx/MbrkEqN7PMRD/odnFtgJ84mD+RJNK14zTHww==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.15";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.15/dotnet-runtime-10.0.15-linux-arm.tar.gz";
        hash = "sha512-6/hN41Lz45CIgmbnXOQFfe4c0PxX3Ayw/syFDhvJ47e9v5VctLIPmX7lkmCoeJJvkUm21jeFDM/gUMulMS/WeA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.15/dotnet-runtime-10.0.15-linux-arm64.tar.gz";
        hash = "sha512-4ui5B9nrbCOczPXB/mf9mnLFb93M7cqbpByKU/8DQpOzNf3Z96tQTwm/ez8WXg0U40/J6h8GzA6G0N+wbSdLag==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.15/dotnet-runtime-10.0.15-linux-x64.tar.gz";
        hash = "sha512-qQF311vIkfcaqBTd47z3ajVvWlBoJGafGJF1RFeVSj0Tty88oEyY+g/liFFKWngfioexeTDugCEFwU+e2ygxig==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.15/dotnet-runtime-10.0.15-linux-musl-arm.tar.gz";
        hash = "sha512-7AbOVk5ZTC1AOZnr0p0sB9f8bVcKmxq3bQdoGHo7G/84RwP57av5pe0iZhml+lqDG76Za/EMiFe59a+qydQ06A==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.15/dotnet-runtime-10.0.15-linux-musl-arm64.tar.gz";
        hash = "sha512-hH49OZIUj6RR9yCiIHdpV8V2Qd3y14M+uVUuwmY2Hjwh8QOGemeAeWxQu62/jOwhxCHTus2fk9pz07HnHxG4rw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.15/dotnet-runtime-10.0.15-linux-musl-x64.tar.gz";
        hash = "sha512-3KVZ1CZd6sCh8W+fTjGnXyIQpx/29isBMc8Nq97OzKGTyKfq9aG/QpG0Swr7E5U7JLodjlis0L+A6z8UjCNZTg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.15/dotnet-runtime-10.0.15-osx-arm64.tar.gz";
        hash = "sha512-GFwmTZ5F8U2owLK0miTTp66kcZmag67teivxZEMCkqq8FdnCLS60SyZXak4zHKD2tWSAXrL2WI1aKQ8Ca4bM4A==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.15/dotnet-runtime-10.0.15-osx-x64.tar.gz";
        hash = "sha512-ErAh39pnKKsiK751m5ubbsVf82bucwmiHuYtOFya1RYRimsRgFgrByz9YINealiNbVnG2kWsn9qq/++LZYwpKg==";
      };
    };
  };

  sdk_10_0_4xx = buildNetSdk {
    version = "10.0.404";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.404/dotnet-sdk-10.0.404-linux-arm.tar.gz";
        hash = "sha512-iELJMgGOzSQqJxKBg6iflylnHAf9O1oOpqEUkomr/REFcqWkiOv6Taa5tiErqU3Ahax8YG3U59UEuKSmxUz3QQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.404/dotnet-sdk-10.0.404-linux-arm64.tar.gz";
        hash = "sha512-NTOjhp2iGcrEXFZ6raw9jpbN8cagT+HB1f3u/qXUWvhCRIjwFEcw0RtKdR961Ub7EeTCsnJc2EAe/ucmcR+PEQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.404/dotnet-sdk-10.0.404-linux-x64.tar.gz";
        hash = "sha512-V30OsX/sM9ApEExcY6GrCszD4od2J0q+8iGNusWvGNIQm1QG0msx129cJFIV47oJJqlMICRsZyxBhHyeHrHcUA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.404/dotnet-sdk-10.0.404-linux-musl-arm.tar.gz";
        hash = "sha512-TWot5RZcfthY15o+V56Caj3PXExh8aMzyplCmU8reU+KkNHhgmCiBf6rVV7/SF70KDfLIs51sJqoqcf90aM2fw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.404/dotnet-sdk-10.0.404-linux-musl-arm64.tar.gz";
        hash = "sha512-s52hm2E0GQ7QuRB8BcmMWFhvT3d4LEsOPjbGJ0otWVKPZ0EsKwy7knqRQ3gXf3Y8tmK0NcW+9irVws2GpCLIdw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.404/dotnet-sdk-10.0.404-linux-musl-x64.tar.gz";
        hash = "sha512-aK2l/Y+itl9Vw9scLnc9/JRoyYKMu1b8YAFRQVzCsRajKAT5ruuCyhoyKeOCGve1sHTV40SHsoB2MLXAD1HYAQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.404/dotnet-sdk-10.0.404-osx-arm64.tar.gz";
        hash = "sha512-HJoT9iXQwI8I71pTWXurq+PSRzUn6Y2yGZIQlAxp3V/FmaOaTXww6/KXyiM0qBsvZLm/Bf+ZWF3pr0pdhSFelg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.404/dotnet-sdk-10.0.404-osx-x64.tar.gz";
        hash = "sha512-iMpdrFBWK2GfhSsbmEX4UkPwBDS+UtIUnbGKtNwF9Sfz/Kjh2sguh7nutGqY3hukptYScUyvIiLze5Wu67YRtg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.115";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.115/dotnet-sdk-10.0.115-linux-arm.tar.gz";
        hash = "sha512-ze3yn7a4B14cYxGTqWn+uzwD2NPsDpJ1GWdPaOAcSEo43JFhtxRm4jpCUSYKfesD1Puv9NvVjszVXaYOJTO+og==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.115/dotnet-sdk-10.0.115-linux-arm64.tar.gz";
        hash = "sha512-PS/GGjkT47pl8cYYjwoZPFjrIZwx/dGaDQerL07GY/w8UzjtM4KUG6xF9mbGybWNkIKnRkIjJE48pLGCldFkoA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.115/dotnet-sdk-10.0.115-linux-x64.tar.gz";
        hash = "sha512-Ab8EjPBJWnzna+B7liPThcnZ8XIjfQJn3tJcMfSxlgTXTx0yjQ7l/mvPsjyyDEH7ByybhPzmWCwg7bHj2T6gEg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.115/dotnet-sdk-10.0.115-linux-musl-arm.tar.gz";
        hash = "sha512-+JPIHKBgiS3+SeC2WvzGyvbOXuV94m0w3PZ5s/tnfT/WRv4en21ht9xObhxt8w6FMQ484V2pk+lM77mZ3ZhonQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.115/dotnet-sdk-10.0.115-linux-musl-arm64.tar.gz";
        hash = "sha512-czCcoaKNrnIQmLSze4HgPlukaMdC7K8uO2GaYCV+zkTWwC6txw4nFuC1QeWqU9OnP+EPalKt3EjioKMtwuu8EA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.115/dotnet-sdk-10.0.115-linux-musl-x64.tar.gz";
        hash = "sha512-W2N5L66oC/j+90Bpu6rtQyvhzc3b26xPSDM3CtekDmtZL/j7yjjCvXjMfnutUQ6HegBgISJto8t9EMAOg/lmlg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.115/dotnet-sdk-10.0.115-osx-arm64.tar.gz";
        hash = "sha512-om4EkynKLgkSiCu10tI0K3jeibQDA99Gokl3R0WiZanv8F5PNOaGmitht8j8YoLpPQBtEE9pQz4gjcjHyXkeHQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.115/dotnet-sdk-10.0.115-osx-x64.tar.gz";
        hash = "sha512-GTWqAqUrFgRZbAo2OB3IdzMIb8ilk1dI0QvH/lg8k66joW64BubVRFPq4gLIKybO7CxbOcTHGmdN3aDRI0OYxA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0 = sdk_10_0_4xx;
}
