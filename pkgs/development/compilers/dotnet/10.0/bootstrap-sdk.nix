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
      version = "10.0.9";
      hash = "sha512-FeXZfSx/RVXiooaWdkmd9g8TGAKC+MeC5IBByPf2FgTgR+NAXLMTgfHgimM6T4iV40+s2tzFXM/7RKYLZKZjHA==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.9";
        hash = "sha512-eAjWxz37AwAM+IymkxgtQbYRHNCK88jbwXcQUhJoOYQy080h/lHyH+A2O+gu2Wb4+foZqmXcThlsWPrQrk+THg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "10.0.9";
        hash = "sha512-ydxIUugIJrJd67MkCnk8th2vpRAps2GjM5JPEahHfl8q4/+0jZtDdIm0aoGV+p5t2hkuTa5uOCPPySbZsIEyFg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "10.0.9";
        hash = "sha512-YuncA5U2y36f4EY8Vn2rZPFpIsM4gsN75pFh9Un2ELiq40H/R8wJxGZB1fosfGLuW2+fXk8tncxnb+MjkoTVkw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.9";
        hash = "sha512-29MiMOG0miPFyEbQm9EHeOWamADuOeMoFEItX+xT45xpmY/A1PiO6NwDqPofmM68C02AT85afa7K6V1SU2bgBw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.9";
        hash = "sha512-fNUUigQviEk7mhhouQiyAtUBYHJ9UVZlZCIi78JLOQKoIih5QLmgJqja6oKljm3i1f+Z/y7luIkMSluXYrICnQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "10.0.9";
        hash = "sha512-16E69qQlUfII4Okk0egIUMOhl75WJ+tipQoMNNdC8DSnQydPGxhqxj8SJ05k79KUcLf6mHxGEVU1jL53h/E5pg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "10.0.9";
        hash = "sha512-3AYaNMQAJ0fmEgdocsXQpY2qr7wF+iFpxXMaL3lnysIhnwlrt5us+RQ7lCRAJHbIGZd90tG2+bzIVmVJTpASng==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.9";
        hash = "sha512-Pzm4bl66t2VJJaWCnAnOuVM5pO2fYo5xNIKiW/XAbaR1iU2VY92LaxmQz9cQvJi5qbJqlklWpVskITiZ9vPcnw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.9";
        hash = "sha512-jDdX9SxVfU/96Xn9YXXWIBKkOBFYzkToLF6s81PxXP5oqQgkAbT7tvN4sQPBgfM3Vn8+z5oOSYmnGijlBAQHwQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "10.0.9";
        hash = "sha512-bWhsJQS/Re61rantKtsMqsuUlX1Fge6VVB+VpVQg+LHipi1iAEi9TIvdDvuXa8XaPp6Yltpaff9IsdzrpeCd1Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "10.0.9";
        hash = "sha512-BmfmOts6Nl7PXc8dXaBxaooFDSVOLGkWVVKnN5ZEEwD9In4aZy2j4YP5K6wBOX7QVWoUltLDYvQ6ARBYi4obag==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.9";
        hash = "sha512-O/lQAy5vxO1I5DForGqGneP+taWU1BQNEQw/xE8sAVHdSUJTIeYH3Cj4198Bh0eKHvpHpaySoLYJT3lIEvgi3Q==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.9";
        hash = "sha512-IhxLam7sHBOfcfC9ewSV6nEwn4IxZeUQ2CeTkRgMvKlSR7XyNTe2QPgQ6n/XFnJoaM/kTDI34XWAlp99KgoEOA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "10.0.9";
        hash = "sha512-DE/2R39sO1np2BAIrKlbJPqu87HWQfJK7yItam89nn/NggOjUWvxRvgH2u04Vv5PmotEQcdtMAtUKNpoioFAsg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "10.0.9";
        hash = "sha512-vWvyBr0vgLuQjyoYViWytGYAMVBpOMgp6aYkZI1CkXK/LHbSadKLkfOVOPgsyc6ZeBXWsE55uqqfKikvRvy71Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.9";
        hash = "sha512-SX39Owpp/L/kKsNkKLkU/V5ylnocuqGLxOpfKKtMj8pybKfrIb6ZZyXcw5hK9b9RXPpvneA5M+d1A0NSiuovhw==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.9";
        hash = "sha512-kJiXbxRjkAjazH+ctmkM4WysXgpMR99Ps2hN2oI8WOJ9kkA700BLmNS2mAlNoAVrRGFOfgkrQ7m/XeCj3Xx4ew==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.9";
        hash = "sha512-KKHaaWDeoezXsj1BeLwxM69GZKE6aFwv81N966STiG2RjkCKb1EMevUk77k0inrgtUDEWYZGdEiZyeS7mK68Tg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.9";
        hash = "sha512-o7SZ4gPlt0o+A4RnNRCjWM1zonHw5fJDr9wHT0qHyUD+56vkztBh9WG3+Sv3Xexrq7lzNquNcQutQgICPM8Z7Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.9";
        hash = "sha512-mp5LNTyV+/6HhOF/TpLSb80GT1QXSjTcJGopjdDnpVHEwg6Y1jrNpO4ql1qWTI5GdqajHpFH1JkKNrhsrf5VeA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.9";
        hash = "sha512-uJTCSZo0796fS55rgWDj9iU8t3qaFC1JGi8W4PpegDogbfiOLafh86UFqbsimo+TeMJvhS2qRB6H5HI83TQV7Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.9";
        hash = "sha512-MAiK8UM5rnWWls1js5dFtuGfCg8BYjq0wn+954v0tiub3SoBAhSVF778JOFCXeSqAAyNxABHIVcQO4k64WxUWg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.9";
        hash = "sha512-4xi/0rYDHw7BTTNG5qFG1t+j0yJgKapNAnqVU6CITNSntp9YSmowpbHCEDt3R2SQKwv+13UiLTEqa9oXY1iUeg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.9";
        hash = "sha512-lgsdY20SoOhAg6cMvoT5jArQ1ojaTxbbglhoMkvlcs9iF9OD/4WQ5pFD5IU22AHF2L1VOHvEqFpMDaXe2sdoBA==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.9";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.9";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.9/aspnetcore-runtime-10.0.9-linux-arm64.tar.gz";
        hash = "sha512-Ezd+ymPVKoW35xJvCtawF/+9UgttldsLoF62wVJkXvQjj4o3RNKwSsQY2YVu59tzK+knqr3oSHFALDVI4f/O4g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.9/aspnetcore-runtime-10.0.9-linux-x64.tar.gz";
        hash = "sha512-o9H8VCrfwlMumorERE+wU5787DPPcz3mDNX2+P4+mloyNrmGlLJs9z2c110uG8oMaR6D1BEH3rxM+HpaspmoLQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.9/aspnetcore-runtime-10.0.9-osx-arm64.tar.gz";
        hash = "sha512-zNJDbv7nVohCQV6+QlJepAxB6iXUiopV88UmtuOJMJqcfAfkfHKrTtko0z25RhUGOVJ8jGrLwTz9/PjG2rEZYA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.9/aspnetcore-runtime-10.0.9-osx-x64.tar.gz";
        hash = "sha512-rEqeh018sSq2qZ+QqUqIljHaKKtfWxF7nJ6pE2k85uTwjlmInmc8Edm6Ne31NiOsnRgfAavr8YZCPkxK7A0ZtA==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.9";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.9/dotnet-runtime-10.0.9-linux-arm64.tar.gz";
        hash = "sha512-UPUQe0jIoJic/8o2omg0w5iKE4wVjdBiJSiXpszQmLTmYFnZC83Am6DpLRJrKA9oZobTYjMJ+ZTr9EvDgD38rA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.9/dotnet-runtime-10.0.9-linux-x64.tar.gz";
        hash = "sha512-5BP0kU55EeHNmUqgHEM8sww/UFs2n/VcbGHRMNzUMF4OB42+ncBbJ9EFFM86/OCPx3l7xk9/oNmUU4GoBfhcuQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.9/dotnet-runtime-10.0.9-osx-arm64.tar.gz";
        hash = "sha512-6KrIxX0gFa+Lo/Camoh71GktoXJfsVw1UoBxIWnLm1BFAsq03N2vLRO+lzKdxVJ4E7zupl+/vOWJIVvk8Vl86w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.9/dotnet-runtime-10.0.9-osx-x64.tar.gz";
        hash = "sha512-0VCAEhVBsB2r/GVnz6Pq/M8nxwH3MORlr1YCl5FugDRRdb1e78m42MMkJNx2IGIoLIqY5FSJ6s5ntRDbbYGaug==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.109";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.109/dotnet-sdk-10.0.109-linux-arm64.tar.gz";
        hash = "sha512-ue9VTcNGUhSvxh2Oz7Ky6cUbrwjwfMOG7zyHqmc/OPhkdDEeS+HRtGYhL4zBMIs9oBOY+MSAA8S784ByO6lQpA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.109/dotnet-sdk-10.0.109-linux-x64.tar.gz";
        hash = "sha512-Vkjo7b3YEnRSgolkyovmMboZt1qkAgvDNS86uGG4tZgtgj/Wo7s7dB7E4/3GwN6eyKUujc7azM+eh1QlBXncLQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.109/dotnet-sdk-10.0.109-osx-arm64.tar.gz";
        hash = "sha512-PtUTT6o28EhRF0wgP8Ynj0PvMw+AytE18YOYZWlf5tCCLJGMVxQgCz8z6IZShw0ptLBF4FYx4VcjolNTDaFDCQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.109/dotnet-sdk-10.0.109-osx-x64.tar.gz";
        hash = "sha512-yfVfTCJiLAsyY9X1gYMFAvpT+hMhtPNHgmbRtX45s3jKLti3SEflgnRBJKFLWjsHODcu0a9v+UcKpM/UntbIeA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk = sdk_10_0;

  sdk_10_0 = sdk_10_0_1xx;
}
