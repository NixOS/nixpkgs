{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v6.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "6.0.36";
      hash = "sha512-7hUCPQ2cFc920o+IO1kkTolILrJ1ozLiH1ppUQVFxSQ94z2A8t41KCxUOYxEHwoaDqKWJ0LKjDMSGuU113DVzA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "6.0.36";
      hash = "sha512-Ms0jj1SKpzOiIhmjRyvD5guCt7y/tU3cTjMqmiaJSEo3JPZvJXScyAOaKjcMXbCR5eAvAmfE4Gn2hnSzkh90dw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "6.0.36";
      hash = "sha512-qAcjjw2vDNJrTIw7R4UWLQuvslJbUpXxTrd1ckfDpWPqE0cEehOd9CvwizbD7HADjewzVv+LKvB5aOWYnpNmKA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "6.0.36";
      hash = "sha512-CPrQHhIPxgLjXv+SYqmCrtTrcarX5vol33mjalvNDb2z7Vml7LFT7oJk/Cf+GXZq6uBeNt/GOwXnvIaYe/1chQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "6.0.36";
      hash = "sha512-cBd1pSGW7JD53svFRupX19RDqToI/p+ZVwoWW6CYmgoFcDc1Ms9JQObfO2Pam4s41xrc1hABjpwl8VVMXU9Erw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "6.0.36";
      hash = "sha512-Qv57NzPUsP3MPleNrUhisnnSaKf3EyHoiEpObs9jy/ohgo3seMDbjOq8EA1hifx5Dxiw0P3DSbVpaiCwNF5sJQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "6.0.36";
        hash = "sha512-VFKuhQzHyTnjdsv1Rmyg9HQteLw2//afI/g8OCyTesNZWSWRO4bDsrD78uZMD3y4vEbLoOP0qc+vgCe3YdbSbQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "6.0.36";
        hash = "sha512-xdAL8+k9u+N9DzTzeALpng5956ntAzSS+/dYsXmAowVuxdlMlbiOmfDyh0V67YB87qqE08y0wBzdq+Hw3yUkaw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "6.0.36";
        hash = "sha512-Iyu9ynAcIOoiBMLm0j/9nSl0PWQGNW/ba+87hmu90vH/8Dx02waeAcFJj+jN5xNZ4NesUCLiYt1xDyh+QeQyaw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "6.0.36";
        hash = "sha512-LSe8MkWFnKy7/GAYjXjtyT+hpqjspUlnppbajPw6XY5qniMzgeMMoxPs6bLaAr78/Ag9sgmDNmO/NXFCIFty6A==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "6.0.36";
        hash = "sha512-O9utOLvrmAs3rsQyDxcr0c6G1PfzDRu6t+9poZRyHV0PT05Ro/MApDKgbRpVpnpczJZtxjrvyphRusKv1+Jolg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "6.0.36";
        hash = "sha512-Y5ChGWMkky/EUeu4GK6RmagCdmjR8HY049Tsz+HxdkO/ShOEGY6Z7KVOkRoZG/Q0vt+kmCrNDjqlZy4Bgu5QSA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "6.0.36";
        hash = "sha512-7NLa+YPCk3zh+LGMla5Ffl2Sslis5MvHG0Ngjq1jVXHqIMukzM0FgWkhTDC5NaGM/foQOL9poMm0+v+I9ozTuA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "6.0.36";
        hash = "sha512-fmv0OenPlfWVvYHaH8Lbe9ReSJB/X1pdxgyVqS1d8LSrRVtuCrL7Q2Xc+SqTzBCwQUSK+3kFQoS/jyVeddTyPA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "6.0.36";
        hash = "sha512-igD8pT3ADrTJnXem+aFYUvjYUVPY57YnSpeAtwbqkika0VOWMriD29pFqMFV7tM6fEiQOerRV0aE9eIhLiM+dw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "6.0.36";
        hash = "sha512-LnFU9J+ymzkZnTt3Q5/zDTH3q3dNhe+HP/OT24m7Zz8q2UURRF6KRYYhpdaxVyq+P+6y2Bg+2xJedfK+LHWwMQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "6.0.36";
        hash = "sha512-GSewyPSzLVQki2kaWJ9WznyOc3+qKauTbd4M0cY3dS9Y0jlkeMMx9JvsSdUr3b9ZbcoFHs+d7800+MMbIvAWbg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "6.0.36";
        hash = "sha512-Zatdf57Zy27a4L6+Qd99a7BbPsV/gPKdEzULIICB/AhKka0Bq1CSJvpuLWihQwtnHBwuJi4tfKi3Ztk993Jidg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "6.0.36";
        hash = "sha512-vThEWkCQrp8GzhkoeTOgU1GNlaplLcysZk1GHjbSVEHZJP/mTNjmsBL0/LHW8iorZrNbEP57qTsD7Jtk0xnxyg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "6.0.36";
        hash = "sha512-Ymv7zgfCheRYpYjY6nGNM/90W8VEE6vw+gixSHhFdu5rszgqII+rwpBCBKcc5MOzYPp879wi759oy9jug2HvIg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.36";
        hash = "sha512-/xMvX3PnWlvV03Nxt7TaWZDT8XNErkt2sE6jIYasJ9gcxzGr+bai8pj4H8ArvPjj3HsRawcsN4owkesy/9L9EQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "6.0.36";
        hash = "sha512-X8lW/sHbRXQt9uKwfOy2S6NaO0RuZF+8Ov476amVVtDEu+U0diOB1JxoilTLJcoRn9O29EISVzzA1OFgwF2KnQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.36";
        hash = "sha512-owEMJ45fgXynGJKD14wNmyVr6KfYZtLpp6Z7GQORGPibOKW/Dq5MiLdo2nKSoHPSf5KUJaRqhb+JawhoK68rXA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.36";
        hash = "sha512-dJAjWxCDxspFxWKihDHxwl9cRZ4xWWMjCnRKDFn8KNHVdrMrtlhqhhS1iRBW9iQS/gapfsOL05dzq5eWAoaDFg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "6.0.36";
        hash = "sha512-6OwlxDkPLmWojyYtMvYmqr1+b3XCo/F2vqQvkeyOXb0ix1y6qHbKNnjfcc4HPgQbeeToq4lhlp1Jvj3uY7ncJg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "6.0.36";
        hash = "sha512-lAAx+xfzVq7nByfQlRKcVTRElpBk6Q2RF7ulx600kH0mk1Dy0J5/0IxEkwi+K5pEgjjCrGs37Uhc82mVwF8iUQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "6.0.36";
        hash = "sha512-OlDeI3Y7Po0mhbfmb2zVCxaKXhPUIFGBIqRlbv5vnC7OQohief/31EPBNC0RCaEaayRjTv7P3CckkX403Y8Ncw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "6.0.36";
        hash = "sha512-B3ZtzUpX1lR7XjfLrMh+rsZr5lRlVx4r2jK0eJQCyqt/V0Imw2ebQjieoQJra5sb5VQZZcS9LxNGhC5RZOrIbQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.36";
        hash = "sha512-uFRU9M+2sbznLG5zJDONtdh+e6MzkduoEUgmE1EjHULpw25JtICwRtNOe2pIb1HmaAhqnIhFixbfBMzMCh0iBg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "6.0.36";
        hash = "sha512-p9JqRzIRhqEzt8rUvKkX/LHks0wAX28+vmRwzI3Izvw2m1DkTulC/4/YE8kFRiZYu5qyVu3J7eQjeQJlZ9w8rw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.36";
        hash = "sha512-h1wEpa6TXlNPyfrHw3XlGKQs8BIbKyKKEYiXfvXGnvIFReBocZ1GoL+rBG+AqB9UxwKi/ZTMyFC3edRBDKIJSg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.36";
        hash = "sha512-nkc+N/yxkFrne90qBwWvMGqZGauty39r+pFyJL24KMm6KUNLrnn/aR+abM2Sas/B/nAhjKtxLXUU0paFR2jQUA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "6.0.36";
        hash = "sha512-HDuYQ8oIFLpSfscZ9YcXp5rFifZKA6QJpFQAl6RAXE7GXs8a+hjBUPH5goI/Ms1L11T2WgpyGfap2wTJKsusUQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "6.0.36";
        hash = "sha512-c/rCzvHPIQ7Es9YECSisSXAS67S+T5BWp8AgwSGxwpEgr7z3mShbhKNsMtWE+F6kxncIwzyCFAvdKKV5zuGoOw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "6.0.36";
        hash = "sha512-WRPkqMdz5pLsZTxXah0LgKwrGwDVc1jLxov4XKyqeCW1uAtPCTgf7UEAkFaFZufxmW8d+B0UbAD2u4PBCKYkJA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "6.0.36";
        hash = "sha512-QOBu74LANKrjgQI6NMSSHZkungzGW+79tlOSv04HuGkphqCf330pMeCFvQn7U/i+egShqpFVZiFZDuzoTnCNjg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.36";
        hash = "sha512-sSwbBQbY3e2ZesyIYmIfWkZtqCXCDd8SQ0s9bqHzw9eVqe+/Vic5lejXtUhjseT9WlVFezemHXVLKycKwOKZiw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "6.0.36";
        hash = "sha512-PbQTcTomq+6jhG5Ya8EjVjhZ8mA4eeyRzIob4vhVtIuvQd+N29xaBSWLj7Ym3XqXVvw5ZYrV62Hq/DwOk8Lwlw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.36";
        hash = "sha512-1SCZQotM+MemoSipVniSbLf2vL0G7MeGOgziY4yLNCc1G69FRbIEXKEojyUcL0vfo/iR7P0Yr2IiheUpTJUMgQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.36";
        hash = "sha512-Go50A8OXzH/v00zL1QaTW3Un9Ul9ks5RpdG1GN0gZFOt4p5kkmpaNcgCvdEH9Y0sTK5r2HLzqxqULUnbp89lIw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "6.0.36";
        hash = "sha512-lb1/8FBLqS937W6BHeX/5sW7CeE+Ey8dt8O1+uwFaTBQHWVpN/DqNkVHlHfJw7gYJsp80I8imfQ7F5p47iEfxQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "6.0.36";
        hash = "sha512-xw8ONhkE2N0dRp1POSN34sOM75txFYmLhFuPMld1K7M9OO/Itv6l7ERLMlseta0mSxOg7pY+iaTUCKY5Oo9+8g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "6.0.36";
        hash = "sha512-TGc7LuVvkAvUdwxaUHi9/m+PfLmatTTrlmlD+5o5XuKV0WUhfDZf2nuUjUhuIsx/0tnvV2ydwNhA8ajzeOWTCg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "6.0.36";
        hash = "sha512-cwzTB77RuMKHyaACQQPiLkQys4d//jY1Y5UZvHYU+nm5m7OKUKPa3AXn1LfCoCvi9viDd8isi87hIil/AsPfng==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.36";
        hash = "sha512-3H7KYk8BOQIQarVFAZsFL+FJ9R3OW4E6dtnw+M0YruK0rc64IBJHFHdxDjBk4Bud8auS1QG3tjflxWcMDvsgew==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "6.0.36";
        hash = "sha512-nJ06DFHdbbvLBYCuAso3uJu1lC5SK6yk3Xtd8DDzxlPMhflblOZwMhEGzpNeyivAvAubbu57nLB4l/XMn+9aAQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.36";
        hash = "sha512-8xQWPhhZg/dxehVpWvl0gIkFOW43ZimP2KDAi/v9uerAXXG0NgAsHuWOCDi61gQ8LGHLX460KX1VE+VABQFHpA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.36";
        hash = "sha512-JVTMB8tANHOJikofW1YWgBZTVLYgZTWrvoUMNQLV71mrSVAC7z+6yyJnu89FuMEw4wmCYUTyI8RWklNqE+3fFA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "6.0.36";
        hash = "sha512-9jbPtXNsHUDyCWC11sWWyv6ao9aLRvdKpM57sxvhjWeOiLt93QwAagV8uDQ+1ymXkL9IfautWREGntn6KaW62w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "6.0.36";
        hash = "sha512-8BXWNjvA7BkhZD2dGx00Rfz7+FvjprTUnJKp3uLze83Wet0D/CcMn/22NSMq0JcG+DxulQgyQ8U88QadyQagMQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "6.0.36";
        hash = "sha512-8SzE6VIFgq87LipNuj1chTzR93v1Wu5Xun7Om1tvKCIUk98ZjXhIaqtWr6r7mwm/KFiBthCDsgq26n0ffM7wrw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.36";
        hash = "sha512-QYX3vB6w0fNrSeoZrEZpm9uiKUEwDlny+yAy97mn4EA0TV0OJMPhHzbqwu/sGYtLQXki3pPPQwc0sH25px+FFQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "6.0.36";
        hash = "sha512-pdmyxOhfzGGOCgvjAqjIVHwIpaSCYqkDJ3sbAVI6Zmc4mlHp9MmiFJmQuM5HJaS0HBajhkchOPHwZ3Izf5EhBw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.36";
        hash = "sha512-7oFw+NpJU4tS+MtAODx4b3GINCxbDlEWcZsyPrlsP1dUhhKWy5Wk1f9r1253vnStUfx+UsvcMN753N/HTDq2nw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.36";
        hash = "sha512-upZ6lhYYPq5/3qAHUmQe+unfrkDqtYwWRLLwfEWsuTK6RHSkiLIkZbJ0SG9rPLFqAm4ZdxJ5AlylAjVTSYXWCw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "6.0.36";
        hash = "sha512-dWFq/5WE7bNe+fYJrpzWihcBkNGM4cR4bRv23bYxmzdTV2pngiDXu1XBwUWpDgCNeL8eP0BgFOQ4Ra9NNXaLpw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "6.0.36";
        hash = "sha512-V/yoD7xpW/R1jW3DDBLl7q7KCiSspzT4rCRgkMNf6CBFDEf1HzeoeHprpNbBz7NNMYKOWlG28Fm4uZ84LGX9MQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "6.0.36";
        hash = "sha512-dYTLwgPcI9x7oexhWy+b/vsLfq4sBTgGKKdtWOYgAZFCXkKLOeWCtLySNSMmITrs7MtGgRyEwDpc5XIENc7U3A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.36";
        hash = "sha512-l+iUoIzGLGskdR8tE58M6yLcvFQiuh6zl1y4xZ0NHiFMfxsprg495YAUhdRG9S+kkS099X8cj52YpfIirB2MjA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "6.0.36";
        hash = "sha512-od+3cWk88mKDInSQSI+TMuyfSjNnjv28xdQ/5QVyskE7lR+c2+Tf/z6qSsdJwNAPBvoCfbcNXf28qKVnIntvMA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.36";
        hash = "sha512-4RVDjn5CXgAA0CvavXrNNuBCvXa4awm4ZC+Fn0+G2lmmJaakN7NhhCg519M3n4CZm74pL8kZ7Kyc4ZbM/wcurA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.36";
        hash = "sha512-SrAbz7L/nFt+U9UmVs7irCspL7efzWM2x0MuCv6Yo+reF8scoSkVp6ZHfUrtG3oASJlgSUQI6nohmFZVF+q7DQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "6.0.36";
        hash = "sha512-ZAhA9FAERM/iRLRBfZLCdA8BnRbH/Hh0CEe3EvmJb71gWUn7y+jMZX1zE32SiFS6HroMjvhAozyqMbdcqtF/ZA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "6.0.36";
        hash = "sha512-bBaPwnTViUOUer+qW9IB5Gzrv6Ha47od8DMiCho/6GtFjUi8NeDtj8/HFjApo3JZWBzBAW3xkK1MD5QFthDJCw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "6.0.36";
        hash = "sha512-TRU5D6v6pHYNgtnGe9nH7XQnhKE/FdBcxvhWUkS8rcm7ZEYP2RYiOBXQvamgKqH3Tx04+i+2y/HurX0IlMaF0Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "6.0.36";
        hash = "sha512-zPyKnjYA4/HHBEKgPPl+AvPBi61273ub52yfTNE1Pb4WkI0Xlc7Vg8aPtoux3kO+jS5IVs2MM3uCjOVLJKwD2g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.36";
        hash = "sha512-yZfWNHUZyGFvLNxR2Mhtf9m5Z7B2ERTrTAGyGr38Zla2zcOIqbGlW6azyKvPhUGOmRfPOHdHtORocN8PQ4JTMg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "6.0.36";
        hash = "sha512-c9EQxxMOZVnRxb7t2mKquAV96q9AbGIzkXbS8/stkcWvTjdhJscPzwph07EZnjd/9l54iSjqZBgrFcAHGK7yqQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.36";
        hash = "sha512-vT9WNvH/Vjx8FlfMb65oL1hVuHAnXPC2ClcFMg9I+97tyGBNI2wwgp+zY3hicW410kP4oG/UbzImJaUuG+wi/A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.36";
        hash = "sha512-s6wb85RmUkvDGhLy/E8ZSqmq2ghUKcRP36TVFWUD8j8Sv5Tf812BrW18lrqh/MvVZC2XRLoZNNmlQ5t1YoRcIg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "6.0.36";
        hash = "sha512-hcK5PGxMmsIigqtDPCvC5b2YgPXJoUgw6NqFl6WR+TkMYqvpBG0MNByQGEfuVjuuIEMyRdKOYjigovg03FGTdg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "6.0.36";
        hash = "sha512-YJRtVo8VZ/K6qwuyGHlGrPfqVhBZAZ4fk6+tLNZPREZM3l3EjjcrjWat2QL2WZF71aFioZVQScTzKEMfIjOZlQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "6.0.36";
        hash = "sha512-XylVsSjl1387Mz1g23ZUtPWGz/u1YBX2fd2Fldv2B6WteiIIdoLzHOmP+JeBR67WtVSUcEMrTT4NWj7xOr02Ww==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "6.0.36";
        hash = "sha512-M6IcgiyppQQ5GUkSwCaOXGh7y9qOugLj+ePi4Ooi4qMqolXB56ciPZ7XJ2HxWsXg9OHmFcOYtu/7mDPGy2uodQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.36";
        hash = "sha512-GY7b2ozZJe0iiZ7l7qAp4xF09ZUe1Tk6EA35qnIFAEA0X3MjdRM2iU8iM6TZFXEaGycWX2FsydTKmYCGTHwTzQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "6.0.36";
        hash = "sha512-xuLTiyLCUp1xR+4gUhccwCedkFW94n1uQOlnlo9objTXX9GjPxpNik0UJ84zYKOnd5xxWS9zbBWxuoCVZcijBQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.36";
        hash = "sha512-CCVx2PYEhxrrN1SOLc7ls3Vf83zKCm707pSFjiwba/pj39BmRQNjDaLwaSl5s/HeSPnkSZ0Hz9KQpvkTmxUmvg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.36";
        hash = "sha512-F0lCmbajEZCsNiYh7+FA3TGJjWwPq9hKWUZfnabKnMNqx8gzh+jeTWLW7t1/ab1jWvO3yhEKMQMQJXMBBfBhsg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "6.0.36";
        hash = "sha512-bLfQElXz9BFta1qvXqjviTOeCenMh5S97vsdySMRP/IOMFifop+hE40LqUb5eKYoCyB3xkHFwlOKA1zlyKhz0A==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "6.0.36";
        hash = "sha512-oqI1Ilt03mR/4Y4VDNMeYkr5hP3YafBi0h6piSLMXPTCaOgkMHsU6xSpJW5CMTwOCEwREfMZxr22g/meL0uJmg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "6.0.36";
        hash = "sha512-isiVFlAPxOJDR3pbWTrdfoy7ZbLTmg4YHgg1Vzzo0S3M35mSUU4Ere286J0lrA5s/jAe6JhBSmuvCUELIfvegw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "6.0.36";
        hash = "sha512-9duYa7xbMuNJG3vsFO+TNLA8Fcvs7OPonbvH812od/ujnfbeoKPsPVPxOcgJhdUbTiRS9AMTLh3R8v491smQ0A==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.36";
        hash = "sha512-2o8Lnw37R8wev0dpNIbdxlyRzCE+0nAeFXdzctGp+C9ieshr8Or6pnF1Yb4/Bscqmue+KjBbVpWqEuHyyRHP9A==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "6.0.36";
        hash = "sha512-SxUYXhhM/fGkb08i21KbXT2hyedzb+Mf3wcBmFg4NTteRdbt5KWuUD+DCe9Z6Bbmr50H8T7EgOS/QIW96HZzIA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.36";
        hash = "sha512-RRKTjZYWik95UGSRROy5BvwfpBYd+gAQi4XQUuc3vi90TQGxrz/OlPjD9bPPZ4Pr8H/PB7Y3bUrfKnmcs8OOJQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.36";
        hash = "sha512-SewnE02UhqILbpoLxVkL+FLaCCu+EJ/SmR3DwFhAwFPX+47mPB1tLYW5IBDIcT/jbo9JCQaQ+DWdaW2Ghq7m5w==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "6.0.36";
        hash = "sha512-XS0rzgotxL8fojceQ7zeYlmVRqSqRuP3SMJymXpIS45R8dnlpEooDfjjWRMAvyWkscmAmXQRI4f/UItGsTND5g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "6.0.36";
        hash = "sha512-Qpsf4A+J0o0VZk/CQ7zvIvUIv6x+g3l2SVko2K33GcMaBj44CTT9giuHIRkTkcc2mQ5t9cFZLMeWiUuBRxoPBg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "6.0.36";
        hash = "sha512-SjnCMVnWxee70G6D0Pkd4ku/hkPgs6z/nK7ivfLSk12fIWb7aMtM3umXjWjDs8f0aBH8MIw+JTDObDpAKsbCKA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.36";
        hash = "sha512-xEyxlFIb5REDd3hUOmHafhSQh1BlL9WkbZS9FWdeqPQBhA3b22Du7DJCIv0HKjEqYZIM52+bSYZP7xWM0ZAQgg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "6.0.36";
        hash = "sha512-BUuU3zZPYIofbnQR2NLQvD4sYorgexmMGpr+I0OweCOg07wxjLRR4R6Y5e5FHcsYC43rqLVe9Aef/+8+kcH9nw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.36";
        hash = "sha512-mgAXyAMIdlx09SyTLILzYHZBKJKpLdhGAsfhftLTkjV7dLqMa1hLeI0L4z5L0Qh45+kySfWirfLCrbXYPCoHbw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.36";
        hash = "sha512-LUx67cKuFJR2rKoTmb/GCwSmSYFX0ZitgjxacIfkZvhcsqOu1Sj1MYNmDiNURK/tA6nAxyYd5oeLZQUd2zQJ4w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "6.0.36";
        hash = "sha512-E9hCzeTTHxb8LxfTRQNcG5rXhlgsSvNDOm1c8oUjJIMG1dJkKs9x47oSQccnbhvAdoMoDUV8xKxohlFjsFPiMg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "6.0.36";
        hash = "sha512-YKC7Jv9kh1dVCQkIGfEX4ZVk/DC+6l/X5dtWP2EFDaIJsjVZm9g+BZxL2YuD9rpuKFHevJDqliDtAq95SQxE7A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "6.0.36";
        hash = "sha512-RnD5u/QM5m9s8eiI6x6b00curwmLWiubt0bp8gEKC94EHDMoziuTRLWws8TObmmqqgXNomVkWgmIFSHdMem21g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "6.0.36";
        hash = "sha512-ADrfJxNefOr1UwTwblK9R+zbwgj1U79y3DFUemrjfInsM0YW5B1r/bEumz0UDeYmwkRvMbwgtBNyLEGg0d1kwQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.36";
        hash = "sha512-cKF0mL4WOq5RnrfKNynpo3Nnjcbq5gz0yJEuJuvJMi9UILvBe1R2YKY4pgsQSMPMkZlukq1pjKQz1R8PLVewuw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "6.0.36";
        hash = "sha512-dpxFo7/E7fSsPuX9XOvN365fBjwzisqWmpRu8RJC3hT/VBWkwIlmVm/r+xFlPFDvimlSwNFsbSkRLX+1YIcEMA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.36";
        hash = "sha512-nuzHFGpbwv2owK6F/uJuj0m70BAG1NAj+ANbHyt7VKCktSI1bXLi/Fn6/7xiB7scXLcdMC6ay5cZrAlC6kSUDQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.36";
        hash = "sha512-6myLyhUePahDenH3ew+QXNkBjBWjIs5vKI34OqGlE6Yqg+MiG9G6WkC/UnNX539C/ymgDapWqmucLUq4zUX2HA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "6.0.36";
        hash = "sha512-05QcCR4RZ4ntU+Epf8Pj+6Jk0hPYtOwsw7YE0pn1TsGKA9F2eodaXyhh8Ppyq8nrnI6DqxIiNrVJX+JFPhTfZQ==";
      })
    ];
  };

in
rec {
  release_6_0 = "6.0.36";

  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.36";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5a1d54ad-f01e-4407-a413-493a5e81f802/9773a2ed4499d6d8c2a89714aa3d9c4c/aspnetcore-runtime-6.0.36-linux-arm.tar.gz";
        hash = "sha512-UYbGVPvWSa8HYL+zvikyjfKA4E8hKMUxV+bFUNBrMZcKUIrCXMA4yeGxKdwqPAAlmXOcj63TgcuIj2q70YjOXA==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/19bb2019-9acc-4c85-a397-5c84aad3e79e/094076519c27db7d2619aee8744c9eaf/aspnetcore-runtime-6.0.36-linux-arm64.tar.gz";
        hash = "sha512-Kmot3nujru6RRWhu4y8ZAaeqYjiug5XqO61Rdw4icGknK+g5WbcR0jghDDd7ZmYePPA5ll8Bm1jNRMCKmCQEog==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6f4d628c-903a-4c54-8e78-584ac3fad3e9/35c386c099e48775ba50df7bb3dfd93a/aspnetcore-runtime-6.0.36-linux-x64.tar.gz";
        hash = "sha512-Dj0dzHFb/7y4q4y0/XKsy+7XmsQLf9UXlheXoWj0MBUFBE0sFJSkmw5oEDlAvWwXjIrnus919LQM6CzIViT2vQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e2fbcaba-7da0-4d87-bb1b-0b78e53a9d86/9c695640f542279269b0ddf23c27060e/aspnetcore-runtime-6.0.36-linux-musl-arm.tar.gz";
        hash = "sha512-D3cnNayscljCr0pnyIHVr6wvhB+atpGga6HjSr2B1YMdCf6IhuAl99H76Eoek0FfuONVEcS7mI3ZTLgjwY0AeA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/52842791-2dea-4278-86c7-4f1d4a45c0e0/87ef463f7e608b9d239066f02d09098f/aspnetcore-runtime-6.0.36-linux-musl-arm64.tar.gz";
        hash = "sha512-zz28aHrNJyIFYLr1LVLdQvR3Pd1kJIeuhOeimKww2WQK+GzQxe4o7NA2SzWJIZTb39HfMCRRNn10csO9ACAvJg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2fc024a5-bb7a-4860-a38a-89248a6466f2/95ce83467434e681a3bd771052ffbb91/aspnetcore-runtime-6.0.36-linux-musl-x64.tar.gz";
        hash = "sha512-GNM99Ai34h/L2o4cbWfnRaN0Bi0ZVGeoJgMtpnl4T7MLVf2tLedUl90OkXshPXiM6z8bNIEnbibhA/mRx1U6kw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2271afcd-e427-478e-af95-bea3ef119bbb/4a4d713978ad045bca1ff93eb661611f/aspnetcore-runtime-6.0.36-osx-arm64.tar.gz";
        hash = "sha512-w7Vp9gCgL7NUyFFnXV0/0m0/h1n+mp9Ffym4MWxa5PtHSE81S5oV81CMlWHP3zbb34r5kUTjEDotnVhYG34CSg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/daee4540-b60b-478e-8ffc-37c8798ed6bb/85267ac81195d92e6f1045e84e8a3baa/aspnetcore-runtime-6.0.36-osx-x64.tar.gz";
        hash = "sha512-ijtzt1xboD7gJZIWOYJ4Bblbbl5ckgxUT5Z2m8BONvS1xIB7QP7AwdbRqCka+vb14a5ejaiR1a2R+O5IQe+Pgw==";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.36";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/bab6b400-38f6-485a-8ca2-a2039d7b699a/87ae685d9df812b27be2af8b05ae27eb/dotnet-runtime-6.0.36-linux-arm.tar.gz";
        hash = "sha512-8/kZmpfbgdPj7SSeDpuPF6+3hei5660AAWV2OC09DyApox6vdgviUJ/eeWpC7+tyexVkiKQvSMwIAT+HR5ys/Q==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5aa79fd1-fac6-445f-9e68-003a0d368656/f21c1d45e64633019645d164cc53cf5b/dotnet-runtime-6.0.36-linux-arm64.tar.gz";
        hash = "sha512-qpo18YEgQZmsbESGPEdz+JZ7Ja3OIY4jzigitAsmw47cHk4v8yPau4GuBJvBh/FNIJ7xNl5olw/WwyryHwodRA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d0d7fabb-4221-441a-84ae-e94f59c8ab42/a7cd6251bd8ce5fac4baa1c057e4c5ed/dotnet-runtime-6.0.36-linux-x64.tar.gz";
        hash = "sha512-r7YBj8q+xGjM164vETHYyd5/TedkW48MIj77vb/cUV+wZCo5nr/jcsAgREFsTK5GPJyALNFWudpBge//DjPulA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/1befe57f-0495-47e1-b6d0-810c47dbd777/c15062a1d53a086e49994356647f99f0/dotnet-runtime-6.0.36-linux-musl-arm.tar.gz";
        hash = "sha512-PdU5gWQF7C2Bj2EafLmP5AaZYOisRmTMygT/iy4GeTh7Cj8sxQRb75VldiasEEW+3E5QLaME7lRnivu+g9zDsw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b03f2676-0841-4585-b18a-73c763ea6e08/f392aa52226cb0de2f5e2402af0b5a70/dotnet-runtime-6.0.36-linux-musl-arm64.tar.gz";
        hash = "sha512-CDBxVRGrYCJCSHxfrg3HpbdeDJ13BeYkGB7BPMRyagbXk135Uq7d2g3CxG25WrFK+dgimiMCsebS/X6JK0Imew==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/9509eac8-2788-4fee-912c-edbcc9a87c40/e8073d775d1c6be5006aeba81b024b18/dotnet-runtime-6.0.36-linux-musl-x64.tar.gz";
        hash = "sha512-VsIWHFKQFwb9dp0skWjP9ZWVdr0actiffCeFj0Z/WZcGJOqaBVk2hGK8F458nvfYbQ/aCMfb23LdPpCEKAgj6w==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/fa2cef0a-6107-4aeb-9a45-a06a0329d56c/b9d386983e3f1d7570026645d9b7158a/dotnet-runtime-6.0.36-osx-arm64.tar.gz";
        hash = "sha512-0T+gYCcMN2MHxwhtpSz/caAvhVCjohgS4lEnMIlwyZoy08SDTjQvIzZYaWAMC1H84DI2kG4T/nZFb8eJZMUx1A==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4aab6108-c6f0-4b7a-b1b0-37f6b0fa621c/122b1b42895150267dbba61df69a2455/dotnet-runtime-6.0.36-osx-x64.tar.gz";
        hash = "sha512-gSGpise8k2B0wuuCqkXa4bqHRciAiHD/tAAwKiZ99xv685Tlxic61sei7ECHQKs2mgOsgK/y1JYhrhMfdJCtUA==";
      };
    };
  };

  sdk_6_0_4xx = buildNetSdk {
    version = "6.0.428";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e1f1b444-2b24-4ba6-a1a2-f669f6710127/45371782a57b927e6dcccdb02b04d763/dotnet-sdk-6.0.428-linux-arm.tar.gz";
        hash = "sha512-x1GIHdJ+8JhCjmFrmanBbov4JSZIT3aYfawe/LUXdTR0nI+UP22dqsw6kbsIbJy5yNU1yYgcC+PcGcZHBllo/g==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/63915342-f75e-45b9-87c6-26191463df72/60c45022a869da1ad03b8522b0c6a7bd/dotnet-sdk-6.0.428-linux-arm64.tar.gz";
        hash = "sha512-y4RUhl7Lmc5Ve9CldB09yEZXpF6gD5sqDwWT6U5OZh6JilaQ35DPAXW/WYKXPBmYWhaJmKqpdbesejvvLs0F0g==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/35b1b4d1-b8f4-4b5c-9ddf-e64a846ee50b/93cc198f1c48fe5c4853bd937226f570/dotnet-sdk-6.0.428-linux-x64.tar.gz";
        hash = "sha512-BDlfmRq1DkdVzhrlPiNZKnQgtxuCFgiDuuMZTdHf1dyu14dD5OC03VHqQ8SeyEtWQ2MHB7OFTxRxJl3JhJDS+Q==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/83abc3b2-9067-4e7f-ac36-7959f99d65c5/58aa206003f1154d89330807e01abcdf/dotnet-sdk-6.0.428-linux-musl-arm.tar.gz";
        hash = "sha512-7IKDms8S0mxo9l36/JRlBosj/vUJ0yA+fUkOdwGiH93hq2W8mCcrU50UB0s6IGaK1yrVIUiSH2HBwi5/IGhTGQ==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/02a81002-95b0-4d9f-a793-7746721af662/4499ab2facb3bcd4b69afbb9d8c499b2/dotnet-sdk-6.0.428-linux-musl-arm64.tar.gz";
        hash = "sha512-Vq5UgLEIhmSarEu57x7kpXAWOEg/Nmt9T0MQiDjdnfjgGZIyGW2uHdUAx74+F1zm3iZBodLgeN4tEGzLRDQsJw==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4e413418-c590-43c6-8c40-da0dcf4a3b19/7fb8338dd6c4d7a9ea109f7cc855a953/dotnet-sdk-6.0.428-linux-musl-x64.tar.gz";
        hash = "sha512-9XEj0UZcywoVM7UdCZXFE6vrD/wVeIv/ivQUTg3TCiZZ20G9KvQyitY3WIFW4uZJoFGCR+79+JQkA5OUZlYXhg==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d1157cf9-cf63-429f-b454-b1b46d467bae/05c67926367cca5194a838421c6a9e37/dotnet-sdk-6.0.428-osx-arm64.tar.gz";
        hash = "sha512-tg50tW78W9sFvpyVS8pv3bxrqnkhOxIP2APHUlLFTPSm9FJVtTLBjOroxMHCpg0nAjCRVvmrFDa9cfaJR8NyFQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/fb84beda-bcd0-4e87-a732-f51c98d58a85/f0e0bea82ed83e307a56f4cf2aa496fa/dotnet-sdk-6.0.428-osx-x64.tar.gz";
        hash = "sha512-/9bTQsxwDK1P6P1qKYltVfi9f2h/XC75rmhEnDwc7kiX0jGFBQdbqyqSU44NuGBd8TVZkj2GHZEjulnF+w5b0g==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_6_0;
    aspnetcore = aspnetcore_6_0;
  };

  sdk_6_0_1xx = buildNetSdk {
    version = "6.0.136";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6e0841de-3911-402e-8340-171026626dc9/8655b8901d68e0e961c8d8fcc470b08c/dotnet-sdk-6.0.136-linux-arm.tar.gz";
        hash = "sha512-9OX+Kr1HXCLtSExZSA62DXqCZm+bcaTKNauwgk22N5Aar2Kn3v9Q5mnZ5g+AC4JzlsWxu6spsglFWRQ5bAemRw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4f4db241-7548-48a8-b28c-bcc18a257518/4e183425102461b9a6749ae2dc3626b1/dotnet-sdk-6.0.136-linux-arm64.tar.gz";
        hash = "sha512-UWgk2Ccq3mcPzC3Q7jMVSgBzi17qst4VMu4+BSn2cKblswpVQjrnXwK9SquadSZL3ez3Nb4DBdO35/tml+yPFw==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/1a13a47c-87b6-4a2f-a91e-b74e6a6edddd/c046ae1b8352733c5184797cbf8a3739/dotnet-sdk-6.0.136-linux-x64.tar.gz";
        hash = "sha512-v51aSoho9oBufEorE9CB/JwKFHW1J1HKIRvIX6ogA/v2PmWOEViRH/H+Jf46q2keWiGBsU2pGckRT/3LmzyQvg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/de3eef37-e90f-4b30-90f7-5769834ceed3/b122c8eaf09a128299c8a7ea0c2dbe55/dotnet-sdk-6.0.136-linux-musl-arm.tar.gz";
        hash = "sha512-7bphsvCisolGpuOJE5sWgJHbkiCqdoExD7k3JB9gIg4TdD6NabHuY7hVBLEhVL0z/CushX4Ww7qeeuI6DTNrPg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/dc0bc4ec-c584-46cc-8f35-a1868f71b0dc/3271ad62955e098403bf5494e606c712/dotnet-sdk-6.0.136-linux-musl-arm64.tar.gz";
        hash = "sha512-LMtOWPnfoKCdzhaHpgrkkRz4yGSr/H1jzcETvSKKJT+VRdaZ6HCdFAP/KM58+NsJNeR5awWwqoDu9q5D04uFNw==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/93d00c94-9563-4e96-958e-2c0fef32ba85/7e74e55e727fffd5df6af22bf9050e41/dotnet-sdk-6.0.136-linux-musl-x64.tar.gz";
        hash = "sha512-qTuoRlAXB4CMa46lGqdj+vgswhUyWqMQqgXQhMrr0sQPdASLOEYkpzmIukGL9ypxtXiDwqBaCgh6ES0sJrQmbQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/86c26bfd-913d-4ab0-a2ab-ac71689fe7cb/f3fe4760bed2f23ca640bdb6d91a634f/dotnet-sdk-6.0.136-osx-arm64.tar.gz";
        hash = "sha512-WDHdExldgFswDls1vdipJdX1PxElIq1BjMiwdTplBiaScxUyHM2QJH31JYJhInEldpjBTlLybRsyFmiHMMAXBA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ff5a3bd6-c252-48d9-b5d4-184ab0e7f1fb/d62375e8ca68b829724f04809951a478/dotnet-sdk-6.0.136-osx-x64.tar.gz";
        hash = "sha512-oPx4hnx69+O37NHTeoWKLfljJ+8AWseGU3oZQD+wElGrERAjGWcLGedrNjaj/Qjl6gEzlkPQagROF1LRPvLK2w==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_6_0;
    aspnetcore = aspnetcore_6_0;
  };

  sdk_6_0 = sdk_6_0_4xx;
}
