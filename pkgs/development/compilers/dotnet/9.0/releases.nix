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
      version = "9.0.19";
      hash = "sha512-t6zARo3vNLSPDfh35hTvEfXyAN+5RoGMJ1Ug1cJbdA4rvi3VeXvsyKjVuLXNsqyK4QOCzG++ji7NlazuzNyL+w==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.19";
      hash = "sha512-VIgCECfY8cRFm3DAheMhPy4KbuB1Y5RLfSxPjbAJ/F7tVIy2BzXtOkm6iECgCG6R654Uvpvwzb+1cXK+qsuE5A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.19";
      hash = "sha512-eguPJDSJoVv1BHuw2YXvJonGDZc9Hp8aJOPONyFekpQJBz/St4i6hGqSYBiU2BOUd74JrCTM6J3bfGkuDpF8Jw==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.19";
      hash = "sha512-37FDUCoFQiFwmJ2cmuFxwIo0P0dxAHaAinaLq6+i6hTLUAPVsTU8srPr9X3BUuUQMoCda/YRebwS12z9HNtzYA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.19";
      hash = "sha512-/S++0Dv3rW4rPNY3JhGgj3r6W1F4HYoNZBlFh31ALGBLFLHHboWvo3rzHgBTqiaDcKa7SVcvnp6TBNXxNtAogQ==";
    })
  ];

  hostPackages = {
    linux-riscv64 = [ ];
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.19";
        hash = "sha512-j4uTlC9sxGT0i2BLfUph7O/2ZPEFSEE0mnD4sVy/blQ2JvQTTRPzIpQ0wPP3U+s6mv+Yixl0EqADpc+WUutWtg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.19";
        hash = "sha512-dmnFHlQBY+KOjyV743EpXggvy3Q3eNIXQjHps93CDSOl3YSKTHDffD42OPsQQtgNH3COpM1X0wPkSSw9vM/UXA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.19";
        hash = "sha512-8u4JuPheYykQB4lfvAijnvr/5hHfGzXVQzC90W/Sfs10TsPrx5m4PlWPhQHvxk510KBC82KzNW3zE75NBrCMqw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.19";
        hash = "sha512-MOYcKz3dVqC5wesWPI2QLszFvYODjk6shLRYCNsOe0sUdGfG66Jn6I8xZq4Ip+KmNr/9zkOEKlCYoN+8R5hzZA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.19";
        hash = "sha512-T7ZZVQrlscVYLhuOwLJxZB4lJ5+DI0RNcIadyC0JONfrak9QIVkzvdH5tYfGlmi3W0b9IndXxIW59He13gCgkA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.19";
        hash = "sha512-bQdY5UZrDyo5USmh7hP6Bm88W2WJKhki1Y/5n9GYAZguKaVnXU3OT/q00TQrDOe3+fF2ObKeAEw7htGbn1z+Rg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.19";
        hash = "sha512-CBHrWW6WF3kW8SUnfU+jg+brdX1DaqDxKgOYe17/MJdVJlkOSQhb+cmB8N7Oy4Dv2R2IQisFYpXKcnGlsuBeeg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.19";
        hash = "sha512-NtldKjsCIDG6TI3rMmL6IXZRutXlS9Cx1mCFbDD2J2xbOoxJXy6HXvWKsh57QA4AFgbSp/hBjEeYLET5tG2kcw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.19";
        hash = "sha512-91e7K+e/XVHrG9bt08G31tBE1aNdygaqsM3KbwigLbiPaAjgd9ggD5yYQ6P0caPCcQiHuBvZUoyfT3Df6edGYQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.19";
        hash = "sha512-OhFgwCfi99F4+irDWijyRd4PuIooy51cnCivFpYEg+BYbok3eu4GNngjodDAsqVWovAU9hDQsTXho7RDcJ9Obw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.19";
        hash = "sha512-0yXYdiWh/OM2uf7kvBYvL8+AlKugO8Y3l9JIj82FhTGn7y+ANeRXhWsf/FNo7KRgJqHhDhBczrOtSLbV6AQLJg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.19";
        hash = "sha512-A3ik27m5vB37lIl8ro4MIRLiYZ+IthOGAWAJemWyjhf+nhIc0DQx7npph44pIntlIIsZ/AVvIUtvFomyYsFYJQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.19";
        hash = "sha512-tauuqlFVV6ba4Kw7bg2u5kd5SwUBnyFZE+em8eSG1VkHDMc7AwX8KKqxVllKT+cPktgZZ2yWi6EZDx5c9t73rg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.19";
        hash = "sha512-T1/aLuSmsEzIlfooNuu40dJGwOIa7qEqZKsdmRGig97Fv4Gvp3IaWdpUQx5yaN6vbEQIM2lbGJSgaHR2J38Sjw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.19";
        hash = "sha512-5LeS3Hv39WI1txTRVGqYYRmRCa1i1vLhvv5kpzWlcn0P3Zcj3LUg+sRxJ3kmuMHM7D4UqEwknD5/DbmTxASjLQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.19";
        hash = "sha512-gyJEYBXjtuzKjUs6uamk4yK4D9nC23iOOU2wG5U/pDxVUHtyzvT7Sx0uv9mlhKcW6xAt2qJgevP3P3RtLasoHw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.19";
        hash = "sha512-e9r3koHW1AyFCPVCSGU8oGf3we9rPpGKb/PYe1naVjVAP8wU54aOnbv1+VnAZFYsRE4glwC8uQj98rpTi2NgEw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.19";
        hash = "sha512-Us4cjMJbRHvfX4Re2qxELmtUt6Q7v72rQcMEGqTd1zzUGQPKHbwnPMK8IjTsoognsyEghkI6kmMtIxGhv//9tw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.19";
        hash = "sha512-d1PFeX8f8RO2YrfMLpHjBlGfGbZrnC9MQ/brgEGct3B+mJt9n/9OUWZmIDGNbMroF78Lwj8JI7U8T9B0unX1aQ==";
      })
    ];
  };

  targetPackages = {
    linux-riscv64 = [ ];
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.19";
        hash = "sha512-AYDoEn+1TMAwr49O72sodxzcrU7VivGmtmz4RHHMIarqgmtvcIXa0KhDFFORydpkc4KC0SL64zh4fWPfBiTIVA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.19";
        hash = "sha512-2b5SPfOVl37Oelc5LBWgHL8wD5KzLSIOJ4ux/tyhENXNqZvzbgjEjo1nRv1Kc/XATsj7+ahDSggVf4r9TGsXtw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.19";
        hash = "sha512-PPwU6VD/s+LNqQWER0dEyQ7NLO1JUZbnav8XiyEjDcJjsds7V97L6ke+wSFhFnfZJ0/F+AG229TED0sXNRmW/g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.19";
        hash = "sha512-VLKjY1jBKQBmS+pnBFQ0TbvD6XeOGgx3S2oCiXHCJ8OJl8rDhtOzXBYGB9nNLIgOLMIrpDsowhIhy5lOpgkWPA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.19";
        hash = "sha512-3loojmtSv0EtMDJBVozjlkgdYcuhrjJpSDYzhhuRYKZVFdFSJLLKLBQYExowfjsiW8ZsrBTvkX0YIkyx06D/Lg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.19";
        hash = "sha512-/uvxo7Qbu/reolshrH6K+c5OjEitMYIrR373ZfbiHd1SNUPHAhlaTWVrmRm9HfxPeTkeCShEmoz5h2i7niQChA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.19";
        hash = "sha512-5jstu2nsPHvj37ncl8E2cwHssENJN1Pj6MpPGwYbvujg1MoXxCSOpR1DpEI9r6jJ9vrozddGHF2BhmmmK3EOXw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.19";
        hash = "sha512-RRsnRJ/4oeqi5ldOaluF2ootlHEqCquRbESnpdiL4gmndBci9Cr8ZYN9ACpewsuPUYT2XQg9A/BzYOupyKV38g==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.19";
        hash = "sha512-W1Gw86yp8FcpQ4qZfSYlDJwltAbw/0sCVhzlUhu2PumFuWyS+YHVO53s0hbITRsVtk+HrXg9vWMPFhHvozKscg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.19";
        hash = "sha512-JujO2hPrlwPWGZNnqbUx7gNc5uCuaBRN/35O4RuOAleB7asjqevLrzHJrY9smSnYesNTy+v/xJNbn8bKfK+aFw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.19";
        hash = "sha512-2l54uhHtenxylFaKBjxleM/Btb+66ayxdfHMIg4lTe3UUCZqIfDjxAXe04mkCKQAjtWGvRBxCCSXY+NMGGeOFg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.19";
        hash = "sha512-QbIDIx3O/O3GxhYsegHyk7jZaukNJPF05mp2JGgS5HL9SwtNSKZcJueR34+lD1xvmeCFcShJagWL0+593gYIJA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.19";
        hash = "sha512-gBJ62N9MbV7xuC3gojxEAg9L/WMvHPNJSPdnCtfNZsmC+sUAdfZlicxeuDU7bBaYpnUMqqQMS9AifFT4MdD2sA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.19";
        hash = "sha512-yvRqTMBZtym7ejTXGkpHnZ8pu69iqyvtlwneA45j2lBHVXp6uWrXa9sx2i/OL33P+9jE2bzh9WoKdjJGCEvN2g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.19";
        hash = "sha512-lnt+RlTr0JInweJiooQZI5foKje0K5TLl2DpxGUVjgApcEkPg1UhTHvCkp7d7gqqFp7n4QprmpwsWEqk/LIn+w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.19";
        hash = "sha512-fXwS0242oUBWjxJ0H6qgyHQdjShw5M+NhHqsJ7U1OZ8AwUbBgXXDJ4jGGWn7jB7UZvNfHZxO1GBT2wqri2XH1g==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.19";
        hash = "sha512-uVHVnKUjdsTXJs3MsiCZfmyc+kaG6kVg7ekEpnRChSMN9GYWNzRXgCalMenqNdGIisaHhlGoP4kSKLRCoBwoTQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.19";
        hash = "sha512-OY3mBijoX/22fXBsv7sPRsF7FYFPXbH/Vf0A0qd/IK0pnzkS7HlHL6hY3AB6Q8UyaJOW47ESymZXJata97NAMQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.19";
        hash = "sha512-RnPJDSyJaz1m9EQjahpvVoUzqkoUsZwgDwOn/kjdV3NxyoBRLIKWBL/SLqrxqWdxYQn4DytsUqN+se88VKtaBw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.19";
        hash = "sha512-1ty1SXgSBZEMMX9X1Mw73xT8QlA3CwSrsbbPf4WOBiLqQxgtCWs91bCeg3+Prt5wAvcPE3Q16rhNrGOR3/SnTQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.19";
        hash = "sha512-+rzAfE7A6mLJB0H76wTkBVu8lAgp2YmgtxUicDOkDYQswZtU3Zc6fwwOvm4UC1CIcfVw0TgsyCyr8gXavQWM7A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.19";
        hash = "sha512-/srn7Z5dps4dghf4n/ZxIkhaw49dpKrD8SYYx8nuerCkuJK3BvBScl2mhtG49chY4LXwCHsblP6NazVOGxYjLQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.19";
        hash = "sha512-TPj2zqcL+d9ING77zNETcOC9PAjRsHc2NkgvqW9yuCEWSgnaylbFqGwq/3mrCt0Qbchrnpd2ORw+tZQEYs5qpA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.19";
        hash = "sha512-T9DqFHU80xKCwojndeDkSnDCbNGT2M9qiMhxSuCm3UkeACBgdkp7wpieApGh86IcUF6NEmXzJhA3mndDOeKRCA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.19";
        hash = "sha512-anU2dnIwFzuXhreZW3yIGyljuhSM59H7uhd5mYbfaZTyoZpL73PkFxc8qr0E6FtHhqH/ezETqQ2ATs4LaIxQeA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.19";
        hash = "sha512-R/VfZBsR9FJ7lqlcWvqXIebwTXk1vsMZEaV1GHPDFXGizLuJsApbCANNgSw8eZ/NnNfsXJiYW9T4llEu6lr14w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.19";
        hash = "sha512-0u2vxJDYrEiEvi9IBKCsLSW/f4RQotsXoKFUilk344uS164asDqLiCVTezqn2h5bEF2BUAOJQG66zJbADAE9Jw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.19";
        hash = "sha512-4dfYAz2wthwrZFDdzYBXNSJNpDm7i4NcBTINRHE7nZ+VwOILoSPJu7KRo50beZXTfZ676fnFNfbwi8CwM4SgRw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.19";
        hash = "sha512-c4kOo36Q6lGUWfSfVXB1gbbsXRD6Bf4GRCljOz2Q+ry1FHb++UMVkEhLxX5PJxYe7zppbGskk1lO/NLEktdM3Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.19";
        hash = "sha512-ObJfk03VsWa+8vQCTtmWwJYglwK7r3PxmwJ4v5uevXVO1/Yhora4ZQTE5DmxwJD3/37U1PO4qerOXBmO+fXHlw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.19";
        hash = "sha512-nbNA0igYxayGb5DBh43SbV0C1TXQv4tAalqoVAItBNQVJQew0sSFvGb2CV0bonyts1VwRJPTAM60vtWJt/GVaw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.19";
        hash = "sha512-jxBnZ+B9D+D7GwBDn/x4+rXsy37KWmpgaJajsaF5MtZaas4XU0CGqymUbpWjZ+Pnmg3TguzTc+PpBrDB6zNaUg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.19";
        hash = "sha512-nUNdM/pe//MW1WSFNuok1ulhLcmU1mjZeWS8GdtDYXUVVLlrGf9cq5qun9TOLAwF42Gf9rkFDC3FG6lxMFbKXw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.19";
        hash = "sha512-oa7Zyjlhib4rcrFsSGkPguDMTohuU4Fuy97mc9SWm4aB7DBblavwZSwOpX03S8Tpx41IyyoqQTYpkvoPzDDmvw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.19";
        hash = "sha512-8/OfkeBCoCS81piCMI2DO7zq1DdwxHSkC9/84srxP1YWrKsBlynitu+2y8I6O2hvCl5nvOr4WVgADzQkq3D2rA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.19";
        hash = "sha512-AztMZFOFXgo+cNEc8gzSKcBNFFnKrDD0cBgtWHxwvagntFVyngD72TcerwSxMs2jfrRtBjWFSM7wObXmmtwlAg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.19";
        hash = "sha512-jiO/lAycc/QQOVnLGtGNn4KnfwSkh4Xq6Mmg+bOFKgXs9+JBdCwWV4t6xv4EKkd2BxNbE97mQfSHLwanQ92H7w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.19";
        hash = "sha512-tcsrbQ+jXsW/rcIbjKKOFptNdp/yS6CRtwcfzQYUhRlYacbcoGIIf3A5PxgKqlNtPNfSnXgGM6Me/3enSPNd9w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.19";
        hash = "sha512-28UvewngpxYfPa1xckieZdD9xff1hncu6gqYGAoDOazmysTuLmaHKKvtaKnFViqcml3/Xm4dfgQRzBJ3/Jv+PA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.19";
        hash = "sha512-rQ/SaXCK16WDegugoz6O1oZHj2JEBPJ1O3whGzPrxZ/Ms2v00TAsYnDpyqWFny8VYBkv/TvZ3jjz/xogdyIZrg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.19";
        hash = "sha512-YGMUXcGTNJMjybLVE1Ix/y9G28CelvqnyoubVvBHojVc1TxR4XCzVQuKmXMSIE8ZTZTim70pjQwyg0scMY9GVA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.19";
        hash = "sha512-1BqCHw+mOaEDNxmjp6pRHBnsNi0JmbVvkCnZT0SW+vH6gZX9IJ8FnhZrfWL7AqulUrnZjBk6YJ2wnrmQsCy+NA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.19";
        hash = "sha512-SVIg4X60utcrZ+8xLYcOk08psDtLLIllMWvegF3RPwmuc6R/v/lIZFtbGrRJt9EXf0E3Xmg4VJhBdYJ9rRYKKA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.19";
        hash = "sha512-s0g6z0Z2BZBvRQ2yZCtEAMwQNY5UXZJW9qnllQ6QPwR4B1Sw7F091AtO27M/f+Q8w1TI9quB4IyNcRl0thw7LQ==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.19";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.19";
    srcs = {
      linux-riscv64 = {
        url = "https://github.com/liberodark/dotnet_riscv/releases/download/9.0.120/dotnet-sdk-9.0.120-linux-riscv64.tar.gz";
        hash = "sha512-qbSFjTAQMOPKCla5J3jTVzqmpWWXoWIUWkTphzgE1chO9sk9+GMhYtenWF2V35U7UrwKOa/qPcc538XAYHyrpg==";
      };
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.19/aspnetcore-runtime-9.0.19-linux-arm.tar.gz";
        hash = "sha512-JB8TWsTOuOuLLRNfWY+NHrvoOSfiPD8Q5MgFlc32cll29/cC8pIOTcbIPaikOugHjrCPPCuMtxqqNbDxodsgRw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.19/aspnetcore-runtime-9.0.19-linux-arm64.tar.gz";
        hash = "sha512-PHFqdI3gjES0ddin4u+Jc9jTMP6jHQdmiCY8IJxkkxjDlvjkd5tbwa4hdve2I5haDaF3u1AmXacixztq6/f66w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.19/aspnetcore-runtime-9.0.19-linux-x64.tar.gz";
        hash = "sha512-V583wq+Nvo9+PvKUwC/PbOJkn8NKuo+OrQh6m9eUQDqIUgefwPHFy+W6ujN+a5mUeGZ/7Q8F++D7j7pwZh92CA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.19/aspnetcore-runtime-9.0.19-linux-musl-arm.tar.gz";
        hash = "sha512-C9rBbRAj7oKN/ifbZHcB6AqiX6590+X3kza247561hN1RLY+P6CjPQFJQNc45xDo89vj2Ol0vSDjlmp6qJ4EnQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.19/aspnetcore-runtime-9.0.19-linux-musl-arm64.tar.gz";
        hash = "sha512-U9PY2COXF8sEcFTwQ4BFIWvoBXBNw7omK+p0ol0kSn9KeZcfPTAQP08pLqzbtB6hgmxwKGzSjNPdCJOAjJTloQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.19/aspnetcore-runtime-9.0.19-linux-musl-x64.tar.gz";
        hash = "sha512-C+JlZ/BGBt06AjoGZYetWx9JgzWr46FLP4GHuby85v4+jMYDBLoEPyUtER4hWPRkYv0+R8N2FEQtdsPL2HCQmg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.19/aspnetcore-runtime-9.0.19-osx-arm64.tar.gz";
        hash = "sha512-GxBe0pPJ9OZS6qxsiSK2A5QeZczCZJfHNQJr5ECzR1s0I314GqxiL7OTYQzh6IPpNuvLQT9VCtECtlsW4N7gvg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.19/aspnetcore-runtime-9.0.19-osx-x64.tar.gz";
        hash = "sha512-uxeTOiABRPjPCngBAH0mtM0V0xa+u6qAvLTJf28HmOYK+MHymIVPr51NMIrS8KBLZydXfvc/ghDO8yGmXJIlZA==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.19";
    srcs = {
      linux-riscv64 = {
        url = "https://github.com/liberodark/dotnet_riscv/releases/download/9.0.120/dotnet-sdk-9.0.120-linux-riscv64.tar.gz";
        hash = "sha512-qbSFjTAQMOPKCla5J3jTVzqmpWWXoWIUWkTphzgE1chO9sk9+GMhYtenWF2V35U7UrwKOa/qPcc538XAYHyrpg==";
      };
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.19/dotnet-runtime-9.0.19-linux-arm.tar.gz";
        hash = "sha512-lHne1saaCRY1mdK1+1X28u+4lii2+4qq9riCpzkfBlpTc5N4HwzW3Vo4AmkKWnRnjU5piqnhHj2uhwBKKs/NWg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.19/dotnet-runtime-9.0.19-linux-arm64.tar.gz";
        hash = "sha512-4HUQxkn+3z+xPdIQJvNMi80X9Upo5MBxoSh9JuEH4J2czRPvD2PGMNMJuLeXMQqNxCrtalUesUXZ+thqWBmk7g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.19/dotnet-runtime-9.0.19-linux-x64.tar.gz";
        hash = "sha512-5/ypxafvoufa1rpgFQnGhO9Gcn46sfClGjddDf8m+gbwAe7IggM900pqEEl68w8A/wAGbBZeALHhPX2i3PXUQQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.19/dotnet-runtime-9.0.19-linux-musl-arm.tar.gz";
        hash = "sha512-fwAUGM/Rb6GOeqvKvRXBEWM4r6V0LHhBXRcR5mce/3kCj1Yq6La2GNmy/82w21o63WszlcYPAWEOMghmjCHPvg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.19/dotnet-runtime-9.0.19-linux-musl-arm64.tar.gz";
        hash = "sha512-y79Y6+AK3S3SX1h5gKQ8mHFDC2bogJQzqm3wulpdFxu+fx2QUvTkcs2+B9gcb5YQy6FqugrQcOu4vA3qTeFrBg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.19/dotnet-runtime-9.0.19-linux-musl-x64.tar.gz";
        hash = "sha512-O0W0BoFf7TtAzpNZoo4uo189AUSTfG+slaOq96OA2x53i3gSTFKJqRTjgt15p2pB90IkOfEsNR95XDqOQ6QExg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.19/dotnet-runtime-9.0.19-osx-arm64.tar.gz";
        hash = "sha512-b/ZoOHtaJihAiHa3TkklsO5xTz26P8eVHS0/sPypaYarzzYTpikQMZ6EV/Z0zU3dLqWp5yJgDtUdxVGBMKDBhQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.19/dotnet-runtime-9.0.19-osx-x64.tar.gz";
        hash = "sha512-nMSr4ouXd+BzqHvYyjxGFzZPO6kS0O6hHGEFs/woQbDowbjDEb3VUFP7ohZKa3EeJouvfW8+qwtQupjg9HCUyg==";
      };
    };
  };

  sdk_9_0_3xx = buildNetSdk {
    version = "9.0.317";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.317/dotnet-sdk-9.0.317-linux-arm.tar.gz";
        hash = "sha512-z5936W+nJ8SR1GLc7OaEqgsNLM1GIzj9QYBq8s/nmvolJx708eSm5G4jkoQ5QMBTE2bEz133QSZ4+HoiBg2Pyw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.317/dotnet-sdk-9.0.317-linux-arm64.tar.gz";
        hash = "sha512-/fMP5wXJEwTYkBFelV9zgFX4wIheqYkeffEVMyESD6LDi2rk3RMvhxy4+swNH6u9KyXd1T0KW0KTqoXSluO5jQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.317/dotnet-sdk-9.0.317-linux-x64.tar.gz";
        hash = "sha512-FFv2ncuIxLkF/rUxz914lKdfyHXSoDDpWKE9H7ETFSHIzr2Kim4PvRpDPrrpzehjVratrQexrYHvuSs2/4ozMw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.317/dotnet-sdk-9.0.317-linux-musl-arm.tar.gz";
        hash = "sha512-WNV1qWNkSyGYcKzsz5Y0kF3opwgGq4guQsCsKoK67KjWJhWMLDS2vj8sYJ/qzz0hUGbwM27e2A4A7rQnDW22UQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.317/dotnet-sdk-9.0.317-linux-musl-arm64.tar.gz";
        hash = "sha512-5M7Xi6AwnfYMkT4lAT69wzJGWyThGzkiiLhUOOdUDvWAElMcBiFveIGRUH/4FIsI/7zTKjg8O651TIB/WvLpIw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.317/dotnet-sdk-9.0.317-linux-musl-x64.tar.gz";
        hash = "sha512-c+bcdP15GZMLOnALLpQs7+4CJlhNT0yZPdT+KcI8b2gLf6SvxyNjEy+VIh942lPskRRmucJDxHfQBZQkWPfxww==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.317/dotnet-sdk-9.0.317-osx-arm64.tar.gz";
        hash = "sha512-9wehxz6ExtAJuqsqJ0JwvRG7tYzYJEz1lZT+FmL1AiXRZlh4069OS5ZJtv7M2VtpPPnPKOEndCt6TmKHyqPrKg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.317/dotnet-sdk-9.0.317-osx-x64.tar.gz";
        hash = "sha512-bdyGF6TMo3/+A/S5SC9cc/RcsGsa+iYit7wTqHCnhp7imNmvjkCCLL+I6Qh8PDxdINGCzUgdCc2DFl7Z2A36EQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.120";
    srcs = {
      linux-riscv64 = {
        url = "https://github.com/liberodark/dotnet_riscv/releases/download/9.0.120/dotnet-sdk-9.0.120-linux-riscv64.tar.gz";
        hash = "sha512-qbSFjTAQMOPKCla5J3jTVzqmpWWXoWIUWkTphzgE1chO9sk9+GMhYtenWF2V35U7UrwKOa/qPcc538XAYHyrpg==";
      };
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.120/dotnet-sdk-9.0.120-linux-arm.tar.gz";
        hash = "sha512-xOkQu0a7qzVyCTJQcCm8h9ibcEu65PCzxIRNeBHRsWtg45tNX6InLRTLEIQceZkMQ3YqO2kNlf4e/i3Xd+5acA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.120/dotnet-sdk-9.0.120-linux-arm64.tar.gz";
        hash = "sha512-g1sprrI6Gmn436+Pg6s1u5Lk5km1bsS3NA7KII2DVzHzrbyBD57/zYdPCGBK10nAWGuWhsFWP5pDv8qGSZ52xQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.120/dotnet-sdk-9.0.120-linux-x64.tar.gz";
        hash = "sha512-3D/iTpTyMWdfh0G4MxrlrVv9UAiBaFmummHAjTOMYN8CuuuXbxe4NVjAeNWNpVVPW6xT9M33k52MNN3wom9Wpw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.120/dotnet-sdk-9.0.120-linux-musl-arm.tar.gz";
        hash = "sha512-i5xuIOrgyeBRjcbXGWN9i5DpS7oGr//BuTg2cThfmnNoke3Eq/gf+nHTJz0CtcqjbvLNIk17DtRQb7GUS8uAtg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.120/dotnet-sdk-9.0.120-linux-musl-arm64.tar.gz";
        hash = "sha512-kP9G5ei/BbCueu8xsaoI8TxaCKHci1nnVLrhTEu8EfASZavpvTBdCCtTVdOAHQRVyroICAB6jkZPnCqVO8hsRA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.120/dotnet-sdk-9.0.120-linux-musl-x64.tar.gz";
        hash = "sha512-rjHvSqb6obISJ8+UVGRUanQCcnutmeip8IYMJTDTRZmkxHD/I9pSlh1v/wfVcptTwYzZ9ABJ+w7SfKBjC0SVYA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.120/dotnet-sdk-9.0.120-osx-arm64.tar.gz";
        hash = "sha512-D5UYB1+w+qejxYNjWCMUL3aKzbNzQk+3lHv9WqfJlC7ns9V1u1dRLqqhSTFjUm7CrnINPLQYmk5jST84c4lWmA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.120/dotnet-sdk-9.0.120-osx-x64.tar.gz";
        hash = "sha512-qdldUcpAAQSrpEKjRf+BuCrSbjQaUBstGrczIQegwqzT0NjmHv5Fewm0VVK0sZVhJZalrmtfbY21i8VGldjs2Q==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_3xx;
}
