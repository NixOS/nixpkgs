{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v11.0 (preview)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "11.0.0-preview.4.26230.115";
      hash = "sha512-meGNYQOi8jBpQMo6v49GEUXlmItNKS7Gs/O1NgNkvHXgC7GEARL4R2fQANRB68aDUmv/YJYIsoNe0vEJtpm71Q==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-XGjNNdP0RYZnULe5XUwjy+xAcy6xJTRbYac+BGVtQgHcSQqMa3aEmjHhdrm5zmrk5viDmNkeVXgFdGbFyrLj4w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-dVF+cNdSNW3MUwbaOG1wItkku3TC1NdZ8UAVWXFLpdYjnXsJxa8jKYRWXNKkrhX1vSXTg9WXfVa37chiXnV2zg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-WWV0uLwFZ7VKvyPExKN/1zyNn2sZcCW2SDLRrBjm4SOzFKTun0Ry5/h3lsKhJV3W4MIfg0jzz4MkvJCoWUw6SQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-vZJuvUHupp9sQn/elRNlJV48eOnn/ipI/i9Es0iX8/K5G0gwFZM8x23RKCGguD3SixQa920iG9PIILO5vi83uA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-GPz+T9ekHDU6Cz77cZAb3j6oTWX6x7MWpQcZODG3oyYIUQDxnZDA4TyHa4oPP1M752AD/04YjDgIbc251UvfFA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-ClgjzA3FARuAGy2QzH2W+6piH1ZzTvcNu381tMJ3uG8jtXtDi0xUOUDQspe23cQfLCqN+Qsq/c6y7KKjSIOUTQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-RWBchG2utMkAYKoensBbDoLWjeOBt3V6d62UAv9SQMlw8AA/SxhITMnYivfhz7+amsl1Fkyno50qMF3Cgdhx8w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-hB544iGw687/lyH7Eef5yG+s6AOkKYct2/tkYKiigyKYCyf+c3PpNEPVDqdSvrUl9dMFZcNF82f1Cd0K5iL0Pg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-dG9xTx/svwU/510X5muBgOpnRiE9MseuVW5b6pOOKbFVMFkbBPyFJiE6OA/G5D8wFmLmhWJx7fbwIhx62S03oA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-6wKUT6orpI8OxuATEeY/w7MUlJjpOD5auqDiQBOnw3Nt7Gp8PogS8w+7KkbuGPPvGXDpv57uKKYb8QvhVS1Mew==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-KdMP3kQ1v4QY88/NUoViZ3FRhFlZ70J/a47CWQNlcO+JbtJbGaDeQHDaN1UuYzlRoiRMNnrAkP4AeiczXawZ4Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-pFT+Pl8REeUeb6k/R6M88ymFnOgT7wyXOm/Xv8NbhEbf+6a3zKujJ4unxHTMaxxOuGg951AuIDL7EJjZSnqmXg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-QXceP/hL/OmI996pgqkzK7ewK9F1JpoE50j/TXCMdFeZ9+UIclXPXmReGVVeiaF0vQn98ojHQ/T3Ek52VSXTpw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-TNvd7Vtnk2Sa8nGBm43Jpo2OUBI5AUAgxLErUhr0Jx0AjfygLyZXcA+DmQvaV/W21uK5i7gOfPpKjF1ly6VKTw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-oFkAx21lC4syl2Om26OXM+M+FSqUtVoN5xct6dV+3Y4XfB4i1wfPlvlgXP4qE2jXnIFKntr6F6xCmmT1N9itVQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-r6mLNLoAxWjp4N2/wnTY8ACedn8AdYX8gY+KcadYqp23lHChy9Av8RD5+dExiMKOrrshr8RcjdnljkqLXq6URw==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-ojhvqeG+B2wdOPhDonifLvcPUs1Qqs4RvAkWHB8W+FSEHbEeujpsZPM4stdWhyYfSYgwS4Tdhag31yCKsaGOQg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-gjHdQG7gLRo3dm0CmTGoLsYRuKY3g8Yo1xhGVrvrm3eFaEuBL9mHxt0/qHKY6Qe9glPqa8yI6i495ohmD9+Y4w==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-h73OQVRs+Ay9kWrhAYpTRn4yMyC8nfA70aZ8/PwFXp9O1/DWZJ1MlTCBmVjx+Sj2LAxxgsd/G/TeyAoXPkIubQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-rONsf1CL1LudPVWGETZGgpj24qCwk2EAWnqWz/7j0O8See6scf8qIq6UW7l8GbDite7Tk/lxdviasIc0uGgf/A==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-rTyL3lw2ZL1vpbsSzptP4qLDiIJtolSB3oszZKkAcVSxTvP0Bq9a0tgod+TUkmX23TiB3mL1VyqyXVF8NR1KRg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-sT0KbIvmMRU0RaAKq44xzTIbva+egNuCzau5YfYY3Pliu1amV1RHnzO91zKQuAMTmSw2IwQyhZBCOmF8R9ABBA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-dQjz4BoZVg0FgRIJlASPN+xFYNFEQgMOyZBCfy3WnQQ25sWvO3EY/0ghcrz63NGOOf4pZzhv+ORmfNHOZf9/CQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.4.26230.115";
        hash = "sha512-+R4FLjcOxf6eLSu63UZE3HmUjIW7CH06cvmKzGcQJqq5OGCNK8JvUsFE8/3e+Hkc2kh0xE9tseS+OMJgYtoYOw==";
      })
    ];
  };

in
rec {
  release_11_0 = "11.0.0-preview.4";

  aspnetcore_11_0 = buildAspNetCore {
    version = "11.0.0-preview.4.26230.115";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.4.26230.115/aspnetcore-runtime-11.0.0-preview.4.26230.115-linux-arm64.tar.gz";
        hash = "sha512-Xnv3UDshBlV7bia+agcdU+kXvwQJckJsnJIk0DGSTCRMC8ssqPZ9AZTxsJnmUsKjWEoNk4rBlZi9pVjbpOOwOw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.4.26230.115/aspnetcore-runtime-11.0.0-preview.4.26230.115-linux-x64.tar.gz";
        hash = "sha512-9lntUC6iwjKd65xK5eM3k/e3O/1ZqkdGH4taGAhI3nWX4LFXpKqNBiebMWPVksY1lC56CYgMiyjKN26CPaFwnQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.4.26230.115/aspnetcore-runtime-11.0.0-preview.4.26230.115-osx-arm64.tar.gz";
        hash = "sha512-bkBhBnRoQrgJDgVuTui0T22iR4J/PlxaEHz1ztWEUJrTHGP9c0f691Ymwix6fI2D/oAbHX4VDbc12WJnOD6iwg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.4.26230.115/aspnetcore-runtime-11.0.0-preview.4.26230.115-osx-x64.tar.gz";
        hash = "sha512-miv7b6QfPXfXnG6DR48Va31ca5cUATA6LrGBu8nVCLCtpRa7aHu4jFDvZbk/XDfYc1AGizl3jY2JZRUvtzxKVw==";
      };
    };
  };

  runtime_11_0 = buildNetRuntime {
    version = "11.0.0-preview.4.26230.115";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.4.26230.115/dotnet-runtime-11.0.0-preview.4.26230.115-linux-arm64.tar.gz";
        hash = "sha512-NUJukm6vqRHEWXepKakXMhjAeeKiPORE1d+/mzZtVcgOwoXmO0nnG3cdG6CVoPBNDMdn7fu1vKi6LHdiF9dPww==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.4.26230.115/dotnet-runtime-11.0.0-preview.4.26230.115-linux-x64.tar.gz";
        hash = "sha512-r0Fq6t+HE8bbEsLQSB9BY9IQRhaQB8lvLJHjtJ0FtgLPXmI5FpbnKpWdkWt/R7loZngjFiLiytd+R57aYawyJg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.4.26230.115/dotnet-runtime-11.0.0-preview.4.26230.115-osx-arm64.tar.gz";
        hash = "sha512-nYNE06waXEZk4RLBloKg3w76cAZLNSolUiwLkqDZJ674S4GYcGnouys+9a7E2Cu2wNEzFl+J4mIuDL2BKRnM4A==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.4.26230.115/dotnet-runtime-11.0.0-preview.4.26230.115-osx-x64.tar.gz";
        hash = "sha512-w84K19aT5Ve+wuDnOUl2YmET0xyIpilbeV3sHKkqvNlxGdhT2luU5FqZh1msPDYWRTQt1cfCQuezemsVz/UUgQ==";
      };
    };
  };

  sdk_11_0_1xx = buildNetSdk {
    version = "11.0.100-preview.4.26230.115";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.4.26230.115/dotnet-sdk-11.0.100-preview.4.26230.115-linux-arm64.tar.gz";
        hash = "sha512-8EiL/RfMnbtTz0OQUF/95Y79KGr42VmfU7bGUpkMcm3Pe7oEmZgqqeLZ/iII9DFm0UXsgKwmOXBHrhePKNDi8w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.4.26230.115/dotnet-sdk-11.0.100-preview.4.26230.115-linux-x64.tar.gz";
        hash = "sha512-9MdFGLyci5Kxj7rimceRaxbY/60PPhdo+3b4w7e0rTh1u4cYriMRCDMk+o1Y1q3PzD5K7Rd/JpQyty57Op3Yrg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.4.26230.115/dotnet-sdk-11.0.100-preview.4.26230.115-osx-arm64.tar.gz";
        hash = "sha512-ZWgtu/rg941V6lJZhJOeDoAv1sDXINM6G1HQ30gIi94fuHCbU7VCFeZ87yYVmBQNjWD2pwZM8NfopaY5QWp+MA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.4.26230.115/dotnet-sdk-11.0.100-preview.4.26230.115-osx-x64.tar.gz";
        hash = "sha512-jDZnR7tmeLCGE7ACYI1fK+5dE+yRdziy855ClUfeoXsHP+iQVNYzos8l1y01r0uv6Tqiel9xBuZ1RsgXfViBew==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_11_0;
    aspnetcore = aspnetcore_11_0;
  };

  sdk = sdk_11_0;

  sdk_11_0 = sdk_11_0_1xx;
}
