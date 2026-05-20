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
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.7";
      hash = "sha512-eqf4OnhoDCh9ecBVgRjfbLtx8gFU2Am8YFn4vG9fJS+bwtmDgH0/o2q5KjDYhnCcODoHtDGFDz+rjx+6wKgf+w==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.7";
        hash = "sha512-V+7DGnggco8KCXGdsNsBk6FXpKrumk6P9gg3U4Bq/NCMXRQnw1lK1P/CRVGxnhSpU4ZPRAPiwJ19wYZUpfoSqQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "10.0.7";
        hash = "sha512-5hEJzxoaGfmMLEDP34Utk8nw+TkQwdZxvRvKhCzLqUkSzSy97zYL+r8m0odYJQfYQlzo/a7XQC8kbytBTR7zog==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "10.0.7";
        hash = "sha512-aW/H2xNs94aCu2tjPzBRb1UTDfa7MYtzVZTGoUcGnIZA04BGK5k/uglZotkjbNzT3NhRoSqOACJ6S3tuo0GwpQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.7";
        hash = "sha512-w2KQmyqmJPhv2ad7D3zVMOEv4Tp4WvDOGpUYHRSiLLidxdLmG1FMxmST46FkctOCczVropUBoYLJ1aZ8AKyHJw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.7";
        hash = "sha512-f94tNt9buVP9R1WSdiip3knUTPhRDnF/PcMsvCO+31vKp0zRza31Z6zz0HhgEsqZWUq5+7rF4FiQHo1h4osNbA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "10.0.7";
        hash = "sha512-tjscPAetp1S5dRh0rYWvbgVlpDV5eRp/KnMedtpZPINVj0XJ8a89nubuM47CmjdMUVPbIhBcfHIimTu23TfO4Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "10.0.7";
        hash = "sha512-hQtF3X7a0UiM6rIdxAGWc4zPxxtv0m7sPd5lcb2Zsdv1Jgr9OR5058Ik9gPB87p/rNIQQul7gwk5UG1LnWv7iQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.7";
        hash = "sha512-iEOqzzRNCCpMGkj86R21xl5DerN6sJV0OGht/u6KYK3/jjhxNh5hBkS1xW0Ot7ePG0Q59sNuYTrpeLvj149YMQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.7";
        hash = "sha512-Udp1ZVPMueL98kMWR/G8jA2ZZMtuwyiHJs3LSqEuM90SsT0zbo7khwWGpCDmzKpZEnjVmNGmP7wkk4fDySieIQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "10.0.7";
        hash = "sha512-t8kKvjnQcudWAFAbRypHRamgKebtRAOal4xRWI7e9BVfJMvAblSuU0BQGIrX+zL+UUXsdWvU8M0SwX2ZHNpWxw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "10.0.7";
        hash = "sha512-jdoshphp3Y30JBsARnrLJ7KYgBNnc3+hXFUjMIn0f8e6/E6S5dQn6Kdwyw+BnKs1uGj3PhmUxyueYP258ili6Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.7";
        hash = "sha512-6GgEcFXNkY88K/ns7rXVfOoKg8IlesaUKpM69Rw5yFqFoSRqg16oyy51b0jXhJzPGTT608KCKD/UBaofpa9sNw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.7";
        hash = "sha512-ShMydyfpyAraILh3iCfCe7MUJoaAjxjYxEvNcMkKfnl+0YrjdZv0msq97k30q2XOpyhlvI4wx1UEmp0Ca6YVuw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "10.0.7";
        hash = "sha512-CraRb5zHtNgUtRhsUvpX5oHFEmLPVjWI1i6VSGDxn941t7byq/Mu09YCndhPnWwpAugl/6hNYdB720aDbqP+Og==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "10.0.7";
        hash = "sha512-eFkm8cQ6BeAXeGDWQZXh0Y9B/oLI72dQx2hY3rvrd0LMEQiW9yb8iPoAeHBumRfsxhF6SO6vBYPI5QuwTsvsFg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.7";
        hash = "sha512-v4fNH3zO6mJs4o7hhggzsmkRdlgQIjOM6dctVs++2wdeBI62R9jm7+NL4Mvv+5tlBPxHBNA+rgRXVei41P9PtQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.7";
        hash = "sha512-yvySI2llwH3C5SJu7nMPXdiMt9I8mE6yYe2o7uGRmLioYdavL8IWJTe0z+eHqUHBJNGTOecu4iXyewFyBnXRUQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.7";
        hash = "sha512-l/M0JFy+BqVl0Vmh/7XW/uStC5kcJxs20RQXrB9gty1/1+jeMPtNjPMxQhX4l8IpnvxJKxHrQwS4fmGxeVLckw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.7";
        hash = "sha512-AYjtoZuLypZi04ufOeo3Enf4auCuTh/O+tf3lYAcf9d5aK85eIHXteObsgf3+bzRgVV9Q8ZrNZqGzmo4ET6RrA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.7";
        hash = "sha512-6M5WLHEgbkwRgIrVTNCiyKRZEXG6NdSpMHE6a3Eyta9dfnwORtTug/qFc/i0lHzKo7kcD/qSa0n8bIwvVi8alA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.7";
        hash = "sha512-qIDf88Gn7X3DyHFa8aoBvKjCyzS1DjIUbcYkTUTkNiOm0Wjbx4y1LWIhkQBbLIRyZYXtRllnVef2lp6lXC1DcQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.7";
        hash = "sha512-fG6yfTwqumXfgFem0ohTTMhaR4wu8GF/ZAQFxoPJckD254ybGLTrBM8F+/SXjjvZD+fezVIippCtU7vbIucztw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.7";
        hash = "sha512-X+dsme3aKiRQA4ZlmtziV0N/bjUZ/XNThRbHmfNy1eMQ+fhZX9nyh2qzgJlAFL8PajK/HdLDgT8kJgyGBla/Ow==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.7";
        hash = "sha512-TLSsnX75VsuNe/RSqRU4bk6vUVUXaVAxv7gV/qld13TUkHpsIe/6sOtke1mQDe6wW4IlQil9se5XbSxL6D3k9A==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.7";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.7";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.7/aspnetcore-runtime-10.0.7-linux-arm64.tar.gz";
        hash = "sha512-56F1ZBvs7i5t76l925YmHVMTfu1IXGL142eWC90LAS9xhVHSd+q+YG78/CJ1YB+6S0mekLpxu6sjxQ7/aI+fbw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.7/aspnetcore-runtime-10.0.7-linux-x64.tar.gz";
        hash = "sha512-N4ok+0MnJ14KRgOb03GbAtLWsce/Sw68q8TdbGWoGMiXeQuKC3+hcSsCHE3QqX+ZX+YDf6krLpCeQyZlAdbPGg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.7/aspnetcore-runtime-10.0.7-osx-arm64.tar.gz";
        hash = "sha512-LUUxf6ATVowrhTTJE/qh+vLBcQBfMLGi73YjOVsL1B1jo6Y4V4cq9YnZLKq0dFl8vAelqTIOSi/9VD0zvMX67g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.7/aspnetcore-runtime-10.0.7-osx-x64.tar.gz";
        hash = "sha512-QnAqJb5KWNoL3WRAa4GH82IqYmPpR46n0nGlK+GzUdyq0yG7s+2l5h/h6plA5bwq0CtKEM4ByR41O8H60g/cLg==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.7";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.7/dotnet-runtime-10.0.7-linux-arm64.tar.gz";
        hash = "sha512-f0ttF0ZTnhlBXKmoCOROHyaXx3ox88XmaH7T/E2ddMTJNnsfJoE9Xbg0dEP3wrA92yUQGtzfzNItgOJ5bxMb6Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.7/dotnet-runtime-10.0.7-linux-x64.tar.gz";
        hash = "sha512-cCOum1gDIlZsG+HcdxHMoNwY58iSGp3+RG3yeOX70S+F+c93rZd/rAoHKT2r0IeIFpNP0C2DFUWvn/XgeGpagw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.7/dotnet-runtime-10.0.7-osx-arm64.tar.gz";
        hash = "sha512-zyoEOAsTjQuLBXSbWTWM9Si/i+3XseoxRFfatdjlPfzxTraRXk8z/r0pSj+A7+t+jKh5Q/S8LDMSfChZuyn9fw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.7/dotnet-runtime-10.0.7-osx-x64.tar.gz";
        hash = "sha512-+hjhBy3r1VnMqd+347dTim5QZ0XLKPOwmotwrA9Mo0PorEc5wPnOShg5bfxEo1T6FcsDnvwcjtqS+l1jZoARQA==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.107";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.107/dotnet-sdk-10.0.107-linux-arm64.tar.gz";
        hash = "sha512-z17K1AeKJdO7cAa25J0ehhxx0l9hG2CaLR0yba6frnPfqgApC8BWJ2ltA7OVJjsSBSB99AAIIZ1I1WejUJK03g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.107/dotnet-sdk-10.0.107-linux-x64.tar.gz";
        hash = "sha512-qS7ZucgZAsVLXgX6EO/80yWXa6srCzq0EoiXIwVunIuDcUtOlWsA+NLuMWQxKHt0rzmIF6ZyXEBsYSFG0KwRag==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.107/dotnet-sdk-10.0.107-osx-arm64.tar.gz";
        hash = "sha512-2votp+d9cf0n+v+/dGJwK4fa+N/Zsxe6KKpljm8r6en9dpJRsUYisSEAV18ZUz/ld5BH4U21JYR2NlVmGyx/Ag==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.107/dotnet-sdk-10.0.107-osx-x64.tar.gz";
        hash = "sha512-d4ZRhVsewSjPbTB88l95nxPenws1cYJPBojkqrIbgZLM4vLd2AsgPZQHEuNeVs306HNHjr9O/2qn2OE5V7dddw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk = sdk_10_0;

  sdk_10_0 = sdk_10_0_1xx;
}
