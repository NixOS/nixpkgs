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
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.19";
      hash = "sha512-/S++0Dv3rW4rPNY3JhGgj3r6W1F4HYoNZBlFh31ALGBLFLHHboWvo3rzHgBTqiaDcKa7SVcvnp6TBNXxNtAogQ==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.19";
        hash = "sha512-dmnFHlQBY+KOjyV743EpXggvy3Q3eNIXQjHps93CDSOl3YSKTHDffD42OPsQQtgNH3COpM1X0wPkSSw9vM/UXA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "9.0.19";
        hash = "sha512-PTBDg+gXVz595Mb+rpgGcFDrRQiOMOa/ooQ22xBCi6+Iksxjaw62ObNKMqt2IdMyQ9iQbo2/YwJpSOjYF3OLKw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "9.0.19";
        hash = "sha512-TDcG0osAruvHx4pvErZZTgyNkmfxHQfBkG7F3T3nGPsQtuk1xmaWvPPGaa1t10HE0co9Fbf2dVGgyYWW5Fc0KA==";
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
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "9.0.19";
        hash = "sha512-Rb1Tz/64/v2Sj9TGMJrsHu5YzRgfoDq0NT36fMR7lvvFvnxQkiRqHZvh4oRkQMhY06bcdqH8beSy7s0USjpqVg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "9.0.19";
        hash = "sha512-gGBk7AWAHc/VI+Q9i2Xq5irOxDtgCC6/O3eLA8HKjZKZR77J4IfxvsxrSY80f8N/cu78g1Go0/Md+EW2R1hJgA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.19";
        hash = "sha512-T7ZZVQrlscVYLhuOwLJxZB4lJ5+DI0RNcIadyC0JONfrak9QIVkzvdH5tYfGlmi3W0b9IndXxIW59He13gCgkA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.19";
        hash = "sha512-0yXYdiWh/OM2uf7kvBYvL8+AlKugO8Y3l9JIj82FhTGn7y+ANeRXhWsf/FNo7KRgJqHhDhBczrOtSLbV6AQLJg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "9.0.19";
        hash = "sha512-ZDtDza63bI7t+siOd0HBgIfAY+A3yHOTRHL+wGN/i+z8f4afDbbu9tqiZCnPGvWOsdqXYrTIjGB6n+odCZTZBw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "9.0.19";
        hash = "sha512-ZAe65sW7+sko/V91d8PLQ3MKS+c/6ziAUXBCE5vG/Yah4tEA6gHndwRM05IyV+v3Miiyb+TsUk0QCQE8ZYuwFw==";
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
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "9.0.19";
        hash = "sha512-hrqos5ZdvRWv/yJ0wrBo3H+qOyfryJJ1VQnvUgyYyJfCPLIxCAO1UZaskLEDmLfBDYDiowkWloTHlKrRSk43lQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "9.0.19";
        hash = "sha512-/y5ZthWpnBAqtQdTtVT1XnRTZg6l+5BkUeFQ9JE7ZNBRRM4p4D3a66dNcMy8/yWTRWj72C0xfg+vxfXZeV5U8w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.19";
        hash = "sha512-T1/aLuSmsEzIlfooNuu40dJGwOIa7qEqZKsdmRGig97Fv4Gvp3IaWdpUQx5yaN6vbEQIM2lbGJSgaHR2J38Sjw==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.19";
        hash = "sha512-3loojmtSv0EtMDJBVozjlkgdYcuhrjJpSDYzhhuRYKZVFdFSJLLKLBQYExowfjsiW8ZsrBTvkX0YIkyx06D/Lg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.19";
        hash = "sha512-5jstu2nsPHvj37ncl8E2cwHssENJN1Pj6MpPGwYbvujg1MoXxCSOpR1DpEI9r6jJ9vrozddGHF2BhmmmK3EOXw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.19";
        hash = "sha512-W1Gw86yp8FcpQ4qZfSYlDJwltAbw/0sCVhzlUhu2PumFuWyS+YHVO53s0hbITRsVtk+HrXg9vWMPFhHvozKscg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.19";
        hash = "sha512-2l54uhHtenxylFaKBjxleM/Btb+66ayxdfHMIg4lTe3UUCZqIfDjxAXe04mkCKQAjtWGvRBxCCSXY+NMGGeOFg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.19";
        hash = "sha512-anU2dnIwFzuXhreZW3yIGyljuhSM59H7uhd5mYbfaZTyoZpL73PkFxc8qr0E6FtHhqH/ezETqQ2ATs4LaIxQeA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.19";
        hash = "sha512-0u2vxJDYrEiEvi9IBKCsLSW/f4RQotsXoKFUilk344uS164asDqLiCVTezqn2h5bEF2BUAOJQG66zJbADAE9Jw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.19";
        hash = "sha512-c4kOo36Q6lGUWfSfVXB1gbbsXRD6Bf4GRCljOz2Q+ry1FHb++UMVkEhLxX5PJxYe7zppbGskk1lO/NLEktdM3Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.19";
        hash = "sha512-nbNA0igYxayGb5DBh43SbV0C1TXQv4tAalqoVAItBNQVJQew0sSFvGb2CV0bonyts1VwRJPTAM60vtWJt/GVaw==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.19";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.19";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.19/aspnetcore-runtime-9.0.19-linux-arm64.tar.gz";
        hash = "sha512-PHFqdI3gjES0ddin4u+Jc9jTMP6jHQdmiCY8IJxkkxjDlvjkd5tbwa4hdve2I5haDaF3u1AmXacixztq6/f66w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.19/aspnetcore-runtime-9.0.19-linux-x64.tar.gz";
        hash = "sha512-V583wq+Nvo9+PvKUwC/PbOJkn8NKuo+OrQh6m9eUQDqIUgefwPHFy+W6ujN+a5mUeGZ/7Q8F++D7j7pwZh92CA==";
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
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.19/dotnet-runtime-9.0.19-linux-arm64.tar.gz";
        hash = "sha512-4HUQxkn+3z+xPdIQJvNMi80X9Upo5MBxoSh9JuEH4J2czRPvD2PGMNMJuLeXMQqNxCrtalUesUXZ+thqWBmk7g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.19/dotnet-runtime-9.0.19-linux-x64.tar.gz";
        hash = "sha512-5/ypxafvoufa1rpgFQnGhO9Gcn46sfClGjddDf8m+gbwAe7IggM900pqEEl68w8A/wAGbBZeALHhPX2i3PXUQQ==";
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

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.120";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.120/dotnet-sdk-9.0.120-linux-arm64.tar.gz";
        hash = "sha512-g1sprrI6Gmn436+Pg6s1u5Lk5km1bsS3NA7KII2DVzHzrbyBD57/zYdPCGBK10nAWGuWhsFWP5pDv8qGSZ52xQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.120/dotnet-sdk-9.0.120-linux-x64.tar.gz";
        hash = "sha512-3D/iTpTyMWdfh0G4MxrlrVv9UAiBaFmummHAjTOMYN8CuuuXbxe4NVjAeNWNpVVPW6xT9M33k52MNN3wom9Wpw==";
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

  sdk = sdk_9_0;

  sdk_9_0 = sdk_9_0_1xx;
}
